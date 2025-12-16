#!/usr/bin/env python3
"""JSON Schema utility functions."""

import hashlib
import json
import sys
from collections.abc import Iterator, Mapping, Set
from dataclasses import dataclass
from functools import reduce
from pathlib import Path
from typing import (
    Any,
    Callable,
    Generic,
    Literal,
    Optional,
    Protocol,
    TypedDict,
    TypeGuard,
    TypeVar,
    get_args,
)
from urllib.parse import urldefrag, urljoin, urlparse
from urllib.request import urlretrieve


KEYWORD_ORDER = [
    "$schema",
    "$id",
    "$comment",
    "$ref",
    "type",
    "const",
    "enum",
    "minLength",
    "minItems",
    "title",
    "description",
    "items",
    "properties",
    "additionalProperties",
    "patternProperties",
    "default",
    "examples",
    "allOf",
    "anyOf",
    "oneOf",
    "if",
    "then",
    "else",
    "required",
    "dependentRequired",
    "unevaluatedProperties",
    "$defs",
]


def order_keyword_dict(keywords: Mapping[str, Any]) -> dict[str, Any]:
    return {k: keywords[k] for k in KEYWORD_ORDER if k in keywords} | dict(keywords)


JSONType = Literal["null", "object", "array", "string", "number", "integer", "boolean"]
JSON_TYPE_ORDER = list(get_args(JSONType))
ALL_TYPES: Set[JSONType] = frozenset(get_args(JSONType))

Schema = bool | dict[str, Any]


def order_json_types(types: Set[JSONType]) -> list[JSONType]:
    return [t for t in JSON_TYPE_ORDER if t in types]


def pretty_json_types(types: Set[JSONType]) -> list[JSONType] | JSONType:
    return next(iter(types)) if len(types) == 1 else order_json_types(types)


def is_json_schema_type(s: str) -> TypeGuard[JSONType]:
    return s in ALL_TYPES


def is_schema(obj: Any) -> TypeGuard[Schema]:
    return isinstance(obj, bool) or (
        isinstance(obj, dict) and all(isinstance(k, str) for k in obj.keys())
    )


def is_definition(obj: Any) -> TypeGuard[dict[str, Schema]]:
    return isinstance(obj, dict) and all(
        isinstance(k, str) and is_schema(v) for k, v in obj.items()
    )


def retrieve_schema(uri: str) -> Schema:
    """Retrieves schema content from cache, or otherwise from the given URI."""
    le_hash = hashlib.sha256(uri.encode(encoding="utf8")).hexdigest()
    path = Path("schemacache", f"{le_hash}.schema.json")
    path.parent.mkdir(parents=True, exist_ok=True)
    try:
        text = path.read_text()
    except FileNotFoundError:
        urlretrieve(uri, path)
        text = path.read_text()
    schema = json.loads(text)
    if not is_schema(schema):
        raise ValueError("Did non retrieve a valid JSON Schema.")
    return schema


def json_pointer(schema: Schema, pointer: str) -> Any:
    if not pointer or pointer == "/":
        return schema
    if not pointer.startswith("/"):
        raise NotImplementedError(f"Non-local pointer '{pointer}'")
    parts = pointer[1:].split("/")
    obj: Any = schema
    for part in parts:
        obj = obj[part]
    return obj


def do_url(url_str: str) -> tuple[Optional[str], str]:
    """Returns an absolute URL and fragment part.

    If `url_str` has only a fragment part, a URL of None is returned.
    """
    url = urlparse(url_str)
    if not url.netloc and not url.path:
        return None, url.fragment
    base_url = "https://schema.bundesmessenger.dev/kubernetes/dummy.schema.json"
    return urldefrag(urljoin(base_url, url_str))


def follow_ref(schema: Schema, ref_value: str) -> tuple[Schema, str]:
    abs_url, frag = do_url(ref_value)
    if not abs_url:
        return schema, frag
    return retrieve_schema(abs_url), frag


def is_local_ref(ref: str) -> bool:
    return ref.startswith("#")


def type_list(schema: Any) -> Optional[list[JSONType]]:
    """JSON types listed in the schema’s "type" keyword.

    None if the keyword was not given.
    """
    try:
        schema_type = schema["type"]
    except KeyError:
        return None
    if isinstance(schema_type, str):
        ts = [schema_type]
    elif isinstance(schema_type, list):
        if all(isinstance(t, str) for t in schema_type):
            ts = schema_type
    else:
        raise ValueError(
            f"Expected str or list[str] for property 'type', got "
            f"'{type(schema_type)}'"
        )
    valid_types = [t for t in ts if is_json_schema_type(t)]
    if invalid_types := set(ts) - set(valid_types):
        raise ValueError(f"Type keyword contains invalid types '{invalid_types}'")
    return valid_types


def types(schema: Schema) -> set[JSONType]:
    if schema is False:
        return set()
    if schema is True:
        return set(ALL_TYPES)
    if not isinstance(schema, dict):
        raise TypeError(f"Schema got invalid type {type(schema)}.")
    if (ls := type_list(schema)) is None:
        return set(ALL_TYPES)
    return set(ls)


@dataclass(frozen=True)
class Node:
    types: Set[JSONType]
    children: dict[str, "Node"]
    items: Optional["Node"]
    keywords: dict[str, Any]
    refs: dict[str, "Node"]

    @staticmethod
    def default() -> "Node":
        return Node(ALL_TYPES, children={}, items=None, keywords={}, refs={})

    @staticmethod
    def from_types(types: Set[JSONType] = frozenset()) -> "Node":
        return Node(types, children={}, items=None, keywords={}, refs={})

    @staticmethod
    def from_schema(schema: Schema) -> "Node":
        keywords = schema if isinstance(schema, dict) else {}
        return Node(
            types(schema),
            children={},
            items=None,
            keywords=keywords,
            refs={},
        )

    def make_ref(self, uri: str) -> "Node":
        # Do not adopt children outside of our schema.
        children = self.children if is_local_ref(uri) else {}
        return Node(
            self.types, children=children, items=None, keywords={}, refs={uri: self}
        )

    def make_child(self: "Node", name: str) -> "Node":
        """Returns a new node with self as child of the given name."""
        return Node(
            ALL_TYPES,
            children={name: self},
            items=None,
            keywords={},
            refs={},
        )

    def make_item(self: "Node") -> "Node":
        return Node(
            ALL_TYPES,
            children={},
            items=self,
            keywords={},
            refs={},
        )

    def merge(self, node: "Node") -> "Node":
        """Merges two trees so that all properties and common types are kept.

        The property structure is merged by uniting all branches. Types are
        taken over as is; if there is a collision, their intersection is used.
        """
        children = {}
        for key in (self.children | node.children).keys():
            a = self.children.get(key, Node.default())
            b = node.children.get(key, Node.default())
            children[key] = a.merge(b)

        return Node(
            self.types & node.types,
            children,
            items=self.items or node.items,
            keywords=self.keywords | node.keywords,
            refs=self.refs | node.refs,
        )

    def merge_subnode(self, node: "Node") -> "Node":
        def child(key: str) -> "Node":
            a = self.children.get(key, Node.default())
            b = node.children.get(key, Node.default())
            return a.merge_subnode(b)

        return Node(
            self.types & node.types,
            children={k: child(k) for k in self.children | node.children},
            items=self.items or node.items,
            keywords={},
            refs=self.refs | node.refs,
        )

    def merge_subnode_union(self, node: "Node") -> "Node":
        def child(key: str) -> "Node":
            a = self.children.get(key, Node.default())
            b = node.children.get(key, Node.default())
            return a.merge_subnode_union(b)

        return Node(
            self.types | node.types,
            children={k: child(k) for k in self.children | node.children},
            items=self.items or node.items,
            keywords={},
            refs=self.refs | node.refs,
        )

    def inverse(self) -> "Node":
        """Returns the tree as hull of the `not`-keyword."""
        return Node(
            # Whether types are restricted depends on the other subschema
            # keywords. Evaluating those is out-of-scrope, so we must assume all
            # types possible.
            types=ALL_TYPES,
            children={k: v.inverse() for k, v in self.children.items()},
            items=self.items.inverse() if self.items else None,
            keywords={},
            refs={uri: ref.inverse() for uri, ref in self.refs.items()},
        )

    def to_schema(self, is_root: bool = False) -> Schema:
        def properties() -> dict[str, "Node"]:
            lexical_children = {
                k: c
                for k, c in self.children.items()
                if k in self.keywords.get("properties", {})
            }
            return lexical_children

        def required() -> list[str]:
            return [
                name
                for name, child in self.children.items()
                if "null" not in child.types
            ]

        def unevaluatedProperties() -> Optional[Schema]:
            if self.types == ALL_TYPES or "object" not in self.types:
                return None
            if not is_schema(p := self.keywords.get("unevaluatedProperties")):
                return False
            return p

        filtered_keywords = {
            k: v for k, v in self.keywords.items() if k not in ["required"]
        }

        return order_keyword_dict(
            filtered_keywords
            | ({"items": self.items.to_schema()} if self.items else {})
            | (
                {"properties": {k: v.to_schema() for k, v in ps.items()}}
                if (ps := properties())
                else {}
            )
            | (
                {"type": pretty_json_types(self.types)}
                if self.types != ALL_TYPES
                else {}
            )
            | ({"required": r} if (r := required()) else {})
            | (
                {"unevaluatedProperties": p}
                if (p := unevaluatedProperties()) is not None
                else {}
            )
        )

    def to_json(self, *args: Any, **kwargs: Any) -> str:
        return json.dumps(self.to_schema(is_root=True), *args, **kwargs)


def type_tree_hull(schema: Schema, pointer: str = "/") -> Node:
    funcs: FuncDict[Node] = {
        "lift": Node.from_schema,
        "combine": Node.merge,
        "properties": lambda ps: reduce(
            Node.merge,
            (Node.make_child(p, k) for k, p in ps.items()),
            Node.default(),
        ),
        "additionalProperties": lambda t: Node.default(),
        "items": Node.make_item,
        "allOf": lambda ts: reduce(Node.merge_subnode, ts, Node.default()),
        "anyOf": lambda ts: reduce(Node.merge_subnode_union, ts, Node.from_types()),
        "oneOf": lambda ts: reduce(Node.merge_subnode_union, ts, Node.from_types()),
        "not_": Node.inverse,
        "ref_": lambda uri: Node.make_ref(
            type_tree_hull(*follow_ref(schema, uri)),
            uri,
        ),
    }
    return resolve_subschemas(schema, funcs)


T = TypeVar("T")


@dataclass(frozen=True)
class BundleNode:
    schema: Schema
    refs: dict[str, Schema]

    @staticmethod
    def default() -> "BundleNode":
        return BundleNode(schema=True, refs=dict())

    @staticmethod
    def from_schema(schema: Schema) -> "BundleNode":
        return BundleNode(schema=schema, refs=dict())

    @staticmethod
    def from_ref(
        schema: Schema, ref_value: str, bundle: Callable[[Schema, str], "BundleNode"]
    ) -> "BundleNode":
        abs_url, frag = do_url(ref_value)
        if not abs_url:
            return bundle(schema, frag)

        ref_schema = retrieve_schema(abs_url)
        # Use "/" as pointer instead of the actual fragment. This bundles
        # additional schemas that are not actually required by us, but are still
        # accessed by some JSON Schema implementations.
        ref_node = bundle(ref_schema, "/")

        return BundleNode(schema=True, refs={abs_url: ref_schema} | ref_node.refs)

    def combine(self, other: "BundleNode") -> "BundleNode":
        return BundleNode(self.schema, self.refs | other.refs)

    def to_json(self, *args: Any, **kwargs: Any) -> str:
        if not isinstance(self.schema, dict):
            return json.dumps(self.schema, *args, **kwargs)
        bundled_defs = {"$defs": self.schema["$defs"] | dict(sorted(self.refs.items()))}
        return json.dumps(self.schema | bundled_defs, *args, **kwargs)


def bundle(schema: Schema, pointer: str = "/") -> BundleNode:
    """Walks sub-schemas, recording any external $refs."""

    def combineAll(*others: "BundleNode") -> "BundleNode":
        return reduce(BundleNode.combine, others, BundleNode.default())

    funcs: FuncDict[BundleNode] = {
        "lift": BundleNode.from_schema,
        "combine": BundleNode.combine,
        "properties": lambda ps: combineAll(*ps.values()),
        "additionalProperties": lambda x: x,
        "items": lambda x: x,
        "allOf": lambda ts: combineAll(*ts),
        "anyOf": lambda ts: combineAll(*ts),
        "oneOf": lambda ts: combineAll(*ts),
        "not_": lambda x: x,
        "ref_": lambda ref: BundleNode.from_ref(schema, ref, bundle),
    }
    return resolve_subschemas(json_pointer(schema, pointer), funcs)


# FuncDict = TypedDict("FuncDict", {"not": Callable[[T], T]})
class FuncDict(TypedDict, Generic[T]):
    lift: Callable[[Schema], T]
    combine: Callable[[T, T], T]
    items: Callable[[T], T]
    properties: Callable[[Mapping[str, T]], T]
    additionalProperties: Callable[[T], T]
    allOf: Callable[[Iterator[T]], T]
    anyOf: Callable[[Iterator[T]], T]
    oneOf: Callable[[Iterator[T]], T]
    not_: Callable[[T], T]
    ref_: Callable[[str], T]


def resolve_subschemas(schema: Schema, funcs: FuncDict[T]) -> T:
    """Returns the combined results of subschemas.

    Args:
      * `schema`: The given schema to resolve subschemas for.
      * `funcs`: Dictionary of functions to call for each type of subschema.
        Functions correspond to the JSON Schema keywords of the same name.
        Additionally, `lift` and `combine` must be given:
          - `lift` turns the given Schema into T.
          - `combine` combines two Ts into a new T.
    """

    def rec(subschema: Schema) -> T:
        return resolve_subschemas(subschema, funcs)

    results = [funcs["lift"](schema)]

    if isinstance(schema, bool):
        return results[0]

    if is_schema(it := schema.get("items")):
        results.append(funcs["items"](rec(it)))
    if isinstance(sd := schema.get("properties"), dict):
        results.append(funcs["properties"]({k: rec(s) for k, s in sd.items()}))
    if isinstance(s := schema.get("additionalProperties"), dict):
        results.append(funcs["additionalProperties"](rec(s)))
    if isinstance(sl := schema.get("allOf"), list):
        results.append(funcs["allOf"](rec(s) for s in sl))
    if isinstance(sl := schema.get("anyOf"), list):
        results.append(funcs["anyOf"](rec(s) for s in sl))
    if isinstance(sl := schema.get("oneOf"), list):
        results.append(funcs["oneOf"](rec(s) for s in sl))
    if is_schema(sub := schema.get("not")):
        results.append(funcs["not_"](rec(sub)))
    if isinstance(ref := schema.get("$ref"), str):
        results.append(funcs["ref_"](ref))

    return reduce(funcs["combine"], results)


class SchemaResult(Protocol):
    """Required methods to be used by the CLI."""

    def to_json(self, *args: Any, **kwargs: Any) -> str: ...


def main() -> None:
    def usage(err_msg: str) -> int:
        script_name = (sys.argv[:1] or ["__main__.py"])[0]
        print(err_msg, file=sys.stderr)
        print(f"Usage: {script_name} <lint|bundle> <JSON Schema file>", file=sys.stderr)
        print(f"\n{__doc__}", file=sys.stderr)
        exit(1)

    if len(sys.argv) > 3:
        exit(usage("Too many arguments."))
    if not (command := (sys.argv[1:] or [""])[0]):
        exit(usage("No command provided."))
    if command not in ["lint", "bundle"]:
        exit(usage(f"Command must be 'lint' or 'bundle', was {command}."))
    if not (paths := sys.argv[2:]):
        if sys.stdin.isatty():
            exit(usage("No schema file provided."))
    schemafile = (paths or ["-"])[0]

    def load_json(path: str) -> Any:
        if path == "-":
            return json.load(sys.stdin)
        with open(path) as f:
            return json.load(f)

    schema = load_json(schemafile)

    COMMANDS: dict[str, Callable[[Schema], SchemaResult]] = {
        "lint": type_tree_hull,
        "bundle": bundle,
    }

    result = COMMANDS[command](schema)
    print(result.to_json(indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()

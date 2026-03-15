#!/usr/bin/env python3
"""
merge-upstream.py

Merges structural changes from an updated upstream values.yaml into the
local (English-translated) values.yaml.

Strategy:
- Uses difflib to identify changes between old and new upstream
- For unchanged lines: keeps the existing English translation
- For new/modified lines: inserts the new German text with a # TODO:TRANSLATE marker
- For removed lines: removes them from the local file
- For non-comment lines (actual YAML values): applies changes directly
"""
import argparse
import difflib
import re
import sys


def is_comment_line(line: str) -> bool:
    """Check if a line is a YAML comment."""
    stripped = line.strip()
    return stripped.startswith('#') and not stripped.startswith('#!')


def is_blank_or_separator(line: str) -> bool:
    """Check if a line is blank or a visual separator."""
    stripped = line.strip()
    return stripped == '' or re.match(r'^#{2,}\s*$', stripped) is not None


def normalize_whitespace(line: str) -> str:
    """Normalize a line for comparison (strip trailing whitespace)."""
    return line.rstrip()


def merge_upstream(upstream_old_path: str, upstream_new_path: str,
                   local_path: str, output_path: str):
    with open(upstream_old_path, 'r', encoding='utf-8') as f:
        old_lines = f.readlines()
    with open(upstream_new_path, 'r', encoding='utf-8') as f:
        new_lines = f.readlines()
    with open(local_path, 'r', encoding='utf-8') as f:
        local_lines = f.readlines()

    # Build a mapping from old upstream lines to local translated lines
    # This maps line index in old upstream -> line content in local
    # We assume the files have the same structure (same number of lines, same order)
    # which is true for values.yaml forks

    # Use difflib to get opcodes between old upstream and new upstream
    old_stripped = [normalize_whitespace(l) for l in old_lines]
    new_stripped = [normalize_whitespace(l) for l in new_lines]

    matcher = difflib.SequenceMatcher(None, old_stripped, new_stripped)
    opcodes = matcher.get_opcodes()

    result = []
    todo_count = 0

    for tag, i1, i2, j1, j2 in opcodes:
        if tag == 'equal':
            # These lines are unchanged in upstream - use our local translation
            for idx in range(i1, i2):
                if idx < len(local_lines):
                    result.append(local_lines[idx])
                else:
                    result.append(old_lines[idx])

        elif tag == 'replace':
            # Lines changed in upstream
            for idx in range(j1, j2):
                new_line = new_lines[idx]
                if is_comment_line(new_line) and not is_blank_or_separator(new_line):
                    # Comment changed - needs translation
                    result.append(new_line)
                    # Add TODO marker after the German comment
                    indent = re.match(r'^(\s*)', new_line).group(1)
                    result.append(f"{indent}# TODO:TRANSLATE above line from German\n")
                    todo_count += 1
                else:
                    # Non-comment line (actual YAML value) or separator - take as-is
                    result.append(new_line)

        elif tag == 'insert':
            # New lines added in upstream
            for idx in range(j1, j2):
                new_line = new_lines[idx]
                if is_comment_line(new_line) and not is_blank_or_separator(new_line):
                    result.append(new_line)
                    indent = re.match(r'^(\s*)', new_line).group(1)
                    result.append(f"{indent}# TODO:TRANSLATE above line from German\n")
                    todo_count += 1
                else:
                    result.append(new_line)

        elif tag == 'delete':
            # Lines removed in upstream - skip them (don't include in output)
            pass

    with open(output_path, 'w', encoding='utf-8') as f:
        f.writelines(result)

    print(f"Merged upstream changes into {output_path}")
    if todo_count > 0:
        print(f"  {todo_count} lines marked with # TODO:TRANSLATE need review")
    else:
        print("  No new translations needed (only structural/value changes)")


def main():
    parser = argparse.ArgumentParser(
        description='Merge upstream values.yaml changes into translated local copy')
    parser.add_argument('--upstream-old', required=True,
                        help='Path to the previous upstream values.yaml reference')
    parser.add_argument('--upstream-new', required=True,
                        help='Path to the new upstream values.yaml')
    parser.add_argument('--local', required=True,
                        help='Path to the local translated values.yaml')
    parser.add_argument('--output', required=True,
                        help='Path to write the merged output')
    args = parser.parse_args()

    merge_upstream(args.upstream_old, args.upstream_new,
                   args.local, args.output)


if __name__ == '__main__':
    main()

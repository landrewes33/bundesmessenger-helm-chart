#!/bin/bash
# sync-upstream.sh
# Fetches latest upstream changes, identifies what changed in values.yaml,
# and prepares a diff for translation review.
#
# Usage: ./sync-upstream.sh [--apply] [--translate]
#   Without flags: shows what changed (dry run)
#   --apply: merges structural changes and marks lines needing translation
#   --translate: after --apply, calls Claude Code to translate TODO:TRANSLATE lines

set -euo pipefail

UPSTREAM_REF="upstream-values.yaml"
LOCAL_FILE="values.yaml"
DIFF_OUTPUT="translation-needed.diff"
UPSTREAM_BRANCH="origin/main"

# Colours
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Upstream Sync Tool ===${NC}"
echo ""

# 1. Fetch latest from origin
echo -e "${YELLOW}Fetching latest from origin...${NC}"
git fetch origin

# 2. Get current upstream commit and last-synced commit
CURRENT_UPSTREAM=$(git rev-parse origin/main)
if git tag -l "last-upstream-sync" | grep -q "last-upstream-sync"; then
    LAST_SYNC=$(git rev-parse last-upstream-sync)
    echo "Last synced commit:    ${LAST_SYNC:0:12}"
else
    LAST_SYNC=""
    echo "Last synced commit:    (none - first sync)"
fi
echo "Current upstream HEAD: ${CURRENT_UPSTREAM:0:12}"
echo ""

# 3. Check if upstream-values.yaml reference exists
if [ ! -f "$UPSTREAM_REF" ]; then
    echo -e "${RED}Error: $UPSTREAM_REF not found.${NC}"
    echo "Run: git show origin/main:values.yaml > upstream-values.yaml"
    exit 1
fi

# 4. Extract new upstream values.yaml
git show "${UPSTREAM_BRANCH}:values.yaml" > /tmp/new-upstream-values.yaml

# 5. Compare old and new upstream
if diff -q "$UPSTREAM_REF" /tmp/new-upstream-values.yaml > /dev/null 2>&1; then
    echo -e "${GREEN}No changes in upstream values.yaml since last sync.${NC}"
    rm /tmp/new-upstream-values.yaml
    exit 0
fi

echo -e "${YELLOW}Changes detected in upstream values.yaml:${NC}"
echo ""

# Show a summary of changes
ADDED=$(diff "$UPSTREAM_REF" /tmp/new-upstream-values.yaml | grep "^>" | wc -l | tr -d ' ')
REMOVED=$(diff "$UPSTREAM_REF" /tmp/new-upstream-values.yaml | grep "^<" | wc -l | tr -d ' ')
echo "  Lines added:   $ADDED"
echo "  Lines removed: $REMOVED"
echo ""

# Generate the full diff
diff -u "$UPSTREAM_REF" /tmp/new-upstream-values.yaml > "$DIFF_OUTPUT" || true
echo -e "Full diff saved to: ${GREEN}${DIFF_OUTPUT}${NC}"
echo ""

if [ "${1:-}" = "--apply" ]; then
    echo -e "${YELLOW}Applying structural changes...${NC}"

    # Run the merge script
    python3 merge-upstream.py \
        --upstream-old "$UPSTREAM_REF" \
        --upstream-new /tmp/new-upstream-values.yaml \
        --local "$LOCAL_FILE" \
        --output "$LOCAL_FILE"

    # Update the reference file
    cp /tmp/new-upstream-values.yaml "$UPSTREAM_REF"

    # Tag the sync point
    git tag -f last-upstream-sync "$CURRENT_UPSTREAM"

    echo ""
    echo -e "${GREEN}Merge complete.${NC}"

    TODO_COUNT=$(grep -c "TODO:TRANSLATE" "$LOCAL_FILE" || true)
    if [ "$TODO_COUNT" -gt 0 ]; then
        echo "$TODO_COUNT lines need translation."

        if [ "${2:-}" = "--translate" ] || [ "${1:-}" = "--translate" ]; then
            echo ""
            echo -e "${YELLOW}Calling Claude Code to translate...${NC}"
            env -u CLAUDECODE -u CLAUDE_CODE_ENTRYPOINT \
                claude -p \
                --allowedTools "Read,Edit,Grep" \
                --permission-mode acceptEdits \
                "In $(pwd)/values.yaml, find every comment line marked with '# TODO:TRANSLATE above line from German'. For each one:
1. Read the German comment line immediately ABOVE the TODO marker
2. Use the Edit tool to replace that German comment AND the TODO marker line with just the English translation, preserving exact indentation, the # prefix, and any (type) annotation like (string), (bool), (list), (map), (integer)
3. Remove the '# TODO:TRANSLATE above line from German' marker line

Do not change any non-comment lines (actual YAML keys/values). Do not change lines already in English."

            REMAINING=$(grep -c "TODO:TRANSLATE" "$LOCAL_FILE" || true)
            echo ""
            echo -e "${GREEN}Translation complete.${NC}"
            if [ "$REMAINING" -gt 0 ]; then
                echo -e "${YELLOW}  $REMAINING lines still need manual review.${NC}"
            else
                echo "  All lines translated successfully."
            fi
        else
            echo ""
            echo "To auto-translate, re-run with:"
            echo "  ./sync-upstream.sh --apply --translate"
            echo ""
            echo "Or translate manually and remove # TODO:TRANSLATE markers."
        fi
    else
        echo "No translations needed (only structural/value changes)."
    fi

    echo ""
    echo "When done: git add values.yaml upstream-values.yaml && git commit"
else
    echo "Run with --apply to merge changes into your local values.yaml"
    echo ""
    echo "Preview the diff:"
    echo "  cat $DIFF_OUTPUT"
    echo "  # or"
    echo "  less $DIFF_OUTPUT"
fi

rm -f /tmp/new-upstream-values.yaml

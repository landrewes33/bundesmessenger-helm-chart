# CLAUDE.md

## Project Overview

This is an English translation fork of the BundesMessenger Backend Helm Chart, a Helm chart for deploying a Matrix/Synapse-based messaging backend. The original project is developed by BWI GmbH for the German federal government.

## Repository Structure

| Remote | URL | Purpose |
|--------|-----|---------|
| `origin` | `https://gitlab.opencode.de/bwi/bundesmessenger/backend/helm-chart.git` | Original German upstream |
| `english` | `git@github.com:landrewes33/bundesmessenger-helm-chart.git` | This English translation fork |

## Scripts

### translate_values.py
Comprehensive German-to-English translation script for `values.yaml`. Contains a large dictionary of German phrase to English phrase mappings. Applies string replacements across the file, translating comments while leaving YAML keys and values untouched.

### final_translate.py
A second-pass translation script using regex patterns for remaining German text in comments. Handles word-level replacements (articles, prepositions, verbs, nouns) that the phrase-based `translate_values.py` missed. Only modifies comment lines.

### final_fix.py
A cleanup script for fixing garbled translations from the earlier passes. Contains explicit old-string to new-string replacements for lines where automated word-level translation produced incorrect English.

### merge-upstream.py
Merges structural changes from an updated upstream `values.yaml` into the local English-translated copy. Uses `difflib` to diff old vs new upstream, then:
- **Unchanged lines**: keeps existing English translation
- **New/modified comment lines**: inserts new German text with `# TODO:TRANSLATE` marker
- **Removed lines**: removes from output
- **Non-comment lines**: applies directly

Usage:
```bash
python3 merge-upstream.py \
  --upstream-old values.yaml.old \
  --upstream-new values.yaml.new \
  --local values.yaml \
  --output values.yaml.merged
```

## Workflow

### Syncing upstream changes
1. Fetch from `origin`: `git fetch origin`
2. Save current upstream reference: `cp values.yaml values.yaml.old`
3. Get new upstream: `git show origin/main:values.yaml > values.yaml.new`
4. Run merge: `python3 merge-upstream.py --upstream-old values.yaml.old --upstream-new values.yaml.new --local values.yaml --output values.yaml`
5. Search for `# TODO:TRANSLATE` markers and translate manually
6. Commit and push to `english` remote

## Branch-Specific Files

- **`ENGLISH.README.md`** — README for this (english) remote.

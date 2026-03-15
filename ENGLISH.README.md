# BundesMessenger Backend Helm Chart (English Translation)

The BundesMessenger is a secure communication solution for the German public administration. General information about the overall project can be found in the [BundesMessenger Repository](https://gitlab.opencode.de/bwi/bundesmessenger/info).

This repository contains the Helm chart for the automated deployment of the BundesMessenger backend.

## Components

The Helm chart provides the following components:

- [Synapse (Matrix Homeserver)](https://github.com/element-hq/synapse)
- [Matrix-Authentication-Service (User management and authentication service)](https://github.com/element-hq/matrix-authentication-service)
- WellKnown-Service (Delegation via HTTPS, without requiring DNS changes)
- [Admin-Portal (Administration interface)](https://gitlab.opencode.de/bwi/bundesmessenger/admin-portal)
- [Sygnal](https://github.com/element-hq/sygnal) Push server for Google and Apple
- [BundesMessenger WebClient](https://gitlab.opencode.de/bwi/bundesmessenger/clients/bundesmessenger-web)
- Call infrastructure
- [Redis](https://redis.io/) In-memory database
- [Matrix-Content-Scanner](https://github.com/vector-im/matrix-content-scanner-python)
- [ClamAV (optional)](https://www.clamav.net/)
- Kubernetes Ingress resources

> :warning: DMZ, PAP, or comparable infrastructures are not included.

## Repository Remotes

This is an English translation fork of the original German upstream:

| Remote | URL | Purpose |
|--------|-----|---------|
| `origin` | `https://gitlab.opencode.de/bwi/bundesmessenger/backend/helm-chart.git` | Original German upstream |
| `english` | `git@github.com:landrewes33/bundesmessenger-helm-chart.git` | This English translation fork |

## Translation Scripts

This fork includes Python scripts for managing the German-to-English translation:

- **`translate_values.py`** — Primary phrase-level translation of `values.yaml` comments
- **`final_translate.py`** — Second-pass word-level regex translation for remaining German
- **`final_fix.py`** — Cleanup of garbled translations from automated passes
- **`merge-upstream.py`** — Merges new upstream changes into the translated `values.yaml`, marking new German text with `# TODO:TRANSLATE`

## Syncing with Upstream

When the upstream (origin) releases a new version:

```bash
# 1. Fetch latest upstream
git fetch origin

# 2. Save current upstream reference
cp values.yaml values.yaml.old
git show origin/main:values.yaml > values.yaml.new

# 3. Merge upstream changes, preserving translations
python3 merge-upstream.py \
  --upstream-old values.yaml.old \
  --upstream-new values.yaml.new \
  --local values.yaml \
  --output values.yaml

# 4. Translate any new TODO:TRANSLATE markers
grep -n "TODO:TRANSLATE" values.yaml

# 5. Commit and push
git add values.yaml
git commit -m "Merge upstream changes and translate"
git push english englishtranslation
```

## Architecture

The Helm chart provides a complete Matrix backend architecture. Detailed architecture documentation is available in the [docs/](docs/) directory (German original at [docs/architektur.md](docs/architektur.md)).

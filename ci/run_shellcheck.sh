#!/usr/bin/env sh
# Run ShellCheck for all shell scripts in the repo.

find . -name "*.sh" -exec shellcheck '{}' +

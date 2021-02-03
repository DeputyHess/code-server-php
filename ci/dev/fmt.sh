#!/usr/bin/env bash
set -euo pipefail

main() {
  cd "$(dirname "$0")/../.."

  shfmt -i 2 -w -sr $(git ls-files "*.sh" | grep -v "lib/vscode")

  local prettierExts
  prettierExts=(
    "*.js"
    "*.ts"
    "*.tsx"
    "*.html"
    "*.json"
    "*.css"
    "*.md"
    "*.toml"
    "*.yaml"
    "*.yml"
  )
  prettier --write --loglevel=warn $(
    git ls-files "${prettierExts[@]}" | grep -v "lib/vscode" | grep -v 'helm-chart'
  )

  doctoc --title '# FAQ' docs/FAQ.md > /dev/null
  doctoc --title '# Setup Guide' docs/guide.md > /dev/null
  doctoc --title '# Install' docs/install.md > /dev/null
  doctoc --title '# npm Install Requirements' docs/npm.md > /dev/null
  doctoc --title '# Contributing' docs/CONTRIBUTING.md > /dev/null
  doctoc --title '# iPad' docs/ipad.md > /dev/null

  if [[ ${CI-} && $(git ls-files --other --modified --exclude-standard) ]]; then
    echo "Files need generation or are formatted incorrectly:"
    git -c color.ui=always status | grep --color=no '\[31m'
    echo "Please run the following locally:"
    echo "  yarn fmt"
    exit 1
  fi
}

main "$@"

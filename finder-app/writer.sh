#!/bin/bash
# writer.sh - create/overwrite a file with given string, create parent dirs if needed
# Usage: writer.sh /full/path/to/file "string to write"

set -euo pipefail

writefile="${1:-}"
writestr="${2:-}"

if [[ -z "$writefile" || -z "$writestr" ]]; then
  echo "writer.sh error: missing arguments"
  echo "Usage: $0 /full/path/to/file \"text to write\""
  exit 1
fi

parentdir=$(dirname "$writefile")
if ! mkdir -p "$parentdir"; then
  echo "writer.sh error: could not create directory $parentdir"
  exit 1
fi

if ! printf "%s" "$writestr" > "$writefile"; then
  echo "writer.sh error: could not write to $writefile"
  exit 1
fi

exit 0

#!/bin/bash
# finder.sh - count files and lines matching a search string in a directory tree
# Usage: finder.sh /path/to/dir "searchstr"

set -euo pipefail

filesdir="${1:-}"
searchstr="${2:-}"

if [[ -z "$filesdir" || -z "$searchstr" ]]; then
  echo "finder.sh error: missing required arguments"
  echo "Usage: $0 /path/to/dir \"searchstring\""
  exit 1
fi

if [[ ! -d "$filesdir" ]]; then
  echo "finder.sh error: $filesdir is not a directory"
  exit 1
fi

file_count=$(find "$filesdir" -type f | wc -l)
matching_lines=$(grep -R --line-number -F -- "$searchstr" "$filesdir" 2>/dev/null | wc -l)

echo "The number of files are $file_count and the number of matching lines are $matching_lines"
exit 0

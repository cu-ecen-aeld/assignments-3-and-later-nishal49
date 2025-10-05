#!/bin/bash
# finder.sh - count files and matching lines in a directory
# Usage: finder.sh <directory> "<search string>"

set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <directory> \"<search string>\"" >&2
  exit 1
fi

DIR=$1
SEARCH=$2

# ensure directory exists
if [ ! -d "$DIR" ]; then
  echo "Error: directory '$DIR' not found" >&2
  exit 1
fi

# count regular files (not directories)
FILE_COUNT=$(find "$DIR" -maxdepth 1 -type f | wc -l)

# count matching occurrences: use grep -F (fixed string), -o to output each match, -h to suppress filenames
# If grep returns non-zero because no matches, handle gracefully
MATCH_COUNT=0
if grep -F -h -o -- "$SEARCH" "$DIR"/* 2>/dev/null | grep -q .; then
  MATCH_COUNT=$(grep -F -h -o -- "$SEARCH" "$DIR"/* 2>/dev/null | wc -l)
else
  MATCH_COUNT=0
fi

# Print exactly the expected format
echo "The number of files are ${FILE_COUNT} and the number of matching lines are ${MATCH_COUNT}"
exit 0

#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXEC="$SCRIPT_DIR/writer"
if [ ! -x "$EXEC" ]; then
  echo "Error: $EXEC not found or not executable" >&2
  exit 1
fi
"$EXEC" "$@"

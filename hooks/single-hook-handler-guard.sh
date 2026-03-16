#!/bin/bash
# Hook: PreToolUse (Write|Edit) — enforce one handler per workflow hook file
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty' 2>/dev/null)
[[ -z "$FILE_PATH" ]] && exit 0

# Only check workflow hook files
echo "$FILE_PATH" | grep -qE 'src/workflows/hooks/.*\.ts$' || exit 0

# If file already exists and has a handler, warn about adding a second
if [[ -f "$FILE_PATH" ]]; then
  EXISTING_EXPORTS=$(grep -c 'export\s\+\(default\|const\|function\)' "$FILE_PATH" 2>/dev/null || echo 0)
  if [[ $EXISTING_EXPORTS -gt 0 ]]; then
    NEW_CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // empty' 2>/dev/null)
    if [[ -n "$NEW_CONTENT" ]]; then
      NEW_EXPORTS=$(echo "$NEW_CONTENT" | grep -c 'export\s\+\(default\|const\|function\)' || echo 0)
      if [[ $NEW_EXPORTS -gt 1 ]]; then
        echo '{"decision":"block","reason":"Only ONE handler per workflow hook file. Use the orchestrator pattern: one exported handler that calls multiple functions internally. See CLAUDE.md conventions."}' 
        exit 0
      fi
    fi
  fi
fi

exit 0

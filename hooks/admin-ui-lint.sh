#!/bin/bash
# Hook: PostToolUse (Write|Edit) — warn on admin UI anti-patterns
# Informational only (exit 0) — Claude sees warnings and self-corrects
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty' 2>/dev/null)
[[ -z "$FILE_PATH" ]] && exit 0

# Only check admin TSX files
echo "$FILE_PATH" | grep -qE 'src/admin/.*\.tsx$' || exit 0
[[ -f "$FILE_PATH" ]] || exit 0

CONTENT=$(cat "$FILE_PATH")
WARNINGS=""

# Check: Container without divide-y p-0
if echo "$CONTENT" | grep -q '<Container' && ! echo "$CONTENT" | grep -qE 'className="[^"]*divide-y[^"]*p-0'; then
  WARNINGS="${WARNINGS}\n⚠ Container should use className=\"divide-y p-0\" pattern"
fi

# Check: Multiple primary buttons
PRIMARY_COUNT=$(echo "$CONTENT" | grep -c 'variant="primary"' || echo 0)
# Also count Button without variant (default is primary)
DEFAULT_COUNT=$(echo "$CONTENT" | grep -cE '<Button[^>]*>' | grep -cv 'variant=' || echo 0)
if [[ $((PRIMARY_COUNT)) -gt 1 ]]; then
  WARNINGS="${WARNINGS}\n⚠ Multiple primary buttons found ($PRIMARY_COUNT). Only one primary action per view."
fi

# Check: DataTable without empty state hint
if echo "$CONTENT" | grep -q 'DataTable' && ! echo "$CONTENT" | grep -qE '(empty|no.*found|no.*yet|emptyState)'; then
  WARNINGS="${WARNINGS}\n⚠ DataTable found but no empty state detected. Add empty state for when data is empty."
fi

# Check: Form/mutation without loading state
if echo "$CONTENT" | grep -q 'useMutation' && ! echo "$CONTENT" | grep -qE '(isPending|isLoading|isSubmitting|disabled.*Pending)'; then
  WARNINGS="${WARNINGS}\n⚠ useMutation found but no loading state on submit button. Use isPending to disable button during submission."
fi

# Check: Raw HTML elements that should be Medusa UI
if echo "$CONTENT" | grep -qE '<(button|table|select|textarea|input)\b[^/]' && ! echo "$CONTENT" | grep -qE 'from.*@medusajs/ui'; then
  WARNINGS="${WARNINGS}\n⚠ Raw HTML elements detected. Use @medusajs/ui components (Button, DataTable, Select, etc.)"
fi

if [[ -n "$WARNINGS" ]]; then
  echo -e "Admin UI lint warnings for $(basename "$FILE_PATH"):$WARNINGS"
fi

exit 0

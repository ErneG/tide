#!/bin/bash
# Hook: PreToolUse (Write|Edit) — block dangerous business logic patterns
# Blocks: model.number() for money fields, async workflow composition, ledger mutations
# Warns: createStep without compensation

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty' 2>/dev/null)
[[ -z "$FILE_PATH" ]] && exit 0

# Get the content being written
NEW_CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // empty' 2>/dev/null)
[[ -z "$NEW_CONTENT" ]] && exit 0

# ── Check 1: Money fields must use bigNumber, not number ──
if echo "$FILE_PATH" | grep -qE 'src/modules/.*/models/.*\.ts$'; then
  if echo "$NEW_CONTENT" | grep -qE 'model\.number\(\)' && echo "$NEW_CONTENT" | grep -qiE '(price|cost|amount|total|fee|tax|discount|subtotal)'; then
    echo '{"decision":"block","reason":"Money fields must use model.bigNumber(), not model.number(). Fields containing price/cost/amount/total/fee/tax/discount must use bigNumber for precision."}' 
    exit 0
  fi
fi

# ── Check 2: Workflow composition must be synchronous ──
if echo "$FILE_PATH" | grep -qE 'src/workflows/[^/]+\.(ts|tsx)$'; then
  if echo "$NEW_CONTENT" | grep -qE 'createWorkflow\([^)]*,\s*async'; then
    echo '{"decision":"block","reason":"Workflow composition functions must be synchronous in Medusa v2. Remove the async keyword from the createWorkflow callback. Use transform() for async data manipulation between steps."}' 
    exit 0
  fi
fi

# ── Check 3: Ledger immutability ──
if echo "$FILE_PATH" | grep -qE 'src/modules/inventory-ledger/'; then
  if echo "$NEW_CONTENT" | grep -qE '(async\s+update|async\s+delete|\.update\(|\.delete\()' && ! echo "$NEW_CONTENT" | grep -qE 'throw.*NOT_ALLOWED'; then
    echo '{"decision":"block","reason":"Inventory ledger entries are immutable. Do not add update/delete methods to the ledger service. Create reversal entries instead."}' 
    exit 0
  fi
fi

# ── Check 4: Warn on createStep without compensation (informational) ──
if echo "$FILE_PATH" | grep -qE 'src/workflows/.*/steps/.*\.ts$'; then
  if echo "$NEW_CONTENT" | grep -qE 'createStep\(' && ! echo "$NEW_CONTENT" | grep -qE 'createStep\([^,]+,[^,]+,'; then
    # createStep with only 2 args (no compensation). Warn but don't block.
    echo "Warning: createStep() without compensation function detected. Add a compensation function as the third argument for rollback support." >&2
  fi
fi

exit 0

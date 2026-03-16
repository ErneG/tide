# Tide v0.3 — Implementation Plan

## Research Inputs
- agent-browser capability map (snapshot, diff, eval with axe-core, annotated screenshots)
- Plugin integration architecture (3 hooks, 3 scripts, 9 skills, 0 new agents)
- Scaffold templates (extracted from actual manufacturer/intake codebase patterns)
- Business logic invariants (money fields, workflow compensation, status transitions)

---

## Phase 1: Zero-Dependency Quality Hooks (3 files)

### Task 1: Business Logic Guard Hook
**File**: `hooks/business-logic-guard.sh`
**Event**: PreToolUse (Write|Edit)
**What it blocks**:
- `model.number()` for fields containing "price", "cost", "amount", "total" → must use `model.bigNumber()`
- `async` keyword on workflow composition functions (Medusa v2 requires synchronous)
- Modifications to ledger service update/delete methods (immutability)
**What it warns**: `createStep()` without compensation function
**Confidence**: high — pure grep, no deps

### Task 2: Hook Handler Guard
**File**: `hooks/single-hook-handler-guard.sh`
**Event**: PreToolUse (Write|Edit)
**Blocks**: Writing a second handler to `src/workflows/hooks/*.ts` when one exists
**Confidence**: high

### Task 3: Admin UI Lint Hook
**File**: `hooks/admin-ui-lint.sh`
**Event**: PostToolUse (Write|Edit) for `src/admin/**/*.tsx`
**Warns (exit 0, not blocking)**:
- `Container` without `divide-y p-0`
- Multiple `variant="primary"` buttons in same component
- Missing loading/empty state patterns
**Confidence**: medium — pattern matching may have false positives

### Task 4: Update hooks.json
Add 3 new entries to existing hooks.json

---

## Phase 2: Verification Scripts + Verifier Upgrade (4 files)

### Task 5: Module Integrity Verifier
**File**: `scripts/verify-modules.sh`
**Logic**: Cross-reference `src/modules/` dirs vs `medusa-config.ts` vs `MODULE_NAMES.ts`
**Called by**: verifier agent (Gate 0), `/tide:verify modules`

### Task 6: Route Validation Checker
**File**: `scripts/verify-routes.sh`
**Logic**: For every route using `req.validatedBody`, verify zod schema + middleware entry
**Called by**: verifier agent (Gate 0.5), `/tide:verify routes`

### Task 7: agent-browser Verification Suite
**File**: `scripts/browser-verify.sh`
**Uses agent-browser for**:
- Page load check: `open` + `errors` + `get count "h1"`
- Accessibility audit: `eval` with injected axe-core
- Heading hierarchy: `eval` extracting all h1-h6 with computed styles
- Empty state detection: `eval` checking for empty tables, skeleton loaders
- Button hierarchy: `eval` finding all buttons and their variants
- Authenticated session: `--profile ~/.medusa-admin`
**Called by**: verifier agent (Gate 3: browser), `/tide:verify browser`

### Task 8: Update verifier agent
**File**: `agents/verifier.md` (modify existing)
**New gates**: 0 (modules), 0.5 (routes), 3 enhanced (browser uses agent-browser suite)

---

## Phase 3: Scaffold Commands (1 file)

### Task 9: Scaffold Skill
**File**: `skills/tide-scaffold/SKILL.md`
**Sub-commands**:
- `/tide:scaffold module <name>` — model + service + index + MODULE_NAMES + medusa-config
- `/tide:scaffold route <module> <admin|store>` — routes + zod + middleware
- `/tide:scaffold widget <module> <zone>` — Container + useQuery + loading + empty
- `/tide:scaffold link <moduleA> <moduleB>` — defineLink + hook handler warning
- `/tide:scaffold page <module>` — list page + create page with DataTable pattern
**Templates**: embedded in the skill as code blocks with {{placeholders}}
**Confidence**: high — templates extracted from real codebase

---

## Phase 4: Setup Commands (5 files)

### Task 10: ESLint Setup
**File**: `skills/tide-setup-eslint/SKILL.md`
**Installs**: `eslint eslint-plugin-react eslint-plugin-jsx-a11y`
**Configures**: `react/forbid-elements` (ban raw HTML), `jsx-a11y/*` rules
**One-time command**: `/tide:setup eslint`

### Task 11: OpenTelemetry Setup
**File**: `skills/tide-setup-otel/SKILL.md`
**Creates/copies**: `src/instrumentation.ts` with Jaeger exporter
**One-time command**: `/tide:setup otel`

### Task 12: Accessibility Testing Setup
**File**: `skills/tide-setup-a11y/SKILL.md`
**Installs**: `@axe-core/playwright`
**Creates**: helper + example test
**One-time command**: `/tide:setup a11y`

### Task 13: Postgres MCP Setup
**File**: `skills/tide-setup-postgres-mcp/SKILL.md`
**Adds**: `crystaldba/postgres-mcp` to `.mcp.json`
**One-time command**: `/tide:setup postgres-mcp`

### Task 14: Debugger MCP Setup
**File**: `skills/tide-setup-debugger-mcp/SKILL.md`
**Adds**: `@hyperdrive-eng/mcp-nodejs-debugger` to `.mcp.json`
**One-time command**: `/tide:setup debugger-mcp`

---

## Phase 5: Data Integrity (2 files)

### Task 15: Data Integrity Checker
**Files**: `scripts/verify-data.sh` + `scripts/verify-data.sql`
**SQL checks**:
- Orphaned products (no variants), variants (no prices)
- Ledger pair integrity (every pair_id has 2 entries summing to 0)
- Stuck intakes (processing >1 hour)
- Inventory balance reconciliation
**Requires**: `psql` or postgres-mcp
**Called by**: `/tide:verify data`

---

## File Summary

| Phase | New Files | Modified Files |
|-------|-----------|---------------|
| 1 | 3 hook scripts | hooks.json |
| 2 | 3 scripts | agents/verifier.md, skills/tide-verify/SKILL.md |
| 3 | 1 skill | — |
| 4 | 5 skills | — |
| 5 | 2 scripts | agents/verifier.md |
| **Total** | **14 new** | **3 modified** |

## Key Design Decisions

1. **No new agents** — all verification goes through existing verifier as gates
2. **Hooks are grep-based** — fast, no npm deps, sub-second execution
3. **Admin UI lint is warning-only** (exit 0) — design is subjective, don't block
4. **Business logic guard blocks** (exit 2) — money bugs are not subjective
5. **agent-browser for ALL browser verification** — axe-core via eval, heading audit via eval, empty state via eval. One tool, many checks.
6. **Setup skills are one-shot** — configure project once, then CI/hooks benefit permanently
7. **Scripts are the reusable unit** — called by agents, skills, and CI

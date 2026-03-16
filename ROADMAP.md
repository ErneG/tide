# Tide Plugin Roadmap

## Research Summary

4 parallel research agents analyzed: Medusa dev workflow gaps (read actual codebase + git history), runtime monitoring tools, design verification tools, and e-commerce business logic checks.

---

## Tier 1: Highest Impact (based on actual rework frequency)

### 1. Scaffold Commands
Eliminates the #1 rework pattern: forgotten module registration.

- `/tide:scaffold module <name>` — generates model + service + migration + MODULE_NAMES + medusa-config entry
- `/tide:scaffold route <module> <admin|store>` — route + zod schema + middleware registration
- `/tide:scaffold widget <module> <zone>` — Container + useQuery + loading + empty state
- `/tide:scaffold link <moduleA> <moduleB>` — defineLink + hook handler update

### 2. ESLint Component Enforcement
Bans raw HTML where Medusa UI components exist. 30-minute setup.

```js
"react/forbid-elements": ["error", { forbid: [
  { element: "button", message: "Use <Button> from @medusajs/ui" },
  { element: "table", message: "Use DataTable from @medusajs/ui" },
  { element: "select", message: "Use <Select> from @medusajs/ui" },
  { element: "input", message: "Use <Input> from @medusajs/ui" },
  { element: "textarea", message: "Use <Textarea> from @medusajs/ui" },
]}]
```

### 3. Module Integrity Verifier (`/tide:verify modules`)
Cross-references three sources of truth:
- Directories in `src/modules/`
- Entries in `medusa-config.ts`
- Exports in `src/shared/MODULE_NAMES.ts`

Reports mismatches. Currently: `file-s3-organized` on disk but not in config.

### 4. Route Validation Checker (`/tide:verify routes`)
For every route using `req.validatedBody`, verify zod schema + middleware entry exists.

---

## Tier 2: Quality Gates

### 5. Business Logic Guard (PreToolUse hook)
Block file writes that:
- Use `model.number()` for fields containing "price", "cost", "amount", "total" (should be `bigNumber()`)
- Create workflow steps without compensation functions
- Add `async` to workflow composition functions (must be synchronous in Medusa v2)
- Modify ledger entry update/delete methods (immutability guard)

### 6. Accessibility Testing
`@axe-core/playwright` — runtime a11y checks alongside E2E tests.

```bash
yarn add -D @axe-core/playwright
```

### 7. Visual Regression
Playwright built-in `toHaveScreenshot()` — free, already in stack.

### 8. Single Hook Handler Guard (PreToolUse)
Before writing to `src/workflows/hooks/`, check if handler already exists. One orchestrator per hook.

---

## Tier 3: Monitoring & Observability

### 9. Enable OpenTelemetry
`src/instrumentation.ts` already exists in intakes-rework worktree. Copy to main. Jaeger already in docker-compose.

### 10. Postgres MCP Pro
`crystaldba/postgres-mcp` — index tuning, EXPLAIN ANALYZE, slow queries, health checks.

```json
{ "command": "docker", "args": ["run", "-i", "--rm", "crystaldba/postgres-mcp", "--access-mode=unrestricted", "--connection-url", "${DATABASE_URL}"] }
```

### 11. Node.js Debugger MCP
`@hyperdrive-eng/mcp-nodejs-debugger` — breakpoints, variable inspection.

```json
{ "command": "npx", "args": ["@hyperdrive-eng/mcp-nodejs-debugger"] }
```

### 12. Data Integrity Checker (`/tide:verify data`)
SQL queries for:
- Orphaned records (products without variants, variants without prices)
- Ledger pair integrity (every pair_id has exactly 2 entries summing to 0)
- Stuck intakes (processing status >1 hour)
- Inventory balance vs Medusa stocked_quantity reconciliation

---

## Tier 4: Design Enforcement

### 13. Design Token Linting
`@lapidist/design-lint` — flags raw colors/spacing values that should use tokens.

### 14. Tailwind Token Enforcement
`eslint-plugin-tailwindcss` `no-custom-classname` — flags Tailwind classes not in the Medusa UI preset.

### 15. Admin UI Lint Hook
PostToolUse hook after Write/Edit to `src/admin/**/*.tsx`:
- Every `Container` uses `divide-y p-0` pattern
- Every `DataTable` has empty state
- Every form has loading state on submit button
- Only one primary button per section

---

## Priority Order (Implementation Sequence)

1. Scaffold commands (prevents most common bugs)
2. ESLint forbid-elements (30 min, instant value)
3. Module integrity verifier (catches drift)
4. Business logic guard hook (prevents money/workflow bugs)
5. Route validation checker (prevents unvalidated input)
6. Enable OpenTelemetry (copy existing file)
7. Accessibility testing (add @axe-core/playwright)
8. Postgres MCP Pro (add to .mcp.json)
9. Data integrity checker (SQL verification)
10. Design token linting (when eslint-plugin-tailwindcss v4 stable)

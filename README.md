# Tide — Autonomous Development Engine

Claude Code plugin for full-cycle AI-driven development with UX-aware planning,
worktree isolation, verification gates, and deployment integration.

## What Makes Arc Different

1. **UX-aware planning** — explores existing UI before proposing changes. Prevents
   "3 translation UIs" problems where AI builds incoherent features.
2. **Worktree lifecycle** — automatic Neon DB branching, .env patching, port allocation,
   dependency install per worktree.
3. **Quality gates** — type-check on every edit, Semgrep security scan on commit,
   quality sentinel before Claude stops, UX verification with agent-browser.
4. **Deployment integration** — Coolify deploy as a pipeline phase.
5. **Observability** — cost tracking, rework rate (DORA 5th metric).

## Install

```bash
# Development (load from disk)
claude --plugin-dir ~/Documents/GitHub/tide-plugin

# From marketplace (once published)
claude plugin marketplace add ErneG/tide-plugin
claude plugin install tide@ErneG/tide-plugin
```

## Commands

| Command | What it does |
|---------|-------------|
| `/tide:start <name>` | Create worktree + Neon branch + env |
| `/tide:plan <description>` | UX-aware planning with coherence check |
| `/tide:go` | Approve plan, start implement → verify → review loop |
| `/tide:verify` | Standalone verification (typecheck + tests + browser) |
| `/tide:ship` | Push + create PR with metrics |
| `/tide:deploy` | Merge + Coolify deploy + health check |
| `/tide:teardown <name>` | Clean up worktree + Neon branch |
| `/tide:status` | Show feature progress |
| `/tide:metrics` | Rework rate + cost summary |
| `/tide:fix <desc>` | Quick fix without full pipeline |

## Prerequisites

- [agent-browser](https://github.com/vercel-labs/agent-browser) — `npm i -g agent-browser && agent-browser install`
- [neonctl](https://neon.tech/docs/reference/cli-install) — `brew install neonctl` (for DB branching)
- [semgrep](https://semgrep.dev/) — `brew install semgrep` (for security scanning)
- [jq](https://jqlang.github.io/jq/) — `brew install jq`

## Project Setup

After installing, create `.tide/config.json` in your project:

```json
{
  "db_strategy": "neon",
  "neon": { "project_id": "your-neon-project-id" },
  "deploy": {
    "app_uuid": "your-coolify-app-uuid",
    "health_url": "https://your-app.com/health"
  }
}
```

## License

MIT

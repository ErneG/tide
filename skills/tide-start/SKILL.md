---
name: tide:start
description: >
  Initialize a new feature with worktree, Neon DB branch, and state files.
  Triggers: "tide start", "start feature", "new feature".
allowed-tools: Read, Write, Bash, Grep, Glob
---

# /tide:start — Initialize Feature

## Arguments

- `<feature-name>` — required, lowercase letters/numbers/hyphens only
- `--here` — skip worktree, use current directory

## Process

1. **Validate** name: `^[a-z][a-z0-9-]*$`, max 50 chars
2. **Create worktree** (unless --here):
   ```bash
   git worktree add .tide/worktrees/<name> -b feature/<name>
   ```
   WorktreeCreate hook fires automatically: Neon branch + .env + yarn install + port
3. **Create state**: `mkdir -p .tide/features/<name>`
4. **Initialize STATE.json** from template with feature name, branch, timestamp
5. **Initialize DECISIONS.md** with feature description from user
6. **Set active feature**: `echo "<name>" > .tide/active-feature`
7. **Read port** from `.tide/worktree-ports` manifest
8. **CRITICAL: cd into the worktree**:
   The WorktreeCreate hook prints the worktree path to stdout, which tells Claude Code
   to change directory automatically. If this didn't happen (e.g. skill-initiated worktree),
   you MUST cd manually:
   ```bash
   cd .tide/worktrees/<name>
   ```
   ALL subsequent work happens inside the worktree, NEVER in the main repo.
   The main repo must stay on master — it may have other worktrees depending on it.
   **Verify** you're in the right directory before proceeding:
   ```bash
   pwd  # Must end with .tide/worktrees/<name> or .claude/worktrees/<name>
   ```

## Output

```
[tide] Feature '<name>' ready!
  Worktree:  .tide/worktrees/<name>
  Neon DB:   wt/<name>
  Dev port:  <port>

  You are now in the worktree. All work happens here.
  Next: /tide:plan <description>
```

## Rules

- ALWAYS cd into the worktree after creating it
- NEVER checkout feature branches in the main repo
- NEVER run `yarn dev` or modify files in the main repo when a worktree exists
- The main repo stays on master at all times

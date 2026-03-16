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

## Output

```
[tide] Feature '<name>' ready!
  Worktree:  .tide/worktrees/<name>
  Neon DB:   wt/<name>
  Dev port:  <port>

  Next: /tide:plan <description>
```

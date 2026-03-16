---
name: tide:teardown
description: >
  Clean up worktree, Neon DB branch, and feature state.
  Triggers: "tide teardown", "clean up feature", "remove worktree".
allowed-tools: Read, Bash
---

# /tide:teardown — Clean Up Feature

1. Verify feature exists in `.tide/features/<name>/`
2. Warn if phase != "done"
3. Remove worktree: `git worktree remove .tide/worktrees/<name> --force`
   (WorktreeRemove hook handles Neon branch deletion + port cleanup)
4. Delete branch if merged: `git branch -d feature/<name>`
5. Archive state: `mv .tide/features/<name> .tide/features/_archive/<name>`
6. Clear active-feature if it matches

```
[tide] Teardown complete: <name>
  Worktree: removed
  Neon DB: deleted
  State: archived
```

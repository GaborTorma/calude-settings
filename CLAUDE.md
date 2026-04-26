@~/.claude/rules/karpathy-guidelines.md
@~/.claude/rules/solid.md
@~/.claude/rules/stack.md

@~/.claude/rules/episodic-memory.md
@~/.claude/rules/context7.md
@~/.claude/rules/socraticode.md

@~/.claude/rules/enviroment.md
@~/.claude/rules/git.md
@~/.claude/rules/pm2.md

## Nyelvválasztás

- **Web app (frontend + backend)** → NodeJS, TypeScript
- **AI, automatizálás, bot, script** → Python

<!-- lean-ctx -->
<!-- lean-ctx-claude-v2 -->

## lean-ctx — Context Runtime

Always prefer lean-ctx MCP tools over native equivalents:

- `ctx_read` instead of `Read` / `cat` (cached, 10 modes, re-reads ~13 tokens)
- `ctx_shell` instead of `bash` / `Shell` (90+ compression patterns)
- `ctx_search` instead of `Grep` / `rg` (compact results)
- `ctx_tree` instead of `ls` / `find` (compact directory maps)
- Native Edit/StrReplace stay unchanged. If Edit requires Read and Read is unavailable, use `ctx_edit(path, old_string, new_string)` instead.
- Write, Delete, Glob — use normally.

Full rules: @~/.claude/rules/lean-ctx.md

Verify setup: run `/mcp` to check lean-ctx is connected, `/memory` to confirm this file loaded.

<!-- /lean-ctx -->

# ClaudeCodeMD - Manual Placement Guide

This directory contains Claude Code configuration files that must be placed **manually**.
They are NOT handled by `setup.ps1`.

## File Placement

| File in this directory | Copy to | Scope | Notes |
|---|---|---|---|
| `CLAUDE.md` | `<project-root>/CLAUDE.md` | Per project | Edit project name after copying |
| `.claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Global (all projects) | Do once per machine |
| `.claude/SUBAGENT.md` | `~/.claude/SUBAGENT.md` | Global (all projects) | Do once per machine |

## Steps

1. **Global setup (once per machine)**
   ```powershell
   Copy-Item -Path ".claude\CLAUDE.md"   -Destination "$env:USERPROFILE\.claude\CLAUDE.md"   -Force
   Copy-Item -Path ".claude\SUBAGENT.md" -Destination "$env:USERPROFILE\.claude\SUBAGENT.md" -Force
   ```

2. **Per-project setup**
   ```powershell
   Copy-Item -Path "CLAUDE.md" -Destination "<project-root>\CLAUDE.md" -Force
   # Then edit the project name in <project-root>\CLAUDE.md
   ```

## Notes

- **AGENTS.md** is handled automatically by `setup.ps1` (Step 5) — do not place manually.
- `CLAUDE.md` contains a hardcoded project name (`DHF2_Unity / Model.Unity`) — update it for each new project.
- `~/.claude/` files apply to all Claude Code sessions across all projects.

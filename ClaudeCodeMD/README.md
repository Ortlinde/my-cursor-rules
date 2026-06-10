# ClaudeCodeMD - Manual Placement Guide

This directory contains Claude Code configuration files that must be placed **manually**.

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

- **AGENTS.md** is in the repo root — copy to the project root if needed, or let `/syncSkills` regenerate it.
- `CLAUDE.md` uses `<Project_Name>` as a placeholder — replace it after copying to each project.
- `~/.claude/` files apply to all Claude Code sessions across all projects.
- **Project-specific skills** (e.g. `sharelogger-usage`) are NOT installed globally. Copy them manually to `<project-root>/.claude/skills/` for projects that need them. Source: `d:\Workspace\eztools\plugin\unity-dev-rules\skills\`.

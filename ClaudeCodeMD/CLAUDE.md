# Project Rules: DHF2_Unity / Model.Unity

> Global rules apply first. This file adds project-specific overrides and context.
> Global rules: `~/.claude/CLAUDE.md` and `~/.claude/SUBAGENT.md`

---

## Project Context

- Unity project, Windows, C#
- Framework: WT.Foundation, WT.FrameSync.FishWeb (DLL)
- Skills registry: `AGENTS.md`

---

## Logging (Project Override)

NEVER use Debug.Log, Debug.LogWarning, Debug.LogError, print(), or Console.WriteLine.

ALWAYS use ShareLogger:
- Add: `using WT.Foundation.Loggers;`
- Use: `ShareLogger.Instance.FuncInfo()` / `.Warn()` / `.Error()`

Skill: `.claude/skills/sharelogger-usage/SKILL.md`

---

## FrameSync Postmortem (High Risk)

Read `.cursor/postmortem/project-specific/framesync-provider.md` when working with:
- ReplicaRoom, FrameUpdate, or DLL Provider APIs
- OnSpawn* / OnDespawn* event handlers
- Any PerformManager: Player, Bullet, Fort, Target

**Critical rule (P001):** During FrameUpdate callbacks, use `Find*Object<T>()` (pool path), NOT `Find*()` (DLL Provider path).

---

## Project Postmortem DB

General bug patterns: `.cursor/postmortem/categories/`
- `unity-lifecycle.md` -- Awake/Start/OnEnable/OnDestroy issues
- `unity-editor.md` -- EditorWindow, CustomEditor issues
- `async-patterns.md` -- Coroutine, async/await issues
- `memory-management.md` -- Event subscriptions, memory leaks
- `architecture.md` -- Circular deps, design patterns

Project-specific: `.cursor/postmortem/project-specific/framesync-provider.md`

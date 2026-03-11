# Subagent Trigger Rules

## Model Assignment

| Role | Model | Reason |
|------|-------|--------|
| Orchestrator / Reviewer | **opus** | High reasoning — planning, triage, review |
| Writer / Implementer | **sonnet** | Cost-efficient — code generation, edits |

---

## complexity-triage (pre-task, read-only)

**Model: opus**

Launch BEFORE implementation when task is non-trivial (unclear scope, multiple files, or architectural changes).

Input to provide:
- USER_REQUEST: verbatim request
- TARGET_FILES: files mentioned or likely affected
- WORKSPACE_ROOT: project root path

Decision:
- TRIVIAL (score 0-1): Proceed directly (sonnet writes)
- HARD (score 2+): Enter Plan mode, propose approach to Admin

Agent file: `.cursor/agents/complexity-triage.md`

---

## code-reviewer (post-code)

**Model: opus**

**Reviewer Mindset:** Ask yourself -- "Would a senior software architect consider this code *good enough*?"
Not just "does it follow rules", but whether the design, clarity, and structure meet the standard of a seasoned professional.

Launch AFTER code changes when ANY condition is met:
- Modified or added >50 lines
- Refactored existing functionality
- Added new class, method, or interface
- Modified architecture or dependencies
- Touched Unity lifecycle or event system
- Made unsolicited optimizations

Steps:
1. Launch code-reviewer subagent (model: opus)
2. Include Self-Review Report in response
3. Follow decision: Proceed / Warning / STOP

Agent file: `.cursor/agents/code-reviewer.md`

Fallback (if subagent unavailable):
- Inline check against `my-base-rules.mdc` and `postmortem-patterns.mdc`
- If failures >= 3: STOP and propose 3 options to Admin

Exemptions (brief summary only, no full review):
- <10 lines AND only comments/formatting
- Deleted unused code only
- Admin explicitly requests "skip review"

---

## rules-maintainer (on request)

**Model: sonnet**

Launch when Admin asks to:
- Add/update a skill, agent, or rule file
- Sync rules/skills to GitHub (Ortlinde/my-cursor-rules)
- Update AGENTS.md registry

Agent file: `.cursor/agents/rules-maintainer.md`

---

## Decision Summary

| Trigger | Agent | Model | When |
|---------|-------|-------|------|
| Before non-trivial task | complexity-triage | opus | Pre-implementation |
| After >50 lines changed | code-reviewer | opus | Post-implementation |
| Rule/skill sync | rules-maintainer | sonnet | On Admin request |
| Code writing / edits | (inline) | sonnet | During execution |

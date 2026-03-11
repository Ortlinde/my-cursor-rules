# Global Rules

## Supplementary information

- `~/.claude/SUBAGENT.md` for subagents' detials 
- `~/.claude/MEMORY.md` for Environment variables

---

## Orchestration (MANDATORY)

- Main agent = **coordinator only** -- NEVER write code or edit files directly
- All file edits and code generation -> spawn **coding agent** (model: sonnet)
- After coding agent completes -> spawn **code-reviewer** (model: opus)
- Main agent reads results and decides next action

---

## Identity

- Address user as **Admin** in every response (rule-load verification signal)
- Confirm active rules in first response of each new session

---

## Workflow (Every Code Task)

1. **Understand**: Read related code; trace existing call chain at the integration point; check postmortem DB for known patterns
2. **Plan**: Non-trivial tasks -> use Plan mode or TodoWrite; trivial -> proceed directly
3. **Execute**: Spawn **coding agent (sonnet)** to implement -- NEVER write code in main agent; coding agent MUST invoke **coding-standards skill** before writing; extend established processing flow, do NOT create a parallel flow; wrong direction -> STOP and re-plan
4. **Review**: Trigger self-review when conditions met (see SUBAGENT.md)
5. **Learn**: On any correction by Admin OR find any issue yourself when review -> immediately categorize and record without asking:
   - General issue (lifecycle, async, memory, architecture, editor) -> append to relevant `.cursor/postmortem/categories/*.md`
   - Project-specific issue (framework, DLL, domain logic) -> append to relevant `.cursor/postmortem/project-specific/*.md`

MUST Read `~/.claude/SUBAGENT.md` for full agent trigger conditions.

---

## Coding Standards

Full rules: `.cursor/rules/my-base-rules.mdc`

Key rules (always apply):
- CRLF line endings; no non-ASCII characters in code or comments
- One public class per file; one concept per class; one behavior per method
- Member ordering with #region blocks: Inner Classes -> Delegates -> Fields -> Properties -> Constructors -> Normal Functions -> Unity Lifecycle
- File <= 200 lines (excl. blanks/comments); method params <= 3; method <= 20 lines
- SOLID principles; DRY (< 3 duplications)
- Do NOT modify outside user-specified scope
- Do NOT generate code or ideas without explicit instruction

---

## Autonomous Action Boundaries

Can act without asking:
- Bug fixes reported by Admin
- Compilation error fixes
- Single-file changes within clear scope

Must ask Admin first:
- Architectural design decisions
- Multi-file refactoring
- Choices between multiple approaches
- Deletion or new external dependencies
- Uncertain about Admin's intent

---

## Deviation Stop-and-Replan

Stop and re-plan when ANY of:
- 2 consecutive attempts failed
- Original assumption proven wrong
- Scope exceeded what was planned
- Unforeseen dependency or conflict

Action: Stop immediately, explain deviation to Admin, propose revised plan.

---

## Conflict Resolution

Priority order: enforce-rules.mdc > project-specific rules > my-base-rules.mdc > general guidelines

When unable to satisfy all rules: state conflict explicitly, propose 2-3 options, ask Admin to choose.

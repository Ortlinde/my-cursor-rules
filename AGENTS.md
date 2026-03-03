# AGENTS

<skills_system priority="1">

## Available Skills

<!-- SKILLS_TABLE_START -->
<usage>
When users ask you to perform tasks, check if any of the available skills below can help complete the task more effectively. Skills provide specialized capabilities and domain knowledge.

How to use skills:
- Invoke: `npx openskills read <skill-name>` (run in your shell)
  - For multiple: `npx openskills read skill-one,skill-two`
- The skill content will load with detailed instructions on how to complete the task
- Base directory provided in output for resolving bundled resources (references/, scripts/, assets/)

Usage notes:
- Only use skills listed in <available_skills> below
- Do not invoke a skill that is already loaded in your context
- Each skill invocation is stateless
</usage>

<available_skills>

<!-- PROJECT-SPECIFIC skills (this project only, not copied globally) -->

<skill>
<name>sharelogger-usage</name>
<description>Enforce using ShareLogger for logging in Unity code. Use when the user asks to print to console, add logs, or when code includes Debug.Log, print(), or Console.WriteLine. Replace those with ShareLogger.Instance.FuncInfo/Warn/Error.</description>
<location>project</location>
</skill>

<!-- GLOBAL skills (copied to ~/.claude/skills/, available in all projects) -->

<skill>
<name>coding-standards</name>
<description>Detailed coding standards, style guides, and architectural patterns for Unity development. Use this skill when the user asks about code style, refactoring, best practices, or when you need to verify if code meets detailed quality standards (beyond the basic MUST rules).</description>
<location>global</location>
</skill>

<skill>
<name>self-review</name>
<description>Standardized code review process including Self-Analysis Report and Risk Checklist. Use when finishing code modifications >50 lines, refactoring, or when instructed by rules.</description>
<location>global</location>
</skill>

<skill>
<name>deliberate-development</name>
<description>Enforce a deliberate, phased approach to code development. AI must understand existing concepts first (Phase 1), then design abstractions/skeletons (Phase 2), then implement details (Phase 3). Use when adding features, refactoring, or extending architectural components.</description>
<location>global</location>
</skill>

<!-- Official OpenSkills (global, synced via openskills sync) -->

</available_skills>
<!-- SKILLS_TABLE_END -->

</skills_system>

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

<!-- 以下為自訂 Skills，官方 OpenSkills 會在 openskills sync 時自動加入 -->

<skill>
<name>coding-standards</name>
<description>Detailed coding standards, style guides, and architectural patterns for Unity development. Use this skill when the user asks about code style, refactoring, best practices, or when you need to verify if code meets detailed quality standards (beyond the basic MUST rules).</description>
<location>project</location>
</skill>

<skill>
<name>self-review</name>
<description>Standardized code review process including Self-Analysis Report and Risk Checklist. Use when finishing code modifications >50 lines, refactoring, or when instructed by rules.</description>
<location>project</location>
</skill>

</available_skills>
<!-- SKILLS_TABLE_END -->

</skills_system>

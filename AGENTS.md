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
<name>coding-standards</name>
<description>Invoke before writing, editing, or reviewing any Unity code to apply detailed style guides, naming conventions, architecture patterns, and refactoring strategies; also use when the user asks about code quality or best practices.</description>
<location>project</location>
</skill>

<skill>
<name>deliberate-development</name>
<description>Enforce a 3-phase Understand->Design->Implement workflow when adding features, refactoring, or extending architectural components; requires conceptual analysis and design approval before any implementation begins.</description>
<location>project</location>
</skill>

<skill>
<name>self-review</name>
<description>Run a standardized risk-and-compliance review after code modifications >50 lines or refactoring; generates a Self-Analysis Report and decides Proceed/Warn/Stop based on violation count against coding rules and postmortem patterns.</description>
<location>project</location>
</skill>

<skill>
<name>sharelogger-usage</name>
<description>Replace Debug.Log, print(), and Console.WriteLine with ShareLogger.Instance.FuncInfo/Warn/Error when adding logs or reviewing Unity code; adds the required using WT.Foundation.Loggers namespace.</description>
<location>project</location>
</skill>

<!-- GLOBAL skills (~/.claude/skills/, available in all projects) -->

<skill>
<name>algorithmic-art</name>
<description>Generate algorithmic art using p5.js with seeded randomness and interactive parameters; use when users request code-based art, generative art, flow fields, or particle systems.</description>
<path>~/.claude/skills/algorithmic-art/</path>
<location>global</location>
</skill>

<skill>
<name>brainstorm</name>
<description>Guide divergent thinking via interactive Q&A; always use when user mentions brainstorm, 發想, 腦力激盪, or asks to generate ideas, explore options, or think creatively — leads structured divergent-thinking questions instead of flat idea lists.</description>
<path>~/.claude/skills/brainstorm/</path>
<location>global</location>
</skill>

<skill>
<name>brand-guidelines</name>
<description>Apply Anthropic's official brand colors and typography to artifacts; use when brand colors, visual formatting, or company design standards apply.</description>
<path>~/.claude/skills/brand-guidelines/</path>
<location>global</location>
</skill>

<skill>
<name>canvas-design</name>
<description>Create beautiful visual art as .png/.pdf using design philosophy; use when user asks for posters, artwork, or other static visual designs.</description>
<path>~/.claude/skills/canvas-design/</path>
<location>global</location>
</skill>

<skill>
<name>claude-api</name>
<description>Build apps with the Claude API or Anthropic SDK; trigger when code imports anthropic/@anthropic-ai/sdk/claude_agent_sdk or user asks to use Claude API/Anthropic SDKs.</description>
<path>~/.claude/skills/claude-api/</path>
<location>global</location>
</skill>

<skill>
<name>doc-coauthoring</name>
<description>Guide a structured workflow for co-authoring documentation; use when user wants to write docs, proposals, technical specs, or decision docs.</description>
<path>~/.claude/skills/doc-coauthoring/</path>
<location>global</location>
</skill>

<skill>
<name>docx</name>
<description>Create, read, edit, or manipulate Word (.docx) files; use whenever user mentions Word doc, .docx, or requests reports/memos/letters as Word documents.</description>
<path>~/.claude/skills/docx/</path>
<location>global</location>
</skill>

<skill>
<name>find-skills</name>
<description>Help users discover and install agent skills when they ask "find a skill for X" or express interest in extending capabilities.</description>
<path>~/.claude/skills/find-skills/</path>
<location>global</location>
</skill>

<skill>
<name>frontend-design</name>
<description>Create distinctive, production-grade frontend interfaces; use when user asks to build web components, pages, dashboards, React components, or any HTML/CSS UI.</description>
<path>~/.claude/skills/frontend-design/</path>
<location>global</location>
</skill>

<skill>
<name>internal-comms</name>
<description>Write internal communications (status reports, leadership updates, newsletters, incident reports, project updates) using company formats.</description>
<path>~/.claude/skills/internal-comms/</path>
<location>global</location>
</skill>

<skill>
<name>mcp-builder</name>
<description>Guide creation of high-quality MCP servers to integrate external APIs/services; use when building MCP servers in Python (FastMCP) or Node/TypeScript.</description>
<path>~/.claude/skills/mcp-builder/</path>
<location>global</location>
</skill>

<skill>
<name>pdf</name>
<description>Handle any PDF task: read, extract, merge, split, rotate, watermark, create, fill forms, encrypt, or OCR; use whenever a .pdf file is involved.</description>
<path>~/.claude/skills/pdf/</path>
<location>global</location>
</skill>

<skill>
<name>pptx</name>
<description>Create, read, edit, or manipulate PowerPoint (.pptx) files; use whenever user mentions deck, slides, presentation, or a .pptx filename.</description>
<path>~/.claude/skills/pptx/</path>
<location>global</location>
</skill>

<skill>
<name>recall</name>
<description>Search past Claude Code and Codex sessions; use for /recall, "search old conversations", "find a past session", or "what did we discuss".</description>
<path>~/.claude/skills/recall/</path>
<location>global</location>
</skill>

<skill>
<name>session-logger</name>
<description>Log and summarize the current conversation to a permanent daily markdown file; use for /log-session, "save session", "記錄對話", or auto-triggered after every substantive task.</description>
<path>~/.claude/skills/session-logger/</path>
<location>global</location>
</skill>

<skill>
<name>skill-creator</name>
<description>Create new skills, modify or optimize existing skills, run evals, and benchmark performance; use when user wants to build or improve a skill.</description>
<path>~/.claude/skills/skill-creator/</path>
<location>global</location>
</skill>

<skill>
<name>slack-gif-creator</name>
<description>Create animated GIFs optimized for Slack with proper constraints and validation; use when user requests a GIF for Slack.</description>
<path>~/.claude/skills/slack-gif-creator/</path>
<location>global</location>
</skill>

<skill>
<name>theme-factory</name>
<description>Style artifacts (slides, docs, HTML pages) with 10 pre-set themes or generate a custom theme on-the-fly; use when applying visual themes to any artifact.</description>
<path>~/.claude/skills/theme-factory/</path>
<location>global</location>
</skill>

<skill>
<name>vercel-cli</name>
<description>Deploy, manage, and develop projects on Vercel from the command line; use when user needs to deploy or manage Vercel projects.</description>
<path>~/.claude/skills/vercel-cli/</path>
<location>global</location>
</skill>

<skill>
<name>web-artifacts-builder</name>
<description>Create elaborate multi-component HTML artifacts using React, Tailwind CSS, and shadcn/ui; use for complex artifacts requiring state management, routing, or component libraries.</description>
<path>~/.claude/skills/web-artifacts-builder/</path>
<location>global</location>
</skill>

<skill>
<name>webapp-testing</name>
<description>Test local web applications using Playwright; use to verify frontend functionality, debug UI behavior, capture screenshots, or view browser logs.</description>
<path>~/.claude/skills/webapp-testing/</path>
<location>global</location>
</skill>

<skill>
<name>xlsx</name>
<description>Open, read, edit, create, or convert spreadsheet files (.xlsx/.xlsm/.csv/.tsv); use whenever a spreadsheet file is the primary input or output.</description>
<path>~/.claude/skills/xlsx/</path>
<location>global</location>
</skill>

</available_skills>
<!-- SKILLS_TABLE_END -->

</skills_system>

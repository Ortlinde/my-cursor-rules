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

<!-- CREATIVE-TOOLKIT plugin: Visual art, design, and media generation -->

<skill>
<name>creative-toolkit:algorithmic-art</name>
<description>Generate algorithmic art using p5.js with seeded randomness and interactive parameters; use when users request code-based art, generative art, flow fields, or particle systems.</description>
<location>plugin</location>
<plugin>creative-toolkit</plugin>
</skill>

<skill>
<name>creative-toolkit:brand-guidelines</name>
<description>Apply Anthropic's official brand colors and typography to artifacts; use when brand colors, visual formatting, or company design standards apply.</description>
<location>plugin</location>
<plugin>creative-toolkit</plugin>
</skill>

<skill>
<name>creative-toolkit:canvas-design</name>
<description>Create beautiful visual art as .png/.pdf using design philosophy; use when user asks for posters, artwork, or other static visual designs.</description>
<location>plugin</location>
<plugin>creative-toolkit</plugin>
</skill>

<skill>
<name>creative-toolkit:slack-gif-creator</name>
<description>Create animated GIFs optimized for Slack with proper constraints and validation; use when user requests a GIF for Slack.</description>
<location>plugin</location>
<plugin>creative-toolkit</plugin>
</skill>

<skill>
<name>creative-toolkit:theme-factory</name>
<description>Style artifacts (slides, docs, HTML pages) with pre-set themes or generate a custom theme on-the-fly; use when applying visual themes to any artifact.</description>
<location>plugin</location>
<plugin>creative-toolkit</plugin>
</skill>

<!-- DOCUMENT-TOOLKIT plugin: File formats and written content -->

<skill>
<name>document-toolkit:doc-coauthoring</name>
<description>Guide a structured workflow for co-authoring documentation; use when user wants to write docs, proposals, technical specs, or decision docs.</description>
<location>plugin</location>
<plugin>document-toolkit</plugin>
</skill>

<skill>
<name>document-toolkit:docx</name>
<description>Create, read, edit, or manipulate Word (.docx) files; use whenever user mentions Word doc, .docx, or requests reports/memos/letters as Word documents.</description>
<location>plugin</location>
<plugin>document-toolkit</plugin>
</skill>

<skill>
<name>document-toolkit:internal-comms</name>
<description>Write internal communications (status reports, leadership updates, newsletters, incident reports, project updates) using company formats.</description>
<location>plugin</location>
<plugin>document-toolkit</plugin>
</skill>

<skill>
<name>document-toolkit:pdf</name>
<description>Handle any PDF task: read, extract, merge, split, rotate, watermark, create, fill forms, encrypt, or OCR; use whenever a .pdf file is involved.</description>
<location>plugin</location>
<plugin>document-toolkit</plugin>
</skill>

<skill>
<name>document-toolkit:pptx</name>
<description>Create, read, edit, or manipulate PowerPoint (.pptx) files; use whenever user mentions deck, slides, presentation, or a .pptx filename.</description>
<location>plugin</location>
<plugin>document-toolkit</plugin>
</skill>

<skill>
<name>document-toolkit:xlsx</name>
<description>Open, read, edit, create, or convert spreadsheet files (.xlsx/.xlsm/.csv/.tsv); use whenever a spreadsheet file is the primary input or output.</description>
<location>plugin</location>
<plugin>document-toolkit</plugin>
</skill>

<!-- DEV-TOOLKIT plugin: Web development and integration tools -->

<skill>
<name>dev-toolkit:frontend-design</name>
<description>Create distinctive, production-grade frontend interfaces; use when user asks to build web components, pages, dashboards, React components, or any HTML/CSS UI.</description>
<location>plugin</location>
<plugin>dev-toolkit</plugin>
</skill>

<skill>
<name>dev-toolkit:mcp-builder</name>
<description>Guide creation of high-quality MCP servers to integrate external APIs/services; use when building MCP servers in Python (FastMCP) or Node/TypeScript.</description>
<location>plugin</location>
<plugin>dev-toolkit</plugin>
</skill>

<skill>
<name>dev-toolkit:web-artifacts-builder</name>
<description>Create elaborate multi-component HTML artifacts using React, Tailwind CSS, and shadcn/ui; use for complex artifacts requiring state management, routing, or component libraries.</description>
<location>plugin</location>
<plugin>dev-toolkit</plugin>
</skill>

<skill>
<name>dev-toolkit:webapp-testing</name>
<description>Test local web applications using Playwright; use to verify frontend functionality, debug UI behavior, capture screenshots, or view browser logs.</description>
<location>plugin</location>
<plugin>dev-toolkit</plugin>
</skill>

<!-- WORKFLOW-TOOLKIT plugin: Development process, quality, and meta tools -->

<skill>
<name>workflow-toolkit:architecture-review</name>
<description>Review architecture for decoupling, module boundaries, hidden coupling, and separation of concerns; use after technical planning, before implementation.</description>
<location>plugin</location>
<plugin>workflow-toolkit</plugin>
</skill>

<skill>
<name>workflow-toolkit:coding-standards</name>
<description>Detailed coding standards, style guides, and architectural patterns for development; invoke before writing, editing, or reviewing code.</description>
<location>plugin</location>
<plugin>workflow-toolkit</plugin>
</skill>

<skill>
<name>workflow-toolkit:deliberate-development</name>
<description>Enforce a deliberate, phased approach to code development; use when starting a new feature, system, or module design from scratch.</description>
<location>plugin</location>
<plugin>workflow-toolkit</plugin>
</skill>

<skill>
<name>workflow-toolkit:find-skills</name>
<description>Help users discover and install agent skills when they ask "find a skill for X" or express interest in extending capabilities.</description>
<location>plugin</location>
<plugin>workflow-toolkit</plugin>
</skill>

<skill>
<name>workflow-toolkit:recall</name>
<description>Search past Claude Code and Codex sessions; use for /recall, "search old conversations", "find a past session", or "what did we discuss".</description>
<location>plugin</location>
<plugin>workflow-toolkit</plugin>
</skill>

<skill>
<name>workflow-toolkit:self-review</name>
<description>Standardized code review process including Self-Analysis Report and Risk Checklist; use when finishing code modifications >50 lines or refactoring.</description>
<location>plugin</location>
<plugin>workflow-toolkit</plugin>
</skill>

<skill>
<name>workflow-toolkit:skill-creator</name>
<description>Create new skills, modify or optimize existing skills; use when user wants to build or improve a skill.</description>
<location>plugin</location>
<plugin>workflow-toolkit</plugin>
</skill>

<skill>
<name>workflow-toolkit:template</name>
<description>Placeholder template stub for skill authoring; do not invoke directly, use skill-creator instead.</description>
<location>plugin</location>
<plugin>workflow-toolkit</plugin>
</skill>

</available_skills>
<!-- SKILLS_TABLE_END -->

</skills_system>

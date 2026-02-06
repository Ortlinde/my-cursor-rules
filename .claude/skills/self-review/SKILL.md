---
name: self-review
description: Standardized code review process including Self-Analysis Report and Risk Checklist. Use when finishing code modifications >50 lines, refactoring, or when instructed by rules.
---

# Self-Review Protocol

This skill guides you through the mandatory self-review process. You must execute this protocol before submitting code changes that meet the trigger criteria.

## Process Overview

1.  **Risk & Compliance Check**: Verify code against the consolidated checklist.
2.  **Generate Report**: Create the "Self-Analysis Report" using the standard template.
3.  **Decision**: Proceed, Warn, or Stop based on findings.

## Step 1: Risk & Compliance Check

Load and verify the checklist. This combines "Risk Avoidance" (Postmortem patterns) and "Coding Style" (Base rules).

- **Checklist**: [references/risk-checklist.md](references/risk-checklist.md)

## Step 2: Generate Report

Select the appropriate template based on your findings and include it in your response.

- **Templates**: [references/analysis-report.md](references/analysis-report.md)

## Step 3: Decision Logic

- **STOP & Discuss**:
    - Violations ≥ 3
    - Triggered known bug pattern (Postmortem)
    - Modified >5 files without authorization
    - Violated SOLID principles with no immediate fix
    - Introduced new external dependencies
- **Proceed with Warning**: Violations < 3 (must list in report)
- **Proceed**: No violations

## Reminder
- Always reference `my-base-rules.mdc` or `postmortem-patterns.mdc` when citing violations.
- Transparent reporting builds trust. Do not hide issues.

# Self-Analysis Report Templates

Choose the template that matches your review result.

## Template 1: Pass (Low Risk)

```markdown
## Self-Review Report

### Modification Summary
- **Scope**: [N] files, [M] lines
- **Type**: [Added/Modified/Refactored]
- **Risk**: 🟢 Low

### Passed Checks
- [List key passed checks, e.g., Clean Code, SOLID, No Leaks]

### Warnings
- None

### Failed Checks
- None

### Recommended Actions
- ✅ Ready to proceed
```

## Template 2: Proceed with Warning (Medium Risk)

```markdown
## Self-Review Report

### Modification Summary
- **Scope**: [N] files, [M] lines
- **Type**: [Added/Modified/Refactored]
- **Risk**: 🟡 Medium

### Passed Checks
- [List key passed checks]

### Warnings
- [Explain potential risk, e.g., "Complexity slightly high"]

### Failed Checks
- ⚠️ [Rule Name]: [Explanation] (Source: my-base-rules.mdc)

### Recommended Actions
- [Action 1, e.g., "Add unit tests"]
- [Action 2]
```

## Template 3: STOP (High Risk)

```markdown
## Self-Review Report

### Modification Summary
- **Scope**: [N] files, [M] lines
- **Type**: [Refactored/Major Change]
- **Risk**: 🔴 High

### Failed Checks
- ❌ [Critical Violation 1]: [Explanation] (Source: postmortem-patterns.mdc)
- ❌ [Critical Violation 2]: [Explanation] (Source: my-base-rules.mdc)
- ❌ [Critical Violation 3]: [Explanation]

### Recommended Actions
- 🛑 STOP - Discussion Required

---

## Solution Options

**Option A: Best Practice**
- [Description]
- Time: [Estimate]

**Option B: Compromise**
- [Description]
- Time: [Estimate]

**Option C: Quick Fix**
- [Description]
- Time: [Estimate]
```

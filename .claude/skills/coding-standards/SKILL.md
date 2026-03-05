---
name: coding-standards
description: "Detailed coding standards, style guides, and architectural patterns for Unity development. ALWAYS invoke this skill before writing, editing, or reviewing any code -- no exceptions. Also use when the user asks about code style, refactoring, best practices, or when verifying code quality."
---

# Coding Standards

This skill provides comprehensive guidelines for Unity development, including style guides, architectural patterns, and refactoring strategies. It supplements the strict rules defined in `.cursor/rules/my-base-rules.mdc`.

## When to Use

- **Code Review**: When analyzing code for quality improvements.
- **Refactoring**: When planning or executing refactoring tasks.
- **Implementation**: When writing new code and needing guidance on naming, structure, or patterns.
- **Architecture**: When designing new systems or modules.

## Core References

### 1. Unity Style Guide
Detailed naming conventions, file structure, and Unity-specific formatting rules.
- **See**: [references/unity-style-guide.md](references/unity-style-guide.md)

### 2. Architecture Patterns
Implementation examples of SOLID principles and common design patterns (Strategy, Factory, etc.) in Unity.
- **See**: [references/architecture-patterns.md](references/architecture-patterns.md)

### 3. Refactoring Guide
Strategies for splitting large classes, reducing method complexity, and improving code maintainability.
- **See**: [references/refactoring-guide.md](references/refactoring-guide.md)

## Summary of Key Standards

### Naming Conventions
- **Classes/Methods/Properties**: `PascalCase`
- **Private Fields**: `_camelCase`
- **Local Variables/Parameters**: `camelCase`
- **Interfaces**: `IInterfaceName`

### Code Organization
- **Namespaces**: Must match folder structure.
- **Region**: Use `#region` sparingly, primarily for interface implementations or very distinct sections.
- **Attributes**: Place attributes above the target (not inline), except for parameters.

### Unity Specifics
- **Serialization**: Prefer `[SerializeField] private` over `public` for inspector variables.
- **Performance**: Cache `GetComponent`, `Camera.main`, and other expensive calls.
- **Coroutines**: Always manage lifecycle (StopCoroutine on disable/destroy).

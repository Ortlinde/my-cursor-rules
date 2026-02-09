---
name: deliberate-development
description: Enforce a deliberate, phased approach to code development. AI must understand existing concepts first, then design abstractions, then implement details. Prevents premature implementation and ensures architectural alignment.
---

# Deliberate Development (Walk Slow, Think Deep)

## Core Principle

```
Understand → Design → Implement
(Not: See code → Jump to implementation)
```

## Trigger Scenarios

Apply this skill when:
- User asks to add new features to existing code
- User asks to refactor or redesign existing systems
- User asks to extend or modify architectural components
- User mentions "design", "architecture", "refactor", or "extend"
- The change involves more than simple bug fixes or one-liner changes

## Three-Phase Protocol

### Phase 1: Conceptual Understanding (MUST complete before Phase 2)

**Goal**: Understand the original designer's intent, not just the implementation details.

**Actions**:
1. Read the relevant code
2. Identify and articulate:
   - What **problem** was this code designed to solve?
   - What **abstraction** or **pattern** was the designer using?
   - What are the **boundaries** and **responsibilities** of each component?
   - Are there any **implicit contracts** or **assumptions**?

**Output format**:
```markdown
## Phase 1: Conceptual Analysis

### Original Design Intent
[What problem does this solve? What was the designer thinking?]

### Abstraction Pattern
[What pattern/approach is being used? Strategy? Factory? Composition?]

### Component Responsibilities
- ComponentA: [responsibility]
- ComponentB: [responsibility]

### Key Constraints/Assumptions
- [constraint 1]
- [constraint 2]
```

**Checkpoint**: Ask user to confirm understanding before proceeding.

---

### Phase 2: Framework Design (MUST complete before Phase 3)

**Goal**: Design the skeleton - interfaces, abstract classes, method signatures.

**Actions**:
1. Propose new abstractions or extensions
2. Define interfaces and abstract method signatures
3. Show class relationships (inheritance, composition)
4. Generate ONLY:
   - Interface definitions
   - Abstract class skeletons
   - Empty method signatures with `// TODO: Implement` or `throw new NotImplementedException()`

**Output format**:
```markdown
## Phase 2: Framework Design

### Proposed Structure
[Diagram or description of new components]

### New Abstractions
- InterfaceA: [purpose]
- AbstractClassB: [purpose]

### Code Skeleton
[Show interface/abstract class code with empty implementations]
```

**Checkpoint**: Ask user to confirm structure before implementing.

---

### Phase 3: Concrete Implementation (Only after Phase 2 approval)

**Goal**: Fill in the implementation details.

**Actions**:
1. Implement one component at a time
2. Show implementation for user review
3. Proceed to next component only after confirmation

**Output format**:
```markdown
## Phase 3: Implementation - [ComponentName]

### Implementation
[Actual code]

### How it fits
[Explain how this connects to the framework]
```

---

## Prohibited Behaviors

- **MUST NOT**: Skip Phase 1 and jump directly to code changes
- **MUST NOT**: Generate full implementations in Phase 2
- **MUST NOT**: Implement multiple components without checkpoints
- **MUST NOT**: Assume user approval - always ask explicitly

## Example Workflow

**User**: "I want different players to use different colored soldiers"

**AI Response (Phase 1)**:
```
## Phase 1: Conceptual Analysis

### Original Design Intent
The SoldierBullet system separates:
- **Logic** (movement, collision, lifecycle) - handled by SoldierBullet.cs
- **Visual** (model, animation) - currently embedded in prefab

### Abstraction Pattern
The `_soldierModel` field suggests the designer anticipated model injection,
but current implementation has model baked into prefab.

### Key Question
Is this a LOGIC difference or VISUAL difference?
→ Visual only. Same behavior, different appearance.

### Unity Built-in Solutions for Visual Variants
- Animator Override Controller (different animations, same state machine)
- Material Property Block (different colors, same material)
- Model injection (different meshes, same controller)

Shall I proceed to Phase 2 with the model injection approach?
```

## Enforcement

| Phase | Gate Condition |
|-------|----------------|
| Phase 1 → Phase 2 | User confirms conceptual understanding |
| Phase 2 → Phase 3 | User confirms framework design |
| Phase 3 iteration | User confirms each component |

## Notes

- This skill prioritizes **alignment over speed**
- If user explicitly says "just implement it", phases can be condensed but not skipped
- For trivial changes (<10 lines, no new abstractions), this skill does not apply

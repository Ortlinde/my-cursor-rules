# Risk & Compliance Checklist

## Part 1: Coding Style (from `my-base-rules.mdc`)

### Environment & Structure
- [ ] **CRLF**: All files end with CRLF (\r\n).
- [ ] **ASCII Only**: No graphical characters/emoji in code/comments.
- [ ] **One Class**: One public class per file.
- [ ] **One Concept**: Single responsibility per class.
- [ ] **One Behavior**: Single responsibility per method.
- [ ] **Length Limits**: File ≤ 200 lines, Method ≤ 20 lines, Params ≤ 3.

### Principles
- [ ] **SOLID**: Adheres to all 5 principles.
- [ ] **DRY**: No logic duplicated >3 times.
- [ ] **Scope**: Modifications strictly within authorized scope.

## Part 2: Risk Avoidance (from `postmortem-patterns.mdc`)

### Unity Specifics
- [ ] **Null Checks**: `GetComponent` results are checked.
- [ ] **Lifecycle**: `Awake`/`Start`/`OnEnable` order respected.
- [ ] **Coroutines**: Every `StartCoroutine` has cleanup (`StopCoroutine`).
- [ ] **Events**: Every `+=` has corresponding `-=` in `OnDestroy`/`OnDisable`.
- [ ] **Disposal**: Disposal order is reverse of initialization.
- [ ] **ScriptableObjects**: No runtime modification of shared assets (use instances).
- [ ] **Performance**: No `GameObject.Find` or `GetComponent` in `Update`.

### Unity Editor
- [ ] **Scene State**: Check `isLoaded` before accessing scene objects in Editor Windows.
- [ ] **Stale References**: Clear cached objects on scene change.
- [ ] **SetDirty**: Call `EditorUtility.SetDirty` when modifying assets.

### C# General
- [ ] **Collections**: No modification during iteration.
- [ ] **Async**: No `async void` (except events). Use `async Task`.
- [ ] **Closures**: Loop variables captured correctly.
- [ ] **Boxing**: Avoid frequent boxing in hot paths.

### Architecture
- [ ] **Circular Deps**: No bidirectional module references.
- [ ] **Magic Values**: Use constants/enums, not hardcoded strings/numbers.

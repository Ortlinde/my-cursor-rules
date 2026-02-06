# Refactoring Guide

## When to Refactor
Refactoring is not a separate phase; it should be part of the daily development cycle (Red-Green-Refactor).

**Triggers from Rules:**
- 🔴 **File > 200 lines**: Sign of too many responsibilities.
- 🔴 **Method > 20 lines**: Sign of mixed abstraction levels.
- 🔴 **Parameters > 3**: Sign of missing data structure.
- 🔴 **Duplicated Code**: Logic appearing in 3+ places.

## Strategies

### 1. Extract Method (Reduce Method Length)
Isolate specific logic blocks into their own methods with descriptive names.

**Before (Mixed levels of abstraction):**
```csharp
public void UpdatePlayer()
{
    // Input
    if (Input.GetKeyDown(KeyCode.Space)) { ... }
    
    // Movement
    transform.position += velocity * Time.deltaTime;
    
    // Bounds Check
    if (transform.position.y < -10) { Die(); }
}
```

**After (Composed Method):**
```csharp
public void UpdatePlayer()
{
    HandleInput();
    Move();
    CheckBounds();
}
```

### 2. Extract Class (Reduce File Length)
When a class does too much (God Object), identify subsets of data and methods that belong together.

**Steps:**
1. Identify a cohesive group of fields/methods (e.g., all `Health`, `Armor`, `Damage` related code).
2. Create a new class (e.g., `HealthSystem`).
3. Move fields and methods to the new class.
4. Add a reference to the new class in the original class.
5. Update references to use the new class.

### 3. Introduce Parameter Object (Reduce Parameter Count)
When a method takes many parameters, they likely belong to a single concept.

**Before:**
```csharp
public void CreateLevel(int width, int height, int seed, float difficulty, string biome)
```

**After:**
```csharp
public class LevelConfig 
{
    public int Width;
    public int Height;
    public int Seed;
    public float Difficulty;
    public string Biome;
}

public void CreateLevel(LevelConfig config)
```

### 4. Replace Conditional with Polymorphism
See [Architecture Patterns](architecture-patterns.md).

## Refactoring Workflow

1. **Verify Tests**: Ensure current behavior is correct (ideally with tests).
2. **Apply Refactoring**: Make the structural change.
3. **Verify**: Ensure behavior hasn't changed.
4. **Commit**: "Refactor: extracted HealthSystem from Player".

## Legacy Code Tips

- **Pinning Tests**: Before refactoring complex legacy code, write a "characterization test" that captures the current (even if buggy) behavior to ensure you don't break it accidentally.
- **Sprout Method**: When adding a feature to a messy class, write the new code as a fresh, clean method (or class) and call it, rather than inserting it into the existing mess.

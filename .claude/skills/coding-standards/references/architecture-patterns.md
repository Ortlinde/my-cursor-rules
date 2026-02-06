# Architecture Patterns

## SOLID Principles in Unity

### Single Responsibility Principle (SRP)
Each class should have only one reason to change.

**❌ Violation:**
`PlayerController` handling Input, Movement, Animation, and Audio.

**✅ Solution:**
Split into dedicated components:
- `PlayerInput`: Reads Input System.
- `PlayerMovement`: Handles Rigidbody/Transform logic.
- `PlayerAnimation`: Manages Animator state.
- `PlayerAudio`: Handles SFX.

### Open/Closed Principle (OCP)
Classes should be open for extension but closed for modification.

**❌ Violation:**
Using a switch statement to handle different weapon types inside a `Weapon` class. Adding a new weapon requires changing the class.

```csharp
public void Fire()
{
    switch (_type)
    {
        case WeaponType.Gun: FireGun(); break;
        case WeaponType.Bow: FireBow(); break;
        // Need to modify this file to add Laser
    }
}
```

**✅ Solution:**
Use Polymorphism or Strategy Pattern.

```csharp
public abstract class WeaponStrategy : ScriptableObject
{
    public abstract void Fire(Transform origin);
}

// Extension: Create new class "LaserStrategy", no need to touch existing code.
```

### Dependency Inversion Principle (DIP)
High-level modules should not depend on low-level modules. Both should depend on abstractions.

**❌ Violation:**
`Player` class directly references `InventoryManager` singleton.

```csharp
void Start() {
    InventoryManager.Instance.AddItem(this); // Tight coupling
}
```

**✅ Solution:**
Use Dependency Injection (via Constructor, Init method, or Zenject/VContainer) or Interfaces.

```csharp
private IInventorySystem _inventory;

public void Initialize(IInventorySystem inventory)
{
    _inventory = inventory;
}
```

---

## Replacing Complex If/Else Chains

When you see a long chain of `if/else` or `switch` statements checking for types or states, consider these patterns:

### 1. Strategy Pattern
Encapsulate algorithms into separate classes.

**Scenario**: Different enemy movement behaviors.

```csharp
public interface IMovementStrategy
{
    Vector3 CalculateMove(Vector3 currentPos, Vector3 targetPos);
}

public class FlyMovement : IMovementStrategy { ... }
public class WalkMovement : IMovementStrategy { ... }

public class Enemy : MonoBehaviour
{
    private IMovementStrategy _movement;
    
    public void SetStrategy(IMovementStrategy strategy) => _movement = strategy;
    
    void Update()
    {
        transform.position = _movement.CalculateMove(transform.position, _target);
    }
}
```

### 2. Factory Pattern
Centralize object creation logic.

**Scenario**: Spawning different power-ups based on ID.

```csharp
public class PowerUpFactory
{
    private Dictionary<string, PowerUp> _prefabs;

    public PowerUp Create(string id)
    {
        if (_prefabs.TryGetValue(id, out var prefab))
        {
            return Object.Instantiate(prefab);
        }
        throw new ArgumentException($"Unknown PowerUp: {id}");
    }
}
```

### 3. State Pattern
Encapsulate state-specific behavior.

**Scenario**: Character states (Idle, Run, Jump, Attack).

**❌ Bad**:
```csharp
if (state == "Idle") { ... }
else if (state == "Run") { ... }
```

**✅ Good**:
```csharp
public abstract class State
{
    public abstract void Enter();
    public abstract void Tick();
    public abstract void Exit();
}

public class IdleState : State { ... }
public class RunState : State { ... }
```

## Singleton Usage
Limit Singletons to "Manager" type classes that truly need global access (e.g., `AudioManager`, `GameManager`).

**Best Practice**:
- Make the Instance property public but the implementation private.
- Ensure thread safety if not using Unity's main thread.
- **Better**: Use a Service Locator or Dependency Injection framework to avoid global state.

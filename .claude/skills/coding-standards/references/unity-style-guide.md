# Unity Style Guide

## Naming Conventions

### General Rules
| Type | Format | Example |
|------|--------|---------|
| Classes | PascalCase | `PlayerController` |
| Methods | PascalCase | `CalculateDamage` |
| Properties | PascalCase | `Health` |
| Public Fields | PascalCase | `MaxSpeed` |
| Private/Internal Fields | _camelCase | `_currentHealth` |
| Parameters | camelCase | `targetPosition` |
| Local Variables | camelCase | `distance` |
| Interfaces | IPascalCase | `IDamageable` |
| Enums | PascalCase | `WeaponType` |
| Constants | UPPER_CASE | `MAX_PLAYERS` |
| Static Readonly | UPPER_CASE | `DEFAULT_CONFIG` |
| Events | PascalCase | `OnPlayerDied` |

### Unity Specifics
- **Boolean Properties**: Prefix with `Is`, `Has`, `Can`.
  - ✅ `IsAlive`, `HasWeapon`, `CanJump`
  - ❌ `Alive`, `Weapon`, `Jump`
- **Callback Methods**: Prefix with `On`.
  - ✅ `OnCollisionEnter`, `OnDataReceived`

## File Structure

### Standard Class Layout
Order members in this sequence:

1. **Constants**: `const`, `static readonly`
2. **Serialized Fields**: `[SerializeField] private type _name`
3. **Public Properties**: `public type Name { get; private set; }`
4. **Private Fields**: `private type _name`
5. **Unity Lifecycle**: `Awake`, `Start`, `OnEnable`, `OnDisable`, `Update`, `OnDestroy`
6. **Public Methods**: Core functionality exposed to other classes
7. **Private Methods**: Internal implementation details
8. **Event Handlers**: Methods typically subscribed to events

```csharp
public class PlayerHealth : MonoBehaviour
{
    // 1. Constants
    private const float MAX_HP = 100f;

    // 2. Serialized Fields
    [SerializeField] private float _regenRate = 5f;
    [SerializeField] private Image _healthBar;

    // 3. Public Properties
    public float CurrentHealth { get; private set; }
    public bool IsDead => CurrentHealth <= 0;

    // 4. Private Fields
    private float _lastDamageTime;

    // 5. Unity Lifecycle
    private void Awake()
    {
        CurrentHealth = MAX_HP;
    }

    private void Update()
    {
        RegenerateHealth();
    }

    // 6. Public Methods
    public void TakeDamage(float amount)
    {
        // ...
    }

    // 7. Private Methods
    private void RegenerateHealth()
    {
        // ...
    }
}
```

## Formatting

- **Braces**: Always on new lines (Allman style).
- **Indentation**: Use Tabs (width: 4). Do NOT use spaces.
- **Line Endings**: CRLF (Windows format).
- **Encoding**: UTF-8 without BOM (or ASCII).

### Serialization
- **Avoid Public Fields**: Do not use `public` fields just to show them in Inspector.
- **Use SerializeField**: Use `[SerializeField] private` to enforce encapsulation while allowing Inspector editing.

```csharp
// ❌ Bad
public float speed = 10f;

// ✅ Good
[SerializeField] private float _speed = 10f;
```

## Comments & Documentation

- **Summary**: Use XML summary `///` for all public members and classes.
- **Inline**: Use `//` for explanations of complex logic (why, not what).
- **No Emoji**: Strictly forbidden in comments and code.

```csharp
/// <summary>
/// Calculates the final damage after applying armor reduction.
/// </summary>
/// <param name="rawDamage">The initial damage amount.</param>
/// <returns>The final damage value.</returns>
public float CalculateDamage(float rawDamage)
{
    // Apply log reduction curve
    return Mathf.Log(rawDamage) * _armorFactor; 
}
```

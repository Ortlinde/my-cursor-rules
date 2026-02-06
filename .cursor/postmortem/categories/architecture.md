# Architecture Design Issues

> Record architecture design, dependency management, and code structure related bug patterns

## Known Patterns (Historical)

<!-- Add discovered patterns here -->

**Note**: This section will grow as bugs are discovered and documented.

---

## Common Pitfalls

### 1. Circular Dependencies
- **Problem**: Module A depends on B, B depends on A (compile or runtime issues)
- **Root Cause**: Poor separation of concerns, tight coupling
- **Fix Strategy**: Use interfaces, events, or dependency injection to decouple
- **Example**:
  ```csharp
  // BAD: Circular dependency
  public class PlayerController {
      private GameManager _manager;
      public void Initialize(GameManager manager) {
          _manager = manager;
          _manager.RegisterPlayer(this); // GameManager knows PlayerController
      }
  }
  
  public class GameManager {
      private List<PlayerController> _players; // Circular!
  }
  
  // GOOD: Use interface
  public interface IPlayer {
      void OnGameOver();
  }
  
  public class PlayerController : IPlayer {
      private GameManager _manager;
      public void Initialize(GameManager manager) {
          _manager = manager;
          _manager.RegisterPlayer(this); // GameManager only knows IPlayer
      }
  }
  
  public class GameManager {
      private List<IPlayer> _players; // No circular dependency
  }
  ```

### 2. Singleton Abuse
- **Problem**: Overuse of singletons leads to tight coupling and testing difficulties
- **Root Cause**: Convenience of global access
- **Fix Strategy**: Use dependency injection, limit singleton usage to truly global systems
- **Example**:
  ```csharp
  // BAD: Everything is singleton
  public class PlayerController {
      void Update() {
          GameManager.Instance.UpdateScore(1);
          AudioManager.Instance.PlaySound("jump");
          UIManager.Instance.UpdateUI();
          // Tightly coupled to 3 singletons!
      }
  }
  
  // GOOD: Inject dependencies
  public class PlayerController {
      private IScoreSystem _scoreSystem;
      private IAudioService _audioService;
      
      public void Initialize(IScoreSystem scoreSystem, IAudioService audioService) {
          _scoreSystem = scoreSystem;
          _audioService = audioService;
      }
      
      void Update() {
          _scoreSystem.UpdateScore(1);
          _audioService.PlaySound("jump");
          // Testable, loosely coupled
      }
  }
  ```

### 3. Single Responsibility Violation
- **Problem**: Class handles too many responsibilities (input, physics, animation, UI)
- **Root Cause**: Convenience of putting related code together
- **Fix Strategy**: Split into focused classes, each with single responsibility
- **Example**:
  ```csharp
  // BAD: Too many responsibilities
  public class PlayerController {
      void Update() {
          HandleInput();      // Input responsibility
          UpdatePhysics();    // Physics responsibility
          UpdateAnimation();  // Animation responsibility
          UpdateUI();         // UI responsibility
          CheckAchievements(); // Achievement responsibility
      }
  }
  
  // GOOD: Separated responsibilities
  public class PlayerInput {
      public Vector2 GetMovementInput() { }
  }
  
  public class PlayerMovement {
      public void Move(Vector2 input) { }
  }
  
  public class PlayerAnimation {
      public void UpdateAnimation(Vector2 velocity) { }
  }
  
  public class PlayerController {
      private PlayerInput _input;
      private PlayerMovement _movement;
      private PlayerAnimation _animation;
      
      void Update() {
          var input = _input.GetMovementInput();
          _movement.Move(input);
          _animation.UpdateAnimation(_movement.Velocity);
      }
  }
  ```

### 4. Magic Numbers and Strings
- **Problem**: Hardcoded values scattered throughout code
- **Root Cause**: Quick prototyping without proper refactoring
- **Fix Strategy**: Extract to constants, enums, or configuration files
- **Example**:
  ```csharp
  // BAD: Magic numbers and strings
  void CheckPlayerType() {
      if (playerType == "warrior") {
          damage = 10;
          health = 100;
      } else if (playerType == "mage") {
          damage = 20;
          health = 50;
      }
  }
  
  // GOOD: Constants and enums
  public enum PlayerType {
      Warrior,
      Mage
  }
  
  public static class PlayerStats {
      public const int WARRIOR_DAMAGE = 10;
      public const int WARRIOR_HEALTH = 100;
      public const int MAGE_DAMAGE = 20;
      public const int MAGE_HEALTH = 50;
  }
  
  void CheckPlayerType() {
      if (playerType == PlayerType.Warrior) {
          damage = PlayerStats.WARRIOR_DAMAGE;
          health = PlayerStats.WARRIOR_HEALTH;
      } else if (playerType == PlayerType.Mage) {
          damage = PlayerStats.MAGE_DAMAGE;
          health = PlayerStats.MAGE_HEALTH;
      }
  }
  
  // EVEN BETTER: Data-driven
  [System.Serializable]
  public class PlayerTypeData {
      public PlayerType type;
      public int damage;
      public int health;
  }
  
  public PlayerTypeData[] playerTypes; // Set in Inspector
  ```

### 5. ScriptableObject Shared State
- **Problem**: Modifying ScriptableObject at runtime affects the asset permanently
- **Root Cause**: ScriptableObjects are assets, not instances
- **Fix Strategy**: Clone ScriptableObject for runtime modifications or use it as readonly template
- **Example**:
  ```csharp
  // BAD: Modifies asset directly
  public class Player : MonoBehaviour {
      public PlayerData data; // ScriptableObject
      
      void TakeDamage(int amount) {
          data.health -= amount; // MODIFIES ASSET FILE!
      }
  }
  
  // GOOD: Clone for runtime use
  public class Player : MonoBehaviour {
      public PlayerData dataTemplate; // ScriptableObject (readonly)
      private PlayerData _runtimeData;
      
      void Awake() {
          _runtimeData = Instantiate(dataTemplate); // Clone
      }
      
      void TakeDamage(int amount) {
          _runtimeData.health -= amount; // Safe, modifies clone
      }
  }
  
  // ALTERNATIVE: ScriptableObject as template only
  public class Player : MonoBehaviour {
      public PlayerData template; // ScriptableObject (readonly)
      private int _currentHealth;
      
      void Awake() {
          _currentHealth = template.maxHealth; // Copy value
      }
      
      void TakeDamage(int amount) {
          _currentHealth -= amount; // Modify local variable
      }
  }
  ```

---

## Search Keywords

When refactoring architecture, search this file for:
- Patterns: `circular`, `singleton`, `dependency`, `coupling`
- Concepts: `responsibility`, `separation`, `injection`, `interface`
- Issues: `hardcode`, `magic`, `shared state`, `ScriptableObject`

---

**Last Updated**: 2026-01-26

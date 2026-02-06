# Unity Lifecycle Issues

> Record Unity MonoBehaviour lifecycle-related bug patterns

## Known Patterns (Historical)

<!-- Add discovered patterns here using this format: -->
<!--
### [P001] Awake Order Dependency

- **Symptom**: NullReferenceException during object initialization
- **Root Cause**: Cross-object Awake execution order is unpredictable
- **Fix Strategy**: Use lazy initialization or Script Execution Order settings
- **Related CL**: CL#12345
- **Date**: 2026-01-13
- **Prevention**: Initialize self in Awake, reference others in Start
-->

**Note**: This section will grow as bugs are discovered and documented.

---

## Common Pitfalls

### 1. Awake vs Start Order
- **Awake**: All objects' Awake methods execute first (order unpredictable between objects)
- **Start**: Executes before first Update, after all Awake methods complete
- **Rule**: Initialize self-contained data in Awake, reference other components in Start
- **Example**:
  ```csharp
  // BAD: Dependency in Awake
  void Awake() {
      gameManager = FindObjectOfType<GameManager>(); // May be null!
      gameManager.RegisterPlayer(this); // NullReferenceException risk
  }
  
  // GOOD: Dependency in Start
  void Awake() {
      _health = maxHealth; // Self initialization
  }
  void Start() {
      gameManager = FindObjectOfType<GameManager>(); // Safe
      if (gameManager != null) gameManager.RegisterPlayer(this);
  }
  ```

### 2. OnEnable Timing
- **Behavior**: Called when object becomes enabled (before Start, after Awake)
- **Risk**: `SetActive(true)` triggers OnEnable immediately
- **Rule**: Don't assume Start has been called in OnEnable
- **Example**:
  ```csharp
  // BAD: Assumes Start was called
  void OnEnable() {
      _audioSource.Play(); // _audioSource may be null if Start hasn't run
  }
  
  // GOOD: Null check or lazy initialization
  void OnEnable() {
      if (_audioSource != null) _audioSource.Play();
  }
  ```

### 3. OnDestroy Cleanup
- **Must Do**:
  - Unsubscribe from all events
  - Stop all coroutines
  - Release unmanaged resources
- **Scene Loading**: OnDestroy order is unpredictable during scene transitions
- **Critical Rule**: Cleanup order MUST be reverse of initialization order
- **Example**:
  ```csharp
  // Initialization order
  void Awake() {
      InitA();  // 1st
      InitB();  // 2nd
      InitC();  // 3rd
  }
  
  // Cleanup MUST be reverse order
  void OnDestroy() {
      DisposeC();  // 3rd → 1st to cleanup
      DisposeB();  // 2nd → 2nd to cleanup
      DisposeA();  // 1st → 3rd to cleanup
  }
  
  // WHY: Avoid destroying lower layer before upper layer
  // Example: If C depends on B, and B depends on A
  // - Must dispose C first (remove dependency on B)
  // - Then dispose B (remove dependency on A)
  // - Finally dispose A (no more dependencies)
  ```

### 4. OnDisable vs OnDestroy
- **OnDisable**: Called when object becomes inactive (SetActive(false))
- **OnDestroy**: Called when object is destroyed or scene unloads
- **Rule**: Clean up external subscriptions in OnDestroy, reset state in OnDisable
- **Example**:
  ```csharp
  void OnDisable() {
      // Stop ongoing operations
      StopAllCoroutines();
  }
  
  void OnDestroy() {
      // Permanent cleanup
      EventManager.OnGameOver -= HandleGameOver;
  }
  ```

### 5. Initialization/Disposal Order (CRITICAL)
- **Problem**: Disposing upper layers before lower layers causes crashes or errors
- **Root Cause**: Upper layers may depend on lower layers being available during disposal
- **Fix Strategy**: ALWAYS dispose in exact reverse order of initialization
- **Rule**: If init order is A→B→C, dispose order MUST be C→B→A
- **Example**:
  ```csharp
  // BAD: Wrong disposal order
  public class GameController : MonoBehaviour {
      private DatabaseService _database;
      private NetworkService _network;
      private GameLogic _logic;
      
      void Awake() {
          _database = new DatabaseService();
          _network = new NetworkService(_database);  // Depends on database
          _logic = new GameLogic(_network);          // Depends on network
      }
      
      void OnDestroy() {
          _database.Dispose();  // ❌ WRONG! Network still needs it!
          _network.Dispose();   // ❌ Crash! Database already disposed
          _logic.Dispose();     // ❌ May fail if network disposed
      }
  }
  
  // GOOD: Reverse order disposal
  public class GameController : MonoBehaviour {
      private DatabaseService _database;
      private NetworkService _network;
      private GameLogic _logic;
      
      void Awake() {
          _database = new DatabaseService();         // 1st
          _network = new NetworkService(_database);  // 2nd - depends on 1st
          _logic = new GameLogic(_network);          // 3rd - depends on 2nd
      }
      
      void OnDestroy() {
          _logic?.Dispose();     // ✅ 3rd → Dispose first (no dependencies)
          _network?.Dispose();   // ✅ 2nd → Then dispose (logic done)
          _database?.Dispose();  // ✅ 1st → Finally dispose (all done)
      }
  }
  
  // ALTERNATIVE: Track initialization order automatically
  public class GameController : MonoBehaviour {
      private readonly Stack<IDisposable> _disposables = new Stack<IDisposable>();
      
      void Awake() {
          // Push in initialization order
          _disposables.Push(new DatabaseService());
          _disposables.Push(new NetworkService(_database));
          _disposables.Push(new GameLogic(_network));
      }
      
      void OnDestroy() {
          // Pop in reverse order automatically
          while (_disposables.Count > 0) {
              _disposables.Pop()?.Dispose();
          }
      }
  }
  ```
- **Real-world scenario**:
  ```csharp
  // Event system example
  void Start() {
      // Init order
      RegisterToEventSystem();   // 1. Subscribe to events
      StartNetworkConnection();  // 2. Start network (may trigger events)
      LoadGameData();            // 3. Load data (triggers events)
  }
  
  void OnDestroy() {
      // Dispose in REVERSE order
      UnloadGameData();          // 3. Unload first (no more events)
      StopNetworkConnection();   // 2. Stop network (no more triggers)
      UnregisterFromEventSystem(); // 1. Unsubscribe last
  }
  ```

---

## Search Keywords

When modifying lifecycle methods, search this file for:
- Method names: `Awake`, `Start`, `OnEnable`, `OnDisable`, `OnDestroy`
- Concepts: `order`, `timing`, `initialization`, `cleanup`, `dependency`
- Issues: `NullReference`, `race condition`, `leak`

---

**Last Updated**: 2026-01-26

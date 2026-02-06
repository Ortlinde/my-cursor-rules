# Memory Management Issues

> Record memory leaks, GC pressure, and performance-related bug patterns

## Known Patterns (Historical)

<!-- Add discovered patterns here -->

**Note**: This section will grow as bugs are discovered and documented.

---

## Common Pitfalls

### 1. Event Subscription Leaks
- **Problem**: Static event subscriptions prevent garbage collection
- **Root Cause**: Event holds reference to object, preventing GC
- **Fix Strategy**: Always unsubscribe in OnDestroy or use weak references
- **Critical Rule**: Unsubscribe in REVERSE order of subscription
- **Example**:
  ```csharp
  // BAD: Never unsubscribes
  void Start() {
      EventManager.OnPlayerDied += HandlePlayerDeath;
  }
  
  // GOOD: Unsubscribe in OnDestroy
  void Start() {
      EventManager.OnPlayerDied += HandlePlayerDeath;
  }
  
  void OnDestroy() {
      EventManager.OnPlayerDied -= HandlePlayerDeath;
  }
  
  // BEST: Multiple subscriptions in reverse order
  void Start() {
      // Subscribe in order
      EventA.OnEvent += HandlerA;  // 1st
      EventB.OnEvent += HandlerB;  // 2nd
      EventC.OnEvent += HandlerC;  // 3rd
  }
  
  void OnDestroy() {
      // Unsubscribe in REVERSE order
      EventC.OnEvent -= HandlerC;  // 3rd → 1st to unsubscribe
      EventB.OnEvent -= HandlerB;  // 2nd → 2nd to unsubscribe
      EventA.OnEvent -= HandlerA;  // 1st → 3rd to unsubscribe
      
      // WHY: HandlerC might depend on EventB
      //      HandlerB might depend on EventA
  }
  ```

### 2. Closure Captures
- **Problem**: Lambda expressions capture variables, extending their lifetime
- **Root Cause**: Closure holds reference to outer scope
- **Fix Strategy**: Be aware of what variables are captured, use local copies in loops
- **Example**:
  ```csharp
  // BAD: Captures loop variable incorrectly
  for (int i = 0; i < 10; i++) {
      button.onClick.AddListener(() => Debug.Log(i)); // All print 10!
  }
  
  // GOOD: Capture local copy
  for (int i = 0; i < 10; i++) {
      int index = i; // Local copy
      button.onClick.AddListener(() => Debug.Log(index)); // Correct
  }
  ```

### 3. Boxing Performance
- **Problem**: Value types boxed to object, causing GC allocation
- **Root Cause**: Using non-generic collections or interfaces
- **Fix Strategy**: Use generic collections, avoid object parameters for value types
- **Example**:
  ```csharp
  // BAD: Boxing allocation
  Dictionary<int, object> data = new Dictionary<int, object>();
  data[0] = 42; // Box int to object
  int value = (int)data[0]; // Unbox
  
  // GOOD: No boxing with generics
  Dictionary<int, int> data = new Dictionary<int, int>();
  data[0] = 42; // No boxing
  int value = data[0]; // Direct access
  ```

### 4. String Concatenation
- **Problem**: String concatenation in loops creates many temporary strings
- **Root Cause**: Strings are immutable, each + creates new string
- **Fix Strategy**: Use StringBuilder for loops, string.Join for collections
- **Example**:
  ```csharp
  // BAD: Many allocations
  string result = "";
  for (int i = 0; i < 1000; i++) {
      result += i.ToString(); // Creates 1000 temporary strings
  }
  
  // GOOD: Single allocation growth
  StringBuilder sb = new StringBuilder();
  for (int i = 0; i < 1000; i++) {
      sb.Append(i);
  }
  string result = sb.ToString();
  
  // GOOD: For collections
  string result = string.Join(", ", numbers);
  ```

### 5. Unity Resource Leaks
- **Problem**: Textures, Materials created at runtime not released
- **Root Cause**: Unity doesn't auto-release dynamically created assets
- **Fix Strategy**: Explicitly destroy or use Resources.UnloadUnusedAssets
- **Example**:
  ```csharp
  // BAD: Texture leak
  void CreateDynamicTexture() {
      Texture2D tex = new Texture2D(256, 256);
      // Use texture...
      // Never destroyed!
  }
  
  // GOOD: Explicit cleanup
  private Texture2D _dynamicTexture;
  
  void CreateDynamicTexture() {
      _dynamicTexture = new Texture2D(256, 256);
      // Use texture...
  }
  
  void OnDestroy() {
      if (_dynamicTexture != null) {
          Destroy(_dynamicTexture);
          _dynamicTexture = null;
      }
  }
  ```

### 6. FindObjectOfType in Update
- **Problem**: Expensive search operation called every frame
- **Root Cause**: No caching of references
- **Fix Strategy**: Cache references in Awake/Start
- **Example**:
  ```csharp
  // BAD: Search every frame
  void Update() {
      var manager = FindObjectOfType<GameManager>();
      manager.UpdateScore(score);
  }
  
  // GOOD: Cache reference
  private GameManager _manager;
  
  void Start() {
      _manager = FindObjectOfType<GameManager>();
  }
  
  void Update() {
      if (_manager != null) {
          _manager.UpdateScore(score);
      }
  }
  ```

### 7. GetComponent Overuse
- **Problem**: GetComponent called repeatedly, causing performance issues
- **Root Cause**: No caching of component references
- **Fix Strategy**: Cache components in Awake
- **Example**:
  ```csharp
  // BAD: GetComponent every frame
  void Update() {
      GetComponent<Rigidbody>().velocity = Vector3.zero;
  }
  
  // GOOD: Cache component
  private Rigidbody _rigidbody;
  
  void Awake() {
      _rigidbody = GetComponent<Rigidbody>();
  }
  
  void Update() {
      if (_rigidbody != null) {
          _rigidbody.velocity = Vector3.zero;
      }
  }
  ```

---

## Search Keywords

When optimizing memory/performance, search this file for:
- Operations: `GetComponent`, `Find`, `Subscribe`, `Boxing`, `String`
- Concepts: `leak`, `cache`, `allocation`, `GC`, `performance`
- Issues: `event`, `closure`, `reference`, `resource`

---

**Last Updated**: 2026-01-26

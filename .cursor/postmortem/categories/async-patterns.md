# Async Patterns Issues

> Record Coroutine, async/await, and reactive programming related bug patterns

## Known Patterns (Historical)

<!-- Add discovered patterns here -->

**Note**: This section will grow as bugs are discovered and documented.

---

## Common Pitfalls

### 1. Coroutine Leaks
- **Problem**: Coroutines continue running after object is destroyed
- **Root Cause**: No StopCoroutine call or coroutine reference lost
- **Fix Strategy**: Track coroutine references and stop in OnDisable/OnDestroy
- **Example**:
  ```csharp
  // BAD: No cleanup
  void Start() {
      StartCoroutine(UpdateLoop());
  }
  
  // GOOD: Track and stop
  private Coroutine _updateCoroutine;
  
  void Start() {
      _updateCoroutine = StartCoroutine(UpdateLoop());
  }
  
  void OnDisable() {
      if (_updateCoroutine != null) {
          StopCoroutine(_updateCoroutine);
          _updateCoroutine = null;
      }
  }
  ```

### 2. async void Trap
- **Problem**: Exceptions are swallowed, cannot be caught by caller
- **Root Cause**: async void methods don't return Task
- **Fix Strategy**: Use async Task or async UniTask (Unity)
- **Example**:
  ```csharp
  // BAD: Exception disappears
  async void LoadData() {
      await Task.Delay(1000);
      throw new Exception("Error"); // Swallowed!
  }
  
  // GOOD: Exception can be caught
  async Task LoadDataAsync() {
      await Task.Delay(1000);
      throw new Exception("Error"); // Can be caught by caller
  }
  
  // Usage
  try {
      await LoadDataAsync();
  } catch (Exception e) {
      Debug.LogError(e);
  }
  ```

### 3. UniRx Subscription Leaks
- **Problem**: Subscriptions not disposed, causing memory leaks
- **Root Cause**: Missing AddTo(this) or CompositeDisposable not disposed
- **Fix Strategy**: Always bind to GameObject lifecycle or manually dispose
- **Example**:
  ```csharp
  // BAD: No disposal
  void Start() {
      Observable.EveryUpdate()
          .Subscribe(_ => UpdateLogic());
  }
  
  // GOOD: Bind to lifecycle
  void Start() {
      Observable.EveryUpdate()
          .Subscribe(_ => UpdateLogic())
          .AddTo(this); // Auto-dispose on destroy
  }
  
  // GOOD: Manual disposal
  private CompositeDisposable _disposables = new CompositeDisposable();
  
  void Start() {
      Observable.EveryUpdate()
          .Subscribe(_ => UpdateLogic())
          .AddTo(_disposables);
  }
  
  void OnDestroy() {
      _disposables.Dispose();
  }
  ```

### 4. Race Conditions
- **Problem**: Multiple async operations access shared state
- **Root Cause**: No synchronization mechanism
- **Fix Strategy**: Use locks, ensure single-threaded access, or use immutable data
- **Example**:
  ```csharp
  // BAD: Race condition
  private int _score;
  
  async Task UpdateScoreAsync() {
      var current = _score;
      await Task.Delay(100);
      _score = current + 10; // Another call may have modified _score!
  }
  
  // GOOD: Lock or atomic operation
  private readonly object _lock = new object();
  private int _score;
  
  async Task UpdateScoreAsync() {
      int newScore;
      lock (_lock) {
          newScore = _score + 10;
      }
      await Task.Delay(100);
      lock (_lock) {
          _score = newScore;
      }
  }
  ```

### 5. Coroutine After Destroy
- **Problem**: Starting coroutine after OnDestroy triggers error
- **Root Cause**: Component destroyed but code still tries to start coroutine
- **Fix Strategy**: Check if object is being destroyed before starting
- **Example**:
  ```csharp
  // BAD: May start after destroy
  async void DelayedAction() {
      await Task.Delay(1000);
      StartCoroutine(SomeCoroutine()); // May fail if destroyed
  }
  
  // GOOD: Check before starting
  async void DelayedAction() {
      await Task.Delay(1000);
      if (this != null && gameObject != null) {
          StartCoroutine(SomeCoroutine());
      }
  }
  ```

---

## Search Keywords

When working with async code, search this file for:
- Methods: `StartCoroutine`, `StopCoroutine`, `async`, `await`
- Concepts: `coroutine`, `leak`, `dispose`, `race`, `thread`
- Patterns: `UniRx`, `UniTask`, `Observable`, `Task`

---

**Last Updated**: 2026-01-26

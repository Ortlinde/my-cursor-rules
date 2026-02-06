# Unity Editor Tools Issues

> Record Unity Custom Editor, Editor Window, and Editor scripting related bug patterns

## Known Patterns (Historical)

<!-- Add discovered patterns here -->

**Note**: This section will grow as bugs are discovered and documented.

---

## Common Pitfalls

### 1. Scene Not Loaded on Editor Startup
- **Problem**: Custom Editor Window tries to access scene objects before scene is fully loaded
- **Root Cause**: Editor Window may be auto-opened on Unity startup (if it was open when Unity closed last time)
- **Risk**: NullReferenceException or missing object errors during Unity startup
- **Fix Strategy**: Always check if scene is loaded before accessing scene objects
- **Example**:
  ```csharp
  // BAD: No scene loading check
  public class MyEditorWindow : EditorWindow {
      void OnGUI() {
          var player = GameObject.Find("Player");
          player.transform.position = Vector3.zero; // May crash on startup!
      }
  }
  
  // GOOD: Check scene loaded state
  using UnityEditor;
  using UnityEditor.SceneManagement;
  using UnityEngine.SceneManagement;
  
  public class MyEditorWindow : EditorWindow {
      void OnGUI() {
          // Check if scene is loaded
          if (!IsSceneLoaded()) {
              EditorGUILayout.HelpBox("Scene is not loaded yet.", MessageType.Info);
              return;
          }
          
          var player = GameObject.Find("Player");
          if (player != null) {
              player.transform.position = Vector3.zero;
          }
      }
      
      private bool IsSceneLoaded() {
          // Check if active scene is valid and loaded
          Scene activeScene = SceneManager.GetActiveScene();
          return activeScene.isLoaded && activeScene.rootCount > 0;
      }
  }
  
  // BETTER: Use EditorSceneManager callbacks
  public class MyEditorWindow : EditorWindow {
      private bool _sceneReady = false;
      
      void OnEnable() {
          // Subscribe to scene loading events
          EditorSceneManager.sceneOpened += OnSceneOpened;
          EditorSceneManager.sceneLoaded += OnSceneLoaded;
          
          // Check current scene state
          CheckSceneState();
      }
      
      void OnDisable() {
          // Unsubscribe
          EditorSceneManager.sceneOpened -= OnSceneOpened;
          EditorSceneManager.sceneLoaded -= OnSceneLoaded;
      }
      
      private void OnSceneOpened(Scene scene, OpenSceneMode mode) {
          CheckSceneState();
      }
      
      private void OnSceneLoaded(Scene scene, LoadSceneMode mode) {
          CheckSceneState();
      }
      
      private void CheckSceneState() {
          Scene activeScene = SceneManager.GetActiveScene();
          _sceneReady = activeScene.isLoaded && activeScene.rootCount > 0;
          Repaint(); // Refresh window
      }
      
      void OnGUI() {
          if (!_sceneReady) {
              EditorGUILayout.HelpBox("Waiting for scene to load...", MessageType.Info);
              return;
          }
          
          // Safe to access scene objects now
          var player = GameObject.Find("Player");
          if (player != null) {
              player.transform.position = EditorGUILayout.Vector3Field("Position", player.transform.position);
          }
      }
  }
  ```

### 2. Editor Window Lifecycle vs Scene Lifecycle
- **Problem**: Editor Window persists across scene changes and Unity restarts
- **Root Cause**: EditorWindow is not a scene object, it's part of Editor UI
- **Risk**: Stale references to scene objects after scene reload
- **Fix Strategy**: Clear references on scene change, revalidate on each access
- **Example**:
  ```csharp
  // BAD: Cached reference becomes invalid
  public class MyEditorWindow : EditorWindow {
      private GameObject _cachedPlayer;
      
      void OnGUI() {
          if (_cachedPlayer == null) {
              _cachedPlayer = GameObject.Find("Player"); // Only finds once
          }
          
          // This will fail after scene reload!
          _cachedPlayer.transform.position = Vector3.zero;
      }
  }
  
  // GOOD: Revalidate references
  public class MyEditorWindow : EditorWindow {
      private GameObject _cachedPlayer;
      
      void OnEnable() {
          EditorSceneManager.sceneOpened += OnSceneChanged;
      }
      
      void OnDisable() {
          EditorSceneManager.sceneOpened -= OnSceneChanged;
      }
      
      private void OnSceneChanged(Scene scene, OpenSceneMode mode) {
          _cachedPlayer = null; // Clear stale reference
      }
      
      void OnGUI() {
          // Revalidate reference
          if (_cachedPlayer == null || !_cachedPlayer) {
              _cachedPlayer = GameObject.Find("Player");
          }
          
          if (_cachedPlayer != null) {
              _cachedPlayer.transform.position = Vector3.zero;
          }
      }
  }
  ```

### 3. Missing EditorApplication.isPlayingOrWillChangePlaymode Check
- **Problem**: Editor script modifies scene during play mode transition
- **Root Cause**: Editor script doesn't check if entering/exiting play mode
- **Risk**: Changes lost or serialization errors
- **Fix Strategy**: Check EditorApplication.isPlayingOrWillChangePlaymode before modifications
- **Example**:
  ```csharp
  // BAD: Modifies during play mode transition
  public class MyEditorWindow : EditorWindow {
      void OnGUI() {
          if (GUILayout.Button("Randomize Positions")) {
              var objects = FindObjectsOfType<Transform>();
              foreach (var obj in objects) {
                  obj.position = Random.insideUnitSphere * 10;
              }
          }
      }
  }
  
  // GOOD: Check play mode state
  public class MyEditorWindow : EditorWindow {
      void OnGUI() {
          // Disable during play mode transitions
          GUI.enabled = !EditorApplication.isPlayingOrWillChangePlaymode;
          
          if (GUILayout.Button("Randomize Positions")) {
              var objects = FindObjectsOfType<Transform>();
              foreach (var obj in objects) {
                  obj.position = Random.insideUnitSphere * 10;
                  // Mark object as dirty for save
                  EditorUtility.SetDirty(obj);
              }
          }
          
          GUI.enabled = true;
      }
  }
  ```

### 4. Forgetting EditorUtility.SetDirty
- **Problem**: Scene modifications not saved
- **Root Cause**: Unity doesn't auto-detect changes made by Editor scripts
- **Fix Strategy**: Always call EditorUtility.SetDirty after modifying objects
- **Example**:
  ```csharp
  // BAD: Changes not saved
  public class MyEditorWindow : EditorWindow {
      void OnGUI() {
          var player = GameObject.Find("Player");
          if (player != null && GUILayout.Button("Reset Position")) {
              player.transform.position = Vector3.zero;
              // Changes lost on scene reload!
          }
      }
  }
  
  // GOOD: Mark dirty for save
  public class MyEditorWindow : EditorWindow {
      void OnGUI() {
          var player = GameObject.Find("Player");
          if (player != null && GUILayout.Button("Reset Position")) {
              Undo.RecordObject(player.transform, "Reset Position");
              player.transform.position = Vector3.zero;
              EditorUtility.SetDirty(player);
              
              // Or mark scene dirty
              EditorSceneManager.MarkSceneDirty(player.scene);
          }
      }
  }
  ```

### 5. Editor Window Memory Leaks
- **Problem**: Editor Window holds references preventing GC
- **Root Cause**: Event subscriptions or cached references not cleared
- **Fix Strategy**: Unsubscribe in OnDisable, clear references properly
- **Example**:
  ```csharp
  // BAD: Event leak
  public class MyEditorWindow : EditorWindow {
      void OnEnable() {
          EditorApplication.update += OnEditorUpdate;
      }
      
      void OnEditorUpdate() {
          Repaint();
      }
      
      // OnDisable missing! Event never unsubscribed!
  }
  
  // GOOD: Proper cleanup
  public class MyEditorWindow : EditorWindow {
      void OnEnable() {
          EditorApplication.update += OnEditorUpdate;
          EditorSceneManager.sceneOpened += OnSceneOpened;
      }
      
      void OnDisable() {
          // Unsubscribe in reverse order
          EditorSceneManager.sceneOpened -= OnSceneOpened;
          EditorApplication.update -= OnEditorUpdate;
      }
      
      void OnEditorUpdate() {
          Repaint();
      }
      
      void OnSceneOpened(Scene scene, OpenSceneMode mode) {
          // Handle scene open
      }
  }
  ```

### 6. AssetDatabase Not Refreshed
- **Problem**: Asset changes not reflected in Editor
- **Root Cause**: AssetDatabase needs manual refresh after file operations
- **Fix Strategy**: Call AssetDatabase.Refresh() after creating/modifying assets
- **Example**:
  ```csharp
  // BAD: Asset not visible
  [MenuItem("Tools/Create Config")]
  static void CreateConfig() {
      var config = ScriptableObject.CreateInstance<GameConfig>();
      AssetDatabase.CreateAsset(config, "Assets/Config.asset");
      // Asset may not appear until manual refresh!
  }
  
  // GOOD: Refresh database
  [MenuItem("Tools/Create Config")]
  static void CreateConfig() {
      var config = ScriptableObject.CreateInstance<GameConfig>();
      AssetDatabase.CreateAsset(config, "Assets/Config.asset");
      AssetDatabase.SaveAssets();
      AssetDatabase.Refresh();
      
      // Select created asset
      Selection.activeObject = config;
      EditorGUIUtility.PingObject(config);
  }
  ```

---

## Search Keywords

When working with Unity Editor tools, search this file for:
- Components: `EditorWindow`, `EditorApplication`, `EditorSceneManager`
- Concepts: `scene loading`, `play mode`, `serialization`, `dirty flag`
- Issues: `startup`, `scene change`, `stale reference`, `memory leak`
- APIs: `SetDirty`, `Refresh`, `isPlayingOrWillChangePlaymode`

---

**Last Updated**: 2026-01-26


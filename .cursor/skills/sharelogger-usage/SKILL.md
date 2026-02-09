---
name: sharelogger-usage
description: Enforce using ShareLogger for logging in Unity code. Use when the user asks to print to console, add logs, or when code includes Debug.Log, print(), or Console.WriteLine. Replace those with ShareLogger.Instance.FuncInfo/Warn/Error and add using WT.Foundation.Loggers.
---

# ShareLogger Usage

## Quick Start

When adding logs or output in Unity code:
1. Add `using WT.Foundation.Loggers;` if missing.
2. Use `ShareLogger.Instance.FuncInfo/Warn/Error()` only.
3. Do not use `Debug.Log`, `Debug.LogWarning`, `Debug.LogError`, `print()`, or `Console.WriteLine`.

## Trigger Scenarios

Apply this skill when:
- The user asks to print to Unity Console.
- The code uses `Debug.Log`, `Debug.LogWarning`, `Debug.LogError`.
- The code uses `print()`.
- The code uses `Console.WriteLine`, `Console.Write`, or `Console.Error`.

## Log Level Mapping

Default mapping:
- `Debug.Log` / `print()` / `Console.WriteLine` -> `ShareLogger.Instance.FuncInfo`
- `Debug.LogWarning` -> `ShareLogger.Instance.Warn`
- `Debug.LogError` / `Debug.LogException` -> `ShareLogger.Instance.Error`

## Usage Rules

- Always prefer `ShareLogger` and remove Unity/Console logging calls.
- Keep messages as plain strings (no required prefix).
- If a method already uses `ShareLogger`, keep it consistent.
- Do not add new logging frameworks or wrappers.
- If logging is not required, do not add logs.

## Examples

Replace:
```
Debug.Log("Load complete");
Debug.LogWarning("Missing config");
Debug.LogError("Load failed");
```

With:
```
ShareLogger.Instance.FuncInfo("Load complete");
ShareLogger.Instance.Warn("Missing config");
ShareLogger.Instance.Error("Load failed");
```

## Notes

- ShareLogger is provided via DLL; do not assume source code exists in the project.
- If the user explicitly requests Debug.Log, follow the request and document the exception.

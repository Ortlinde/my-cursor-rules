# My Cursor Rules

Cursor rules and postmortem knowledge base for Unity development. Claude Code skills and commands have been migrated to the [Ortlinde/eztools](https://github.com/Ortlinde/eztools) plugin `unity-dev-rules`.

## 快速開始

### 新專案設定

**1. 複製 Cursor 規則**

```powershell
git clone https://github.com/Ortlinde/my-cursor-rules.git
xcopy /E /Y "my-cursor-rules\.cursor" "YourProject\.cursor\"
```

**2. 安裝 Claude Code Skills**

```
/plugin marketplace add Ortlinde/eztools
/plugin install unity-dev-rules@ortlinde-tools
```

安裝後 `unity-dev-rules` 會在每次 session 自動將 skills 和 commands 安裝到 `~/.claude/`。

## 包含內容

### 📋 Rules (`.cursor/rules/`)

| 檔案 | 說明 |
|------|------|
| `enforce-rules.mdc` | 規則執行協議，最高優先級 |
| `my-base-rules.mdc` | 基本編碼規則（SOLID, DRY, 檔案長度限制等） |
| `postmortem-patterns.mdc` | Bug pattern 知識庫查詢規則 |
| `self-review-protocol.mdc` | 自動程式碼審查協議 |

### 🤖 Agents (`.cursor/agents/`)

| Agent | 說明 |
|-------|------|
| `code-reviewer` | Unity/C# 專屬程式碼審查，自動執行 Risk & Compliance Check |
| `complexity-triage` | 任務複雜度評估，回傳 TRIVIAL/HARD verdict 決定執行模式 |
| `rules-maintainer` | 維護 rules/agents 並同步至 GitHub repo |

### 🤖 Claude Code Skills & Commands

已移至 [Ortlinde/eztools](https://github.com/Ortlinde/eztools) plugin `unity-dev-rules`。

安裝方式：

```
/plugin marketplace add Ortlinde/eztools
/plugin install unity-dev-rules@ortlinde-tools
```

### 📚 Postmortem 知識庫 (`.cursor/postmortem/`)

歷史 Bug patterns 分類：
- `unity-lifecycle.md` - Unity 生命週期問題
- `unity-editor.md` - Editor 擴展問題
- `async-patterns.md` - 協程與異步問題
- `memory-management.md` - 記憶體管理問題
- `architecture.md` - 架構設計問題

## 更新規則

Pull 此 repo 後重新複製 `.cursor/` 到目標專案：

```powershell
git -C my-cursor-rules pull
xcopy /E /Y "my-cursor-rules\.cursor" "YourProject\.cursor\"
```

## 同步規則

適用於 Cursor rules 與 postmortem 知識庫的同步（不含 Claude skills）：

```
/pullRules    # repo → local（從 GitHub 拉取最新規則）
/pushRules    # local → repo（推送本地修改到 GitHub）
```

或使用 `rules-maintainer` subagent 進行進階維護：

```
請同步 rules/agents 到 GitHub repo
```

## 團隊專案注意事項

如果這是團隊專案但規則只供個人使用，請確保以下目錄被 `.gitignore` 忽略：

```gitignore
# Cursor AI Rules (個人使用)
.cursor/
.claude/
AGENTS.md
```

或設定全域 gitignore：

```powershell
git config --global core.excludesfile ~/.gitignore_global
```

## 官方 Global Skills

Global skills（如 `docx`、`pptx`、`xlsx`、`pdf`、`frontend-design`、`webapp-testing` 等）現已透過 Claude Code marketplace plugins 分發，包括 `creative-toolkit`、`document-toolkit`、`dev-toolkit`、`workflow-toolkit` 等。請透過 `/plugin marketplace` 安裝所需 plugin，無需 `setup.ps1` 自動安裝。

## License

MIT

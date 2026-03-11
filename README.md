# My Cursor Rules

Cursor rules for Unity development.

## 快速開始

### 方式一：一鍵安裝（推薦）

在目標專案目錄中執行：

```powershell
# PowerShell
irm https://raw.githubusercontent.com/Ortlinde/my-cursor-rules/main/setup.ps1 | iex
```

### 方式二：手動安裝

```powershell
# 1. Clone 此 repo
git clone https://github.com/Ortlinde/my-cursor-rules.git

# 2. 執行設定腳本
.\my-cursor-rules\setup.ps1 -Target "D:\Workspace\YourProject"
```

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
| `rules-maintainer` | 維護 rules/skills/agents 並同步至 GitHub repo |

### ⌨️ Slash Commands (`.claude/commands/`)

| Command | 說明 |
|---------|------|
| `/pullRules` | 從 GitHub repo 同步規則到本地（repo → local） |
| `/pushRules` | 推送本地規則到 GitHub repo（local → repo） |
| `/syncSkills` | 掃描已安裝的 skills，AI 自動生成描述並重建 AGENTS.md |

### 🔧 自訂 Skills (`.claude/skills/`)

| Skill | 說明 |
|-------|------|
| `coding-standards` | Unity 編碼規範、架構模式、重構指南 |
| `self-review` | 自我審查流程，包含 Risk Checklist |
| `sharelogger-usage` | 強制使用 ShareLogger 取代 Debug.Log |
| `deliberate-development` | 三階段開發協議：理解 → 設計 → 實作 |

### 📚 Postmortem 知識庫 (`.cursor/postmortem/`)

歷史 Bug patterns 分類：
- `unity-lifecycle.md` - Unity 生命週期問題
- `unity-editor.md` - Editor 擴展問題
- `async-patterns.md` - 協程與異步問題
- `memory-management.md` - 記憶體管理問題
- `architecture.md` - 架構設計問題

## 更新規則

重新執行安裝腳本即可獲取最新規則：

```powershell
irm https://raw.githubusercontent.com/Ortlinde/my-cursor-rules/main/setup.ps1 | iex
```

## 同步規則

使用 Slash Commands 快速同步（不詢問確認）：

```
/pullRules    # repo → local（從 GitHub 拉取最新規則）
/pushRules    # local → repo（推送本地修改到 GitHub）
```

或使用 `rules-maintainer` subagent 進行進階維護：

```
請同步 rules/skills/agents 到 GitHub repo
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

## 官方 OpenSkills

此 repo 的 `setup.ps1` 會自動安裝 [Anthropic 官方 OpenSkills](https://github.com/numman-ali/openskills)（17 個），包括：

- `docx` - Word 文件處理
- `pptx` - PowerPoint 處理
- `xlsx` - Excel 處理
- `pdf` - PDF 處理
- `frontend-design` - 前端設計
- `webapp-testing` - Web 應用測試
- ...等

## License

MIT

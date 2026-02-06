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

### 🔧 自訂 Skills (`.claude/skills/`)

| Skill | 說明 |
|-------|------|
| `coding-standards` | Unity 編碼規範、架構模式、重構指南 |
| `self-review` | 自我審查流程，包含 Risk Checklist |

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

此 repo 的 `setup.ps1` 會自動安裝 [Anthropic 官方 OpenSkills](https://github.com/anthropics/openskills)（17 個），包括：

- `docx` - Word 文件處理
- `pptx` - PowerPoint 處理
- `xlsx` - Excel 處理
- `pdf` - PDF 處理
- `frontend-design` - 前端設計
- `webapp-testing` - Web 應用測試
- ...等

## License

MIT

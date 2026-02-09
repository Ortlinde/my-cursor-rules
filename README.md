# My Cursor Rules

Cursor AI 開發規則，專為 Unity 開發優化。

## 快速開始

### 方式一：一鍵安裝（推薦）

在目標專案目錄中執行：

```batch
:: 使用 CMD（推薦，PowerShell 可能會擋 npm）
curl -o setup.bat https://raw.githubusercontent.com/Ortlinde/my-cursor-rules/main/setup.bat && setup.bat
```

或者手動下載後執行：

```batch
:: 下載並執行
git clone https://github.com/Ortlinde/my-cursor-rules.git
cd my-cursor-rules
setup.bat -Target "D:\Workspace\你的專案"
```

### 方式二：跳過 OpenSkills

如果不需要官方 Skills 或 npm 有問題：

```batch
setup.bat -Target "D:\Workspace\你的專案" -SkipOpenSkills
```

## 包含內容

### 📋 Rules（`.cursor/rules/`）

| 檔案 | 說明 |
|------|------|
| `enforce-rules.mdc` | 規則執行協議，最高優先級 |
| `my-base-rules.mdc` | 基本編碼規則（SOLID、DRY、檔案長度限制等） |
| `postmortem-patterns.mdc` | Bug pattern 知識庫查詢規則 |
| `self-review-protocol.mdc` | 自動程式碼審查協議 |

### 🤖 Agents（`.cursor/agents/`）

| Agent | 說明 |
|-------|------|
| `code-reviewer` | Unity/C# 專屬程式碼審查，自動執行 Risk & Compliance Check |

### 🔧 自訂 Skills（`.claude/skills/`）

| Skill | 說明 |
|-------|------|
| `coding-standards` | Unity 編碼規範、架構模式、重構指南 |
| `self-review` | 自我審查流程，包含 Risk Checklist |

### 📚 Postmortem 知識庫（`.cursor/postmortem/`）

歷史 Bug patterns 分類：
- `unity-lifecycle.md` - Unity 生命週期問題
- `unity-editor.md` - Editor 擴展問題
- `async-patterns.md` - 協程與異步問題
- `memory-management.md` - 記憶體管理問題
- `architecture.md` - 架構設計問題

## 系統需求

| 依賴 | 必要性 | 用途 | 下載 |
|------|--------|------|------|
| Git | ✅ 必要 | Clone 規則 repo | [git-scm.com](https://git-scm.com/downloads) |
| Node.js | ⚠️ 可選 | 執行官方 OpenSkills | [nodejs.org](https://nodejs.org/) |

**注意**：PowerShell 可能會擋下 `npm`、`npx` 等命令，建議使用傳統 CMD 執行腳本。

## 更新規則

重新執行安裝腳本即可獲取最新規則：

```batch
cd my-cursor-rules
git pull
setup.bat -Target "D:\Workspace\你的專案"
```

## 團隊專案注意事項

如果這是團隊專案但規則只供個人使用，請確保以下目錄被 `.gitignore` 忽略：

```gitignore
# Cursor AI Rules（個人使用）
.cursor/
.claude/
AGENTS.md
```

或設定全域 gitignore：

```batch
git config --global core.excludesfile %USERPROFILE%\.gitignore_global
```

然後編輯 `%USERPROFILE%\.gitignore_global` 加入上述內容。

## 官方 OpenSkills

`setup.bat` 會自動安裝 [Anthropic 官方 OpenSkills](https://github.com/anthropics/openskills)（17 個），包括：

- `docx` - Word 文件處理
- `pptx` - PowerPoint 處理
- `xlsx` - Excel 處理
- `pdf` - PDF 處理
- `frontend-design` - 前端設計
- `webapp-testing` - Web 應用測試
- ...等

如果不需要或 npm 有問題，可使用 `-SkipOpenSkills` 參數跳過。

## 檔案結構

```
my-cursor-rules/
├── .cursor/
│   ├── rules/           # 4 個自訂規則
│   ├── agents/          # code-reviewer
│   └── postmortem/      # Bug pattern 知識庫
├── .claude/
│   └── skills/
│       ├── coding-standards/
│       └── self-review/
├── AGENTS.md
├── setup.bat            # CMD 安裝腳本（推薦）
├── setup.ps1            # PowerShell 安裝腳本
└── README.md
```

## License

MIT

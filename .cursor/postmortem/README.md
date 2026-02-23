# 📚 Postmortem 知識庫

> DHF2_Unity 專案的 Bug 模式知識庫，用於減少 AI 輔助編碼（Vibe Coding）的迴歸問題。

## 🎯 目標

1. **累積經驗**：記錄歷史修復 changelist 的 bug 模式
2. **預防迴歸**：AI 編碼時自動比對已知風險
3. **知識傳承**：團隊共享除錯經驗

## 📁 目錄結構

```
.cursor/
├── rules/
│   └── postmortem-patterns.mdc    # AI 規則檔（自動載入）
└── postmortem/
    ├── README.md                  # 本文件
    ├── changelists/               # Changelist 分析紀錄
    │   └── CL-XXXXX.md           # 個別 CL 分析
    ├── categories/                # 分類索引 (通用，同步至 GitHub)
    │   ├── unity-lifecycle.md     # Unity 生命週期問題
    │   ├── unity-editor.md        # Unity Editor 問題
    │   ├── async-patterns.md      # 非同步模式問題
    │   ├── memory-management.md   # 記憶體管理問題
    │   └── architecture.md        # 架構設計問題
    └── project-specific/          # 專案專有模式 (不同步至 GitHub)
        └── framesync-provider.md  # FrameSync DLL Provider 問題
```

## 🔄 工作流程

### 新增 Bug 模式

1. **提供 Changelist**：將 Perforce CL 資訊貼給 AI 助手
2. **AI 分析**：自動提取症狀、根因、修復策略
3. **歸類儲存**：寫入對應的分類文件
4. **更新規則**：同步到 `postmortem-patterns.mdc`

### 使用知識庫

- AI 在每次編碼時自動載入 `postmortem-patterns.mdc`
- 修改程式碼前比對已知風險模式
- 提醒潛在問題

## 📋 Changelist 分析模板

當提供 CL 進行分析時，請包含：

```
CL#: 12345
描述: [修復說明]
修改檔案:
- Path/To/File1.cs
- Path/To/File2.cs

Diff:（如有）
```

## 🏷️ 標籤系統

| 標籤 | 說明 |
|------|------|
| `[UNITY]` | Unity 引擎相關 |
| `[ASYNC]` | 非同步/協程相關 |
| `[MEMORY]` | 記憶體/效能相關 |
| `[ARCH]` | 架構設計相關 |
| `[NET]` | 網路通訊相關 |
| `[UI]` | 介面相關 |

## 📈 維護紀錄

| 日期 | 動作 | 說明 |
|------|------|------|
| 2026-01-13 | 建立 | 初始化知識庫結構 |
| 2026-02-10 | 新增分類 | framesync-provider.md - 專案專有的 FrameSync DLL Provider 問題 |
| 2026-02-10 | 新增 P001 | [HIGH] Reentrant access to DLL Provider during FrameUpdate (framesync-provider.md) |
| 2026-02-23 | 搬移 | framesync-provider.md 從 categories/ 搬移至 project-specific/ (不同步 GitHub) |


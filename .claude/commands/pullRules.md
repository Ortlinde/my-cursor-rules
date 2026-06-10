從 GitHub repo 同步規則到本地專案。直接執行，不詢問確認。

## 執行步驟

1. 讀取 `~/.claude/MEMORY.md`，取得 `syncDir: <path>` 的值作為 `$syncDir`
   - 若無記錄：詢問用戶一次位置，確認後儲存至 `~/.claude/MEMORY.md`，再繼續
   - 路徑無 `.git/`：詢問是否在此 clone repo，同意則 clone，拒絕則停止

2. 執行：
   ```powershell
   $projectDir = (Get-Location).Path
   Set-Location $syncDir
   git pull origin main

   # Rules
   xcopy /E /Y "$syncDir\.cursor\rules\*" "$projectDir\.cursor\rules\"

   # Agents
   xcopy /E /Y "$syncDir\.cursor\agents\*" "$projectDir\.cursor\agents\"

   # Postmortem（排除 project-specific/）
   xcopy /E /Y /EXCLUDE:project-specific "$syncDir\.cursor\postmortem\*" "$projectDir\.cursor\postmortem\"

   # Commands
   xcopy /E /Y "$syncDir\.claude\commands\*" "$projectDir\.claude\commands\"
   ```

3. 回報：「pullRules 完成。已從 repo 同步至本地。」

從本地專案推送規則到 GitHub repo。直接執行，不詢問確認。

## 執行步驟

1. 讀取 `~/.claude/MEMORY.md`，取得 `syncDir: <path>` 的值作為 `$syncDir`
   - 若無記錄：詢問用戶一次位置，確認後儲存至 `~/.claude/MEMORY.md`，再繼續
   - 路徑無 `.git/`：詢問是否在此 clone repo，同意則 clone，拒絕則停止

2. 執行：
   ```powershell
   $projectDir = (Get-Location).Path

   # Rules
   xcopy /E /Y "$projectDir\.cursor\rules\*" "$syncDir\.cursor\rules\"

   # Agents
   xcopy /E /Y "$projectDir\.cursor\agents\*" "$syncDir\.cursor\agents\"

   # Postmortem（排除 project-specific/）
   xcopy /E /Y /EXCLUDE:project-specific "$projectDir\.cursor\postmortem\*" "$syncDir\.cursor\postmortem\"
   if (Test-Path "$syncDir\.cursor\postmortem\project-specific") {
       Remove-Item -Recurse -Force "$syncDir\.cursor\postmortem\project-specific"
   }

   # Skills：僅複製 location:global 的 skill（讀 AGENTS.md 判斷）
   # 解析 $projectDir\AGENTS.md，找出所有 <location>global</location> 的 skill name
   # 對每個 global skill 執行：
   xcopy /E /Y "$projectDir\.claude\skills\<skill-name>\*" "$syncDir\.claude\skills\<skill-name>\"

   # AGENTS.md
   Copy-Item -Path "$projectDir\AGENTS.md" -Destination "$syncDir\AGENTS.md" -Force

   # Commands (rules maintenance slash commands)
   xcopy /E /Y "$projectDir\.claude\commands\*" "$syncDir\.claude\commands\"

   # Commit & Push
   Set-Location $syncDir
   git add -A
   git commit -m "chore: sync rules to repo"
   git push origin main
   ```

3. 回報：「pushRules 完成。已推送至 GitHub repo。」

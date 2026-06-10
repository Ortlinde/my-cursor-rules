掃描所有已安裝的 skills（含 plugin），AI 自行閱讀內容生成描述，重建 AGENTS.md 的 `<available_skills>` 區段。直接執行，不詢問確認。

## 執行步驟

1. **確認專案目錄**
   - `$projectDir` = 當前工作目錄（`(Get-Location).Path`）
   - `$projectSkillsDir` = `$projectDir\.claude\skills`
   - `$pluginCacheDir` = `~/.claude/plugins/cache`（即 `$env:USERPROFILE\.claude\plugins\cache`）

2. **收集 plugin skills**
   - 遍歷 `$pluginCacheDir` 下所有 plugin 目錄（排除 `claude-plugins-official`）
   - 對每個 plugin：找到最新版本目錄，讀取 `.claude-plugin/plugin.json` 取得 plugin name
   - 掃描 plugin 的 `skills/` 子目錄，每個含 SKILL.md 的子目錄視為一個 skill
   - skill 名稱格式：`<plugin-name>:<skill-name>`

3. **收集 project skills**
   - 列出 `$projectSkillsDir` 的所有子目錄
   - 對每個 skill 目錄：
     - 讀取 `$projectSkillsDir\<skill-name>\SKILL.md` 前 60 行
     - **AI 自行撰寫** 1-2 句 trigger 描述（重點：何時使用、做什麼）
       - 描述風格：以動詞開頭，說明觸發條件和效果
       - 不要複製 frontmatter description，要根據內容重新理解
     - location = `project`

4. **重建 `<available_skills>` 區段**

   將所有 skill 分組（project 優先，接著按 plugin 分組）：

   ```xml
   <available_skills>

   <!-- PROJECT-SPECIFIC skills (this project only, not copied globally) -->

   <skill>
   <name>skill-name</name>
   <description>AI-generated description.</description>
   <location>project</location>
   </skill>

   <!-- PLUGIN-NAME plugin: plugin description -->

   <skill>
   <name>plugin-name:skill-name</name>
   <description>AI-generated description.</description>
   <location>plugin</location>
   <plugin>plugin-name</plugin>
   </skill>

   </available_skills>
   ```

5. **更新 AGENTS.md**
   - 讀取 `$projectDir\AGENTS.md`
   - 找出 `<available_skills>` 和 `</available_skills>` 之間的內容
   - 替換為步驟 4 重建的內容
   - 保留 `<!-- SKILLS_TABLE_START -->` / `<!-- SKILLS_TABLE_END -->` 和 `<usage>` 區段不動

6. **回報**
   ```
   syncSkills 完成。
   已註冊 X 個 skills（Y project, Z plugin）：
   - [project] skill-name: description
   - [plugin-name] skill-name: description
   ...
   ```

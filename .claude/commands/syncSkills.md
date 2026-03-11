掃描所有已安裝的 skills，AI 自行閱讀內容生成描述，重建 AGENTS.md 的 `<available_skills>` 區段。直接執行，不詢問確認。

## 執行步驟

1. **確認專案目錄**
   - `$projectDir` = 當前工作目錄（`(Get-Location).Path`）
   - `$projectSkillsDir` = `$projectDir\.claude\skills`
   - `$globalSkillsDir` = `~/.claude/skills`（即 `$env:USERPROFILE\.claude\skills`）

2. **收集 global skill 名稱**
   - 列出 `$globalSkillsDir` 的所有子目錄名稱，存為 `$globalSkillNames` 集合

3. **掃描 project skills**
   - 列出 `$projectSkillsDir` 的所有子目錄
   - 對每個 skill 目錄：
     - 讀取 `$projectSkillsDir\<skill-name>\SKILL.md` 前 60 行
     - **AI 自行撰寫** 1-2 句 trigger 描述（重點：何時使用、做什麼）
       - 描述風格：以動詞開頭，說明觸發條件和效果
       - 不要複製 frontmatter description，要根據內容重新理解
     - 判斷 location：
       - 若 skill 名稱在 `$globalSkillNames` 中 → `global`
       - 否則 → `project`

4. **重建 `<available_skills>` 區段**

   將所有 skill 分為兩組（project 優先）：

   ```xml
   <available_skills>

   <!-- PROJECT-SPECIFIC skills (this project only, not copied globally) -->

   <skill>
   <name>skill-name</name>
   <description>AI-generated description.</description>
   <location>project</location>
   </skill>

   <!-- GLOBAL skills (available in all projects via ~/.claude/skills/) -->

   <skill>
   <name>skill-name</name>
   <description>AI-generated description.</description>
   <location>global</location>
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
   已註冊 X 個 skills（Y project, Z global）：
   - [project] skill-name: description
   - [global]  skill-name: description
   ...
   ```

<#
.SYNOPSIS
    Cursor Rules 自動設定腳本
.DESCRIPTION
    自動安裝官方 OpenSkills 並套用自訂規則
.PARAMETER Target
    目標專案路徑（預設為當前目錄）
.PARAMETER SkipOpenSkills
    跳過官方 OpenSkills 安裝（僅套用自訂規則）
.EXAMPLE
    .\setup.ps1 -Target "D:\Workspace\NewProject"
.EXAMPLE
    # 在目標專案目錄中執行
    irm https://raw.githubusercontent.com/Ortlinde/my-cursor-rules/main/setup.ps1 | iex
.EXAMPLE
    # 跳過 OpenSkills，僅套用自訂規則
    .\setup.ps1 -SkipOpenSkills
#>

param(
    [string]$Target = (Get-Location).Path,
    [switch]$SkipOpenSkills
)

$ErrorActionPreference = "Continue"

# ============================================================
# 顯示 Banner
# ============================================================
Write-Host @"

  ╔══════════════════════════════════════════════════════════════╗
  ║           Cursor Rules 自動設定腳本 v1.1                     ║
  ║           https://github.com/Ortlinde/my-cursor-rules        ║
  ╚══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

Write-Host "目標目錄: $Target" -ForegroundColor Gray
Write-Host ""

# ============================================================
# 依賴檢查函數
# ============================================================
function Test-Command {
    param([string]$Command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'
    try {
        if (Get-Command $Command) { return $true }
    } catch {
        return $false
    } finally {
        $ErrorActionPreference = $oldPreference
    }
}

function Get-CommandVersion {
    param([string]$Command, [string]$VersionArg = "--version")
    try {
        $output = & $Command $VersionArg 2>&1
        return $output | Select-Object -First 1
    } catch {
        return "unknown"
    }
}

# ============================================================
# 步驟 0: 依賴檢查
# ============================================================
Write-Host "🔍 [0/4] 檢查系統依賴..." -ForegroundColor Yellow
Write-Host ""

$dependencies = @{
    "Git" = @{
        Command = "git"
        Required = $true
        Purpose = "下載規則 repo"
        InstallUrl = "https://git-scm.com/downloads"
    }
    "Node.js" = @{
        Command = "node"
        Required = $false
        Purpose = "執行 OpenSkills (npx)"
        InstallUrl = "https://nodejs.org/"
    }
    "npm" = @{
        Command = "npm"
        Required = $false
        Purpose = "執行 OpenSkills (npx)"
        InstallUrl = "隨 Node.js 一起安裝"
    }
}

$missingRequired = @()
$missingOptional = @()

foreach ($name in $dependencies.Keys) {
    $dep = $dependencies[$name]
    $exists = Test-Command $dep.Command
    
    if ($exists) {
        $version = Get-CommandVersion $dep.Command
        Write-Host "  ✅ $name" -ForegroundColor Green -NoNewline
        Write-Host " ($version)" -ForegroundColor Gray
    } else {
        if ($dep.Required) {
            Write-Host "  ❌ $name" -ForegroundColor Red -NoNewline
            Write-Host " (必要 - $($dep.Purpose))" -ForegroundColor Red
            $missingRequired += @{ Name = $name; Url = $dep.InstallUrl }
        } else {
            Write-Host "  ⚠️ $name" -ForegroundColor Yellow -NoNewline
            Write-Host " (可選 - $($dep.Purpose))" -ForegroundColor Yellow
            $missingOptional += @{ Name = $name; Url = $dep.InstallUrl }
        }
    }
}

Write-Host ""

# 必要依賴缺失，終止
if ($missingRequired.Count -gt 0) {
    Write-Host "❌ 缺少必要依賴，無法繼續安裝：" -ForegroundColor Red
    Write-Host ""
    foreach ($missing in $missingRequired) {
        Write-Host "  $($missing.Name)" -ForegroundColor Red
        Write-Host "    下載: $($missing.Url)" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "請安裝上述依賴後重新執行此腳本。" -ForegroundColor Yellow
    exit 1
}

# 可選依賴缺失，警告
if ($missingOptional.Count -gt 0) {
    Write-Host "⚠️ 部分可選依賴未安裝：" -ForegroundColor Yellow
    foreach ($missing in $missingOptional) {
        Write-Host "  $($missing.Name) - $($missing.Url)" -ForegroundColor Gray
    }
    Write-Host ""
    
    # 檢查是否缺少 Node.js/npm
    $hasNode = Test-Command "node"
    $hasNpm = Test-Command "npm"
    
    if (-not $hasNode -or -not $hasNpm) {
        Write-Host "  由於缺少 Node.js/npm，將跳過官方 OpenSkills 安裝。" -ForegroundColor Yellow
        Write-Host "  您仍可使用自訂規則，但官方 skills (docx, xlsx 等) 將無法使用。" -ForegroundColor Yellow
        Write-Host ""
        $SkipOpenSkills = $true
    }
}

# ============================================================
# 確認目標目錄存在
# ============================================================
if (-not (Test-Path $Target)) {
    Write-Host "❌ 目標目錄不存在: $Target" -ForegroundColor Red
    exit 1
}

# ============================================================
# 步驟 1: 安裝官方 OpenSkills (17 個)
# ============================================================
Write-Host "📦 [1/4] 安裝官方 OpenSkills..." -ForegroundColor Yellow

if ($SkipOpenSkills) {
    Write-Host "  ⏭️ 已跳過（缺少 Node.js 或使用 -SkipOpenSkills 參數）" -ForegroundColor Gray
} else {
    Push-Location $Target
    try {
        # 初始化 openskills（如果還沒有）
        if (-not (Test-Path ".claude\skills")) {
            Write-Host "  執行 openskills init..." -ForegroundColor Gray
            $initResult = npx openskills init --yes 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  ⚠️ openskills init 失敗" -ForegroundColor Yellow
                Write-Host "  $initResult" -ForegroundColor Gray
            }
        }
        
        # 同步官方 skills
        Write-Host "  執行 openskills sync..." -ForegroundColor Gray
        $syncResult = npx openskills sync 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ 官方 Skills 安裝完成 (17 個)" -ForegroundColor Green
        } else {
            Write-Host "  ⚠️ openskills sync 失敗，繼續其他步驟..." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  ⚠️ OpenSkills 安裝失敗: $_" -ForegroundColor Yellow
    }
    Pop-Location
}

# ============================================================
# 步驟 2: 下載自訂規則
# ============================================================
Write-Host ""
Write-Host "📥 [2/4] 下載自訂規則..." -ForegroundColor Yellow

$repoUrl = "https://github.com/Ortlinde/my-cursor-rules"
$tempDir = Join-Path $env:TEMP "cursor-rules-$(Get-Date -Format 'yyyyMMddHHmmss')"

$cloneOutput = git clone --depth 1 $repoUrl $tempDir 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ❌ Clone 失敗" -ForegroundColor Red
    Write-Host "  $cloneOutput" -ForegroundColor Gray
    Write-Host ""
    Write-Host "可能原因：" -ForegroundColor Yellow
    Write-Host "  - 網路連線問題" -ForegroundColor Gray
    Write-Host "  - GitHub 無法存取" -ForegroundColor Gray
    Write-Host "  - 防火牆阻擋" -ForegroundColor Gray
    exit 1
}
Write-Host "  ✅ 下載完成" -ForegroundColor Green

# ============================================================
# 步驟 3: 套用 .cursor 規則（完整覆蓋）
# ============================================================
Write-Host ""
Write-Host "📋 [3/4] 套用 .cursor 規則..." -ForegroundColor Yellow

# 複製 .cursor（rules, agents, postmortem）
if (Test-Path "$tempDir\.cursor") {
    Copy-Item -Path "$tempDir\.cursor" -Destination $Target -Recurse -Force
    Write-Host "  ✅ .cursor/rules/ (4 個規則檔)" -ForegroundColor Green
    Write-Host "  ✅ .cursor/agents/ (code-reviewer)" -ForegroundColor Green
    Write-Host "  ✅ .cursor/postmortem/ (bug patterns 知識庫)" -ForegroundColor Green
}

# ============================================================
# 步驟 4: 套用自訂 Skills（合併，不覆蓋官方）
# ============================================================
Write-Host ""
Write-Host "🔧 [4/4] 套用自訂 Skills..." -ForegroundColor Yellow

$customSkills = @("coding-standards", "self-review", "sharelogger-usage", "deliberate-development")

foreach ($skill in $customSkills) {
    $skillPath = Join-Path $tempDir ".claude\skills\$skill"
    if (Test-Path $skillPath) {
        $destPath = Join-Path $Target ".claude\skills\$skill"
        
        # 確保目標目錄存在
        $parentDir = Split-Path $destPath -Parent
        if (-not (Test-Path $parentDir)) {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }
        
        Copy-Item -Path $skillPath -Destination (Split-Path $destPath -Parent) -Recurse -Force
        Write-Host "  ✅ $skill" -ForegroundColor Green
    }
}

# ============================================================
# 步驟 5: 重新同步 AGENTS.md（如果有 npm）
# ============================================================
if (-not $SkipOpenSkills) {
    Write-Host ""
    Write-Host "🔄 重新同步 Skills 列表..." -ForegroundColor Yellow
    
    Push-Location $Target
    try {
        $syncResult = npx openskills sync 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ AGENTS.md 已更新" -ForegroundColor Green
        } else {
            Write-Host "  ⚠️ 同步失敗" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  ⚠️ 同步失敗" -ForegroundColor Yellow
    }
    Pop-Location
} else {
    # 沒有 OpenSkills，直接複製 AGENTS.md
    if (Test-Path "$tempDir\AGENTS.md") {
        Copy-Item -Path "$tempDir\AGENTS.md" -Destination $Target -Force
        Write-Host ""
        Write-Host "📄 已複製 AGENTS.md（僅包含自訂 skills）" -ForegroundColor Green
    }
}

# ============================================================
# 清理
# ============================================================
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

# ============================================================
# 完成訊息
# ============================================================
$openSkillsStatus = if ($SkipOpenSkills) { "❌ 未安裝（缺少 Node.js）" } else { "✅ 已安裝 (17 個)" }

Write-Host @"

╔══════════════════════════════════════════════════════════════╗
║                      ✅ 設定完成！                           ║
╚══════════════════════════════════════════════════════════════╝

已安裝：
  📦 官方 OpenSkills: $openSkillsStatus
  
  📋 自訂 Rules (4 個)
     - enforce-rules.mdc
     - my-base-rules.mdc
     - postmortem-patterns.mdc
     - self-review-protocol.mdc
  
  🤖 自訂 Agents (2 個)
     - code-reviewer (Unity/C# 專屬審查)
     - rules-maintainer (同步至 GitHub)
  
  🔧 自訂 Skills (4 個)
     - coding-standards (Unity 編碼規範)
     - self-review (自我審查流程)
     - sharelogger-usage (ShareLogger 強制使用)
     - deliberate-development (三階段開發協議)
  
  📚 Postmortem 知識庫
     - Bug patterns 分類與預防

"@ -ForegroundColor Cyan

if ($SkipOpenSkills) {
    Write-Host @"
💡 提示：安裝 Node.js 後可獲得更多功能：
   https://nodejs.org/
   
   安裝後執行以下命令啟用官方 Skills：
   npx openskills init --yes
   npx openskills sync

"@ -ForegroundColor Yellow
}

Write-Host "⚠️  提醒：如果這是團隊專案，請確保 .cursor/ 和 .claude/ 已加入 .gitignore" -ForegroundColor Yellow
Write-Host ""

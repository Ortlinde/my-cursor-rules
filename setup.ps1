<#
.SYNOPSIS
    Cursor Rules 自動設定腳本
.DESCRIPTION
    自動安裝官方 OpenSkills 並套用自訂規則
.PARAMETER Target
    目標專案路徑（預設為當前目錄）
.EXAMPLE
    .\setup.ps1 -Target "D:\Workspace\NewProject"
.EXAMPLE
    # 在目標專案目錄中執行
    irm https://raw.githubusercontent.com/Ortlinde/my-cursor-rules/main/setup.ps1 | iex
#>

param(
    [string]$Target = (Get-Location).Path
)

$ErrorActionPreference = "Continue"

Write-Host @"

  ╔══════════════════════════════════════════════════════════════╗
  ║           Cursor Rules 自動設定腳本 v1.0                     ║
  ║           https://github.com/Ortlinde/my-cursor-rules        ║
  ╚══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

Write-Host "目標目錄: $Target" -ForegroundColor Gray
Write-Host ""

# 確認目標目錄存在
if (-not (Test-Path $Target)) {
    Write-Host "❌ 目標目錄不存在: $Target" -ForegroundColor Red
    exit 1
}

# ============================================================
# 步驟 1: 安裝官方 OpenSkills (17 個)
# ============================================================
Write-Host "📦 [1/4] 安裝官方 OpenSkills..." -ForegroundColor Yellow

Push-Location $Target
try {
    # 檢查 npm 是否可用
    $npmVersion = npm --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  檢測到 npm $npmVersion" -ForegroundColor Gray
        
        # 初始化 openskills（如果還沒有）
        if (-not (Test-Path ".claude\skills")) {
            Write-Host "  執行 openskills init..." -ForegroundColor Gray
            npx openskills init --yes 2>$null
        }
        
        # 同步官方 skills
        Write-Host "  執行 openskills sync..." -ForegroundColor Gray
        npx openskills sync 2>$null
        
        Write-Host "  ✅ 官方 Skills 安裝完成 (17 個)" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️ npm 未安裝，跳過 OpenSkills 安裝" -ForegroundColor Yellow
        Write-Host "  提示: 稍後可手動執行 'npx openskills init && npx openskills sync'" -ForegroundColor Gray
    }
} catch {
    Write-Host "  ⚠️ OpenSkills 安裝失敗: $_" -ForegroundColor Yellow
}
Pop-Location

# ============================================================
# 步驟 2: 下載自訂規則
# ============================================================
Write-Host ""
Write-Host "📥 [2/4] 下載自訂規則..." -ForegroundColor Yellow

$repoUrl = "https://github.com/Ortlinde/my-cursor-rules"
$tempDir = Join-Path $env:TEMP "cursor-rules-$(Get-Date -Format 'yyyyMMddHHmmss')"

git clone --depth 1 $repoUrl $tempDir 2>$null

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ❌ Clone 失敗，請檢查網路連線" -ForegroundColor Red
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

$customSkills = @("coding-standards", "self-review")

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
# 步驟 5: 重新同步 AGENTS.md
# ============================================================
Write-Host ""
Write-Host "🔄 重新同步 Skills 列表..." -ForegroundColor Yellow

Push-Location $Target
try {
    npx openskills sync 2>$null
    Write-Host "  ✅ AGENTS.md 已更新" -ForegroundColor Green
} catch {
    Write-Host "  ⚠️ 同步失敗，請手動執行 'npx openskills sync'" -ForegroundColor Yellow
}
Pop-Location

# ============================================================
# 清理
# ============================================================
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

# ============================================================
# 完成訊息
# ============================================================
Write-Host @"

╔══════════════════════════════════════════════════════════════╗
║                      ✅ 設定完成！                           ║
╚══════════════════════════════════════════════════════════════╝

已安裝：
  📦 官方 OpenSkills (17 個)
     - docx, pptx, xlsx, pdf, frontend-design...
  
  📋 自訂 Rules (4 個)
     - enforce-rules.mdc
     - my-base-rules.mdc
     - postmortem-patterns.mdc
     - self-review-protocol.mdc
  
  🤖 自訂 Agents (1 個)
     - code-reviewer (Unity/C# 專屬審查)
  
  🔧 自訂 Skills (2 個)
     - coding-standards (Unity 編碼規範)
     - self-review (自我審查流程)
  
  📚 Postmortem 知識庫
     - Bug patterns 分類與預防

"@ -ForegroundColor Cyan

Write-Host "⚠️  提醒: 如果這是團隊專案，請確保 .cursor/ 和 .claude/ 已加入 .gitignore" -ForegroundColor Yellow
Write-Host ""

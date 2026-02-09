<#
.SYNOPSIS
    Cursor Rules Auto Setup Script
.DESCRIPTION
    Auto install official OpenSkills and apply custom rules
.PARAMETER Target
    Target project path (default: current directory)
.PARAMETER SkipOpenSkills
    Skip official OpenSkills installation (only apply custom rules)
.EXAMPLE
    .\setup.ps1 -Target "D:\Workspace\NewProject"
.EXAMPLE
    irm https://raw.githubusercontent.com/Ortlinde/my-cursor-rules/main/setup.ps1 | iex
.EXAMPLE
    .\setup.ps1 -SkipOpenSkills
#>

param(
    [string]$Target = (Get-Location).Path,
    [switch]$SkipOpenSkills
)

$ErrorActionPreference = "Continue"

# ============================================================
# Banner
# ============================================================
Write-Host @"

  +==============================================================+
  |           Cursor Rules Auto Setup v1.1                       |
  |           https://github.com/Ortlinde/my-cursor-rules        |
  +==============================================================+

"@ -ForegroundColor Cyan

Write-Host "Target: $Target" -ForegroundColor Gray
Write-Host ""

# ============================================================
# Dependency Check Functions
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
# Step 0: Dependency Check
# ============================================================
Write-Host "[0/4] Checking dependencies..." -ForegroundColor Yellow
Write-Host ""

$dependencies = @{
    "Git" = @{
        Command = "git"
        Required = $true
        Purpose = "Clone rules repo"
        InstallUrl = "https://git-scm.com/downloads"
    }
    "Node.js" = @{
        Command = "node"
        Required = $false
        Purpose = "Run OpenSkills (npx)"
        InstallUrl = "https://nodejs.org/"
    }
    "npm" = @{
        Command = "npm"
        Required = $false
        Purpose = "Run OpenSkills (npx)"
        InstallUrl = "Installed with Node.js"
    }
}

$missingRequired = @()
$missingOptional = @()

foreach ($name in $dependencies.Keys) {
    $dep = $dependencies[$name]
    $exists = Test-Command $dep.Command
    
    if ($exists) {
        $version = Get-CommandVersion $dep.Command
        Write-Host "  [OK] $name ($version)" -ForegroundColor Green
    } else {
        if ($dep.Required) {
            Write-Host "  [X] $name (Required - $($dep.Purpose))" -ForegroundColor Red
            $missingRequired += @{ Name = $name; Url = $dep.InstallUrl }
        } else {
            Write-Host "  [!] $name (Optional - $($dep.Purpose))" -ForegroundColor Yellow
            $missingOptional += @{ Name = $name; Url = $dep.InstallUrl }
        }
    }
}

Write-Host ""

# Required dependency missing - abort
if ($missingRequired.Count -gt 0) {
    Write-Host "[X] Missing required dependencies:" -ForegroundColor Red
    Write-Host ""
    foreach ($missing in $missingRequired) {
        Write-Host "  $($missing.Name)" -ForegroundColor Red
        Write-Host "    Download: $($missing.Url)" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "Please install the above dependencies and re-run this script." -ForegroundColor Yellow
    exit 1
}

# Optional dependency missing - warn
if ($missingOptional.Count -gt 0) {
    Write-Host "[!] Some optional dependencies not installed:" -ForegroundColor Yellow
    foreach ($missing in $missingOptional) {
        Write-Host "  $($missing.Name) - $($missing.Url)" -ForegroundColor Gray
    }
    Write-Host ""
    
    # Check if Node.js/npm missing
    $hasNode = Test-Command "node"
    $hasNpm = Test-Command "npm"
    
    if (-not $hasNode -or -not $hasNpm) {
        Write-Host "  Node.js/npm not found. Skipping official OpenSkills." -ForegroundColor Yellow
        Write-Host "  Custom rules will still work, but official skills (docx, xlsx, etc.) unavailable." -ForegroundColor Yellow
        Write-Host ""
        $SkipOpenSkills = $true
    }
}

# ============================================================
# Verify target directory exists
# ============================================================
if (-not (Test-Path $Target)) {
    Write-Host "[X] Target directory does not exist: $Target" -ForegroundColor Red
    exit 1
}

# ============================================================
# Step 1: Install official OpenSkills (17)
# ============================================================
Write-Host "[1/4] Installing official OpenSkills..." -ForegroundColor Yellow

if ($SkipOpenSkills) {
    Write-Host "  [Skip] (No Node.js or -SkipOpenSkills flag)" -ForegroundColor Gray
} else {
    Push-Location $Target
    try {
        # Init openskills if not exists
        if (-not (Test-Path ".claude\skills")) {
            Write-Host "  Running openskills init..." -ForegroundColor Gray
            $initResult = npx openskills init --yes 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  [!] openskills init failed" -ForegroundColor Yellow
            }
        }
        
        # Sync official skills
        Write-Host "  Running openskills sync..." -ForegroundColor Gray
        $syncResult = npx openskills sync --yes 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [OK] Official Skills installed (17)" -ForegroundColor Green
        } else {
            Write-Host "  [!] openskills sync failed, continuing..." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  [!] OpenSkills installation failed: $_" -ForegroundColor Yellow
    }
    Pop-Location
}

# ============================================================
# Step 2: Download custom rules
# ============================================================
Write-Host ""
Write-Host "[2/4] Downloading custom rules..." -ForegroundColor Yellow

$repoUrl = "https://github.com/Ortlinde/my-cursor-rules"
$tempDir = Join-Path $env:TEMP "cursor-rules-$(Get-Date -Format 'yyyyMMddHHmmss')"

$cloneOutput = git clone --depth 1 $repoUrl $tempDir 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "  [X] Clone failed" -ForegroundColor Red
    Write-Host "  $cloneOutput" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Possible causes:" -ForegroundColor Yellow
    Write-Host "  - Network connection issue" -ForegroundColor Gray
    Write-Host "  - GitHub unreachable" -ForegroundColor Gray
    Write-Host "  - Firewall blocking" -ForegroundColor Gray
    exit 1
}
Write-Host "  [OK] Download complete" -ForegroundColor Green

# ============================================================
# Step 3: Apply .cursor rules (full overwrite)
# ============================================================
Write-Host ""
Write-Host "[3/4] Applying .cursor rules..." -ForegroundColor Yellow

# Copy .cursor (rules, agents, postmortem)
if (Test-Path "$tempDir\.cursor") {
    Copy-Item -Path "$tempDir\.cursor" -Destination $Target -Recurse -Force
    Write-Host "  [OK] .cursor/rules/ (4 rule files)" -ForegroundColor Green
    Write-Host "  [OK] .cursor/agents/ (code-reviewer)" -ForegroundColor Green
    Write-Host "  [OK] .cursor/postmortem/ (bug patterns)" -ForegroundColor Green
}

# ============================================================
# Step 4: Apply custom Skills (merge, don't overwrite official)
# ============================================================
Write-Host ""
Write-Host "[4/4] Applying custom Skills..." -ForegroundColor Yellow

$customSkills = @("coding-standards", "self-review")

foreach ($skill in $customSkills) {
    $skillPath = Join-Path $tempDir ".claude\skills\$skill"
    if (Test-Path $skillPath) {
        $destPath = Join-Path $Target ".claude\skills\$skill"
        
        # Ensure target directory exists
        $parentDir = Split-Path $destPath -Parent
        if (-not (Test-Path $parentDir)) {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }
        
        Copy-Item -Path $skillPath -Destination (Split-Path $destPath -Parent) -Recurse -Force
        Write-Host "  [OK] $skill" -ForegroundColor Green
    }
}

# ============================================================
# Step 5: Re-sync AGENTS.md (if npm available)
# ============================================================
if (-not $SkipOpenSkills) {
    Write-Host ""
    Write-Host "Re-syncing Skills list..." -ForegroundColor Yellow
    
    Push-Location $Target
    try {
        $syncResult = npx openskills sync --yes 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [OK] AGENTS.md updated" -ForegroundColor Green
        } else {
            Write-Host "  [!] Sync failed" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  [!] Sync failed" -ForegroundColor Yellow
    }
    Pop-Location
} else {
    # No OpenSkills, just copy AGENTS.md
    if (Test-Path "$tempDir\AGENTS.md") {
        Copy-Item -Path "$tempDir\AGENTS.md" -Destination $Target -Force
        Write-Host ""
        Write-Host "[OK] Copied AGENTS.md (custom skills only)" -ForegroundColor Green
    }
}

# ============================================================
# Cleanup
# ============================================================
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

# ============================================================
# Done
# ============================================================
$openSkillsStatus = if ($SkipOpenSkills) { "[X] Not installed (No Node.js)" } else { "[OK] Installed (17)" }

Write-Host @"

+==============================================================+
|                      Setup Complete!                         |
+==============================================================+

Installed:
  Official OpenSkills: $openSkillsStatus
  
  Custom Rules (4)
     - enforce-rules.mdc
     - my-base-rules.mdc
     - postmortem-patterns.mdc
     - self-review-protocol.mdc
  
  Custom Agents (1)
     - code-reviewer (Unity/C# review)
  
  Custom Skills (2)
     - coding-standards (Unity coding standards)
     - self-review (Self-review workflow)
  
  Postmortem Knowledge Base
     - Bug patterns and prevention

"@ -ForegroundColor Cyan

if ($SkipOpenSkills) {
    Write-Host @"
Tip: Install Node.js for more features:
   https://nodejs.org/
   
   After installation, run:
   npx openskills init --yes
   npx openskills sync

"@ -ForegroundColor Yellow
}

Write-Host "Note: If this is a team project, add .cursor/ and .claude/ to .gitignore" -ForegroundColor Yellow
Write-Host ""

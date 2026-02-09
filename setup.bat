@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================
:: Cursor Rules Auto Setup v1.2
:: https://github.com/Ortlinde/my-cursor-rules
:: ============================================================

echo.
echo   +==============================================================+
echo   ^|           Cursor Rules Auto Setup v1.2                       ^|
echo   ^|           https://github.com/Ortlinde/my-cursor-rules        ^|
echo   +==============================================================+
echo.

:: Parse arguments
set "TARGET=%CD%"
set "SKIP_OPENSKILLS=0"

:parse_args
if "%~1"=="" goto :check_target
if /i "%~1"=="-Target" (
    set "TARGET=%~2"
    shift
    shift
    goto :parse_args
)
if /i "%~1"=="-SkipOpenSkills" (
    set "SKIP_OPENSKILLS=1"
    shift
    goto :parse_args
)
shift
goto :parse_args

:check_target
echo Target: %TARGET%
echo.

:: ============================================================
:: Step 0: Dependency Check
:: ============================================================
echo [0/4] Checking dependencies...
echo.

:: Check Git
where git >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo   [X] Git - NOT FOUND
    echo       Download: https://git-scm.com/downloads
    echo.
    echo [X] Missing required dependency. Please install Git and re-run.
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('git --version') do echo   [OK] %%i
)

:: Check Node.js
where node >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo   [!] Node.js - NOT FOUND ^(Optional^)
    echo       Download: https://nodejs.org/
    set "SKIP_OPENSKILLS=1"
) else (
    for /f "tokens=*" %%i in ('node --version') do echo   [OK] Node.js %%i
)

:: Check npm
where npm >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo   [!] npm - NOT FOUND ^(Optional^)
    set "SKIP_OPENSKILLS=1"
) else (
    for /f "tokens=*" %%i in ('npm --version 2^>nul') do echo   [OK] npm %%i
)

echo.

if "%SKIP_OPENSKILLS%"=="1" (
    echo [!] Node.js/npm not found. Skipping official OpenSkills.
    echo     Custom rules will still work.
    echo.
)

:: Verify target exists
if not exist "%TARGET%" (
    echo [X] Target directory does not exist: %TARGET%
    exit /b 1
)

:: ============================================================
:: Step 1: Install official OpenSkills
:: ============================================================
echo [1/4] Installing official OpenSkills...

if "%SKIP_OPENSKILLS%"=="1" (
    echo   [Skip] ^(No Node.js or -SkipOpenSkills flag^)
) else (
    pushd "%TARGET%"
    
    if not exist ".claude\skills" (
        echo   Running openskills init...
        call npx openskills init --yes >nul 2>&1
    )
    
    echo   Running openskills sync...
    call npx openskills sync --yes >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        echo   [OK] Official Skills installed ^(17^)
    ) else (
        echo   [!] openskills sync failed, continuing...
    )
    
    popd
)

:: ============================================================
:: Step 2: Download custom rules
:: ============================================================
echo.
echo [2/4] Downloading custom rules...

set "REPO_URL=https://github.com/Ortlinde/my-cursor-rules"
set "TEMP_DIR=%TEMP%\cursor-rules-%RANDOM%"

git clone --depth 1 %REPO_URL% "%TEMP_DIR%" >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo   [X] Clone failed
    echo   Possible causes:
    echo     - Network connection issue
    echo     - GitHub unreachable
    exit /b 1
)
echo   [OK] Download complete

:: ============================================================
:: Step 3: Apply .cursor rules
:: ============================================================
echo.
echo [3/4] Applying .cursor rules...

if exist "%TEMP_DIR%\.cursor" (
    xcopy "%TEMP_DIR%\.cursor" "%TARGET%\.cursor" /E /I /Y /Q >nul
    echo   [OK] .cursor/rules/ ^(4 rule files^)
    echo   [OK] .cursor/agents/ ^(code-reviewer^)
    echo   [OK] .cursor/postmortem/ ^(bug patterns^)
)

:: ============================================================
:: Step 4: Apply custom Skills
:: ============================================================
echo.
echo [4/4] Applying custom Skills...

:: Create .claude\skills if not exists
if not exist "%TARGET%\.claude\skills" (
    mkdir "%TARGET%\.claude\skills" >nul 2>&1
)

:: Copy coding-standards
if exist "%TEMP_DIR%\.claude\skills\coding-standards" (
    xcopy "%TEMP_DIR%\.claude\skills\coding-standards" "%TARGET%\.claude\skills\coding-standards" /E /I /Y /Q >nul
    echo   [OK] coding-standards
)

:: Copy self-review
if exist "%TEMP_DIR%\.claude\skills\self-review" (
    xcopy "%TEMP_DIR%\.claude\skills\self-review" "%TARGET%\.claude\skills\self-review" /E /I /Y /Q >nul
    echo   [OK] self-review
)

:: ============================================================
:: Step 5: Re-sync AGENTS.md
:: ============================================================
if "%SKIP_OPENSKILLS%"=="0" (
    echo.
    echo Re-syncing Skills list...
    
    pushd "%TARGET%"
    call npx openskills sync --yes >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        echo   [OK] AGENTS.md updated
    ) else (
        echo   [!] Sync failed
    )
    popd
) else (
    if exist "%TEMP_DIR%\AGENTS.md" (
        copy "%TEMP_DIR%\AGENTS.md" "%TARGET%\AGENTS.md" /Y >nul
        echo.
        echo [OK] Copied AGENTS.md ^(custom skills only^)
    )
)

:: ============================================================
:: Cleanup
:: ============================================================
if exist "%TEMP_DIR%" (
    rmdir /s /q "%TEMP_DIR%" >nul 2>&1
)

:: ============================================================
:: Done
:: ============================================================
echo.
echo   +==============================================================+
echo   ^|                      Setup Complete!                         ^|
echo   +==============================================================+
echo.
echo   Installed:
if "%SKIP_OPENSKILLS%"=="0" (
    echo     Official OpenSkills: [OK] 17 skills
) else (
    echo     Official OpenSkills: [X] Not installed ^(No Node.js^)
)
echo.
echo     Custom Rules ^(4^)
echo        - enforce-rules.mdc
echo        - my-base-rules.mdc
echo        - postmortem-patterns.mdc
echo        - self-review-protocol.mdc
echo.
echo     Custom Agents ^(1^)
echo        - code-reviewer ^(Unity/C# review^)
echo.
echo     Custom Skills ^(2^)
echo        - coding-standards
echo        - self-review
echo.
echo     Postmortem Knowledge Base
echo        - Bug patterns and prevention
echo.

if "%SKIP_OPENSKILLS%"=="1" (
    echo   Tip: Install Node.js for more features: https://nodejs.org/
    echo.
)

echo   Note: If this is a team project, add .cursor/ and .claude/ to .gitignore
echo.

endlocal

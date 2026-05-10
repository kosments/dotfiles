#Requires -Version 5.1
# Install dotfiles symlinks (Windows)
# Usage: .\bootstrap\install.ps1
# Idempotent: safe to run multiple times
#
# Prerequisite: Developer Mode ON
#   Settings -> Privacy & Security -> Developer Mode -> ON
#   (allows symlinks without admin rights)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$DOTFILES = "$HOME\dotfiles"
$script:Errors = 0

function Ok   { param($msg) Write-Host "  v $msg" -ForegroundColor Green }
function Skip { param($msg) Write-Host "  - $msg (already set)" -ForegroundColor DarkGray }
function Fail  { param($msg) Write-Host "  x $msg" -ForegroundColor Red; $script:Errors++ }

function New-Symlink {
  param(
    [string]$Src,
    [string]$Dst
  )

  if (-not (Test-Path $Src)) {
    Fail "source not found: $Src"
    return
  }

  if (Test-Path $Dst) {
    $item = Get-Item $Dst -Force
    if ($item.LinkType -eq "SymbolicLink" -and $item.Target -eq $Src) {
      Skip $Dst
      return
    }
    if ($item.LinkType -ne "SymbolicLink") {
      Fail "$Dst exists as a real file (backup and remove manually)"
      return
    }
    # 別の場所を指しているシンボリックリンクは上書き
    Remove-Item $Dst -Force
  }

  $parent = Split-Path $Dst
  if ($parent -and -not (Test-Path $parent)) {
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
  }

  $type = if (Test-Path $Src -PathType Container) { "Junction" } else { "SymbolicLink" }
  New-Item -ItemType $type -Path $Dst -Target $Src -Force | Out-Null
  Ok "$Dst -> $Src"
}

Write-Host "============================================================"
Write-Host " dotfiles symlink setup (Windows)"
Write-Host "============================================================"

# 必要ディレクトリを作成
@("$HOME\.aws", "$HOME\.config", "$HOME\AppData\Roaming\Code\User") | ForEach-Object {
  if (-not (Test-Path $_)) { New-Item -ItemType Directory -Path $_ -Force | Out-Null }
}

# Shell
Write-Host "[shell]"
$psProfileDir = Split-Path $PROFILE
if (-not (Test-Path $psProfileDir)) { New-Item -ItemType Directory $psProfileDir -Force | Out-Null }
New-Symlink "$DOTFILES\shell\profile.ps1" $PROFILE

# Git
Write-Host "[git]"
New-Symlink "$DOTFILES\.gitconfig" "$HOME\.gitconfig"

# Claude Code
Write-Host "[claude]"
New-Symlink "$DOTFILES\claude" "$HOME\.config\claude"
New-Symlink "$DOTFILES\claude\CLAUDE.md" "$HOME\CLAUDE.md"

# VSCode (Windows パス)
Write-Host "[vscode]"
New-Symlink "$DOTFILES\config\vscode\settings.json" "$HOME\AppData\Roaming\Code\User\settings.json"

# AWS
Write-Host "[aws]"
New-Symlink "$DOTFILES\config\aws\config" "$HOME\.aws\config"
# Note: credentials は git 管理外 (~\.aws\credentials)

Write-Host ""
if ($script:Errors -eq 0) {
  Write-Host "============================================================"
  Write-Host " All symlinks OK" -ForegroundColor Green
  Write-Host "============================================================"
} else {
  Write-Host "============================================================"
  Write-Host " $($script:Errors) error(s) — check output above" -ForegroundColor Red
  Write-Host "============================================================"
  exit 1
}

Write-Host ""
Write-Host "Next steps:"
Write-Host "  .\bootstrap\winget.ps1"
Write-Host ""

#Requires -Version 5.1
# Verify dotfiles symlinks and required commands (Windows)
# Usage: .\verify.ps1
# Exit code: 0 = all OK, 1 = failures found

Set-StrictMode -Version Latest
$DOTFILES = "$HOME\dotfiles"
$script:Pass = 0
$script:Fail = 0

function Pass { param($msg) Write-Host "  v $msg" -ForegroundColor Green;   $script:Pass++ }
function Fail  { param($msg) Write-Host "  x $msg" -ForegroundColor Red;    $script:Fail++ }

function Check-Symlink {
  param([string]$Dst, [string]$ExpectedSrc)
  if (-not (Test-Path $Dst -ErrorAction SilentlyContinue)) {
    Fail "missing: $Dst"
    return
  }
  $item = Get-Item $Dst -Force
  if ($item.LinkType -notin @("SymbolicLink","Junction")) {
    Fail "not a symlink: $Dst (real file exists)"
    return
  }
  if ($item.Target -eq $ExpectedSrc) {
    Pass "symlink: $Dst -> $ExpectedSrc"
  } else {
    Fail "wrong target: $Dst -> $($item.Target) (expected $ExpectedSrc)"
  }
}

function Check-Cmd {
  param([string]$Cmd)
  $found = Get-Command $Cmd -ErrorAction SilentlyContinue
  if ($found) {
    Pass "command: $Cmd ($($found.Source))"
  } else {
    Fail "command not found: $Cmd"
  }
}

Write-Host "============================================================"
Write-Host " dotfiles verify (Windows)"
Write-Host "============================================================"

Write-Host ""
Write-Host "[symlinks]"
Check-Symlink $PROFILE                                  "$DOTFILES\shell\profile.ps1"
Check-Symlink "$HOME\.gitconfig"                        "$DOTFILES\.gitconfig"
Check-Symlink "$HOME\.config\claude"                    "$DOTFILES\claude"
Check-Symlink "$HOME\CLAUDE.md"                         "$DOTFILES\claude\CLAUDE.md"
Check-Symlink "$HOME\.aws\config"                       "$DOTFILES\config\aws\config"
Check-Symlink "$HOME\AppData\Roaming\Code\User\settings.json" "$DOTFILES\config\vscode\settings.json"

Write-Host ""
Write-Host "[commands]"
Check-Cmd git
Check-Cmd gh
Check-Cmd winget
Check-Cmd node
Check-Cmd python

Write-Host ""
Write-Host "============================================================"
if ($script:Fail -eq 0) {
  Write-Host " All checks passed ($($script:Pass))" -ForegroundColor Green
  Write-Host "============================================================"
  exit 0
} else {
  Write-Host " $($script:Fail) failed, $($script:Pass) passed" -ForegroundColor Red
  Write-Host "============================================================"
  exit 1
}

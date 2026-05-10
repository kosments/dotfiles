#Requires -Version 5.1
# Install Windows packages via winget
# Usage: .\bootstrap\winget.ps1
# Idempotent: winget skips already-installed packages

Set-StrictMode -Version Latest

$DOTFILES = "$HOME\dotfiles"
$PackagesFile = "$DOTFILES\packages.json"

Write-Host "============================================================"
Write-Host " Installing packages via winget"
Write-Host "============================================================"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Host "winget not found. Install 'App Installer' from Microsoft Store." -ForegroundColor Red
  exit 1
}

if (-not (Test-Path $PackagesFile)) {
  Write-Host "packages.json not found: $PackagesFile" -ForegroundColor Red
  exit 1
}

winget import -i $PackagesFile --ignore-unavailable --accept-package-agreements --accept-source-agreements

# winget にないパッケージは Chocolatey で補完
if (Get-Command choco -ErrorAction SilentlyContinue) {
  Write-Host ""
  Write-Host "[chocolatey]"
  choco install -y make
} else {
  Write-Host ""
  Write-Host "  - Chocolatey not found, skipping choco packages" -ForegroundColor DarkGray
}

# WSL2 + Ubuntu
Write-Host ""
Write-Host "[wsl2]"
$wslDistros = wsl --list --quiet 2>$null
if ($wslDistros -match "Ubuntu") {
  Write-Host "  - Ubuntu already installed" -ForegroundColor DarkGray
} else {
  Write-Host "  Installing Ubuntu 24.04..."
  wsl --install -d Ubuntu-24.04
  Write-Host "  v WSL2 Ubuntu installed (reboot may be required)" -ForegroundColor Green
}

Write-Host ""
Write-Host "============================================================"
Write-Host " Packages installed" -ForegroundColor Green
Write-Host "============================================================"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  Restart terminal, then run: .\bootstrap\install.ps1"
Write-Host ""

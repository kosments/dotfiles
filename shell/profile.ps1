# PowerShell Profile (~/.zshrc equivalent for Windows)
# Managed via dotfiles: ~/dotfiles/shell/profile.ps1

# ============================================================
# Encoding
# ============================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# ============================================================
# Aliases
# ============================================================
Set-Alias ll   Get-ChildItem
Set-Alias grep Select-String
Set-Alias touch New-Item
function which { Get-Command $args[0] | Select-Object -ExpandProperty Source }

# ============================================================
# Git shortcuts
# ============================================================
function gs  { git status }
function gp  { git push }
function gl  { git pull }
function glo { git log --oneline -10 }
function gco { git checkout $args }
function gb  { git branch $args }

# ============================================================
# Navigation
# ============================================================
function dev      { Set-Location "$HOME\dev" }
function dotfiles { Set-Location "$HOME\dotfiles" }

# ============================================================
# Prompt (Starship)
# ============================================================
if (Get-Command starship -ErrorAction SilentlyContinue) {
  Invoke-Expression (&starship init powershell)
}

# ============================================================
# PATH additions
# ============================================================
$env:PATH = "$HOME\.local\bin;$env:PATH"

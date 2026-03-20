# dotfiles

Personal dotfiles and Claude Code settings.

## 構成

```
dotfiles/
├── claude/
│   ├── CLAUDE.md
│   ├── settings.json
│   ├── settings.local.json
│   ├── statusline-command.sh
│   ├── global.md
│   └── skills/
├── .zshrc
├── .gitconfig
└── README.md
```

## インストール

```bash
git clone https://github.com/kosments/dotfiles.git ~/dotfiles

# dotfiles を symlink で展開
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.gitconfig ~/.gitconfig

# Claude設定を展開
ln -s ~/dotfiles/claude ~/.config/claude
ln -s ~/dotfiles/claude/CLAUDE.md ~/CLAUDE.md
```

## 運用ルール

- 編集は `~/dotfiles` 配下のみで行う
- ホーム直下は symlink のみで、直接編集しない
- Claude設定も必ず dotfiles で管理する

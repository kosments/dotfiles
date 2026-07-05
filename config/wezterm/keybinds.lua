-- WezTerm キーバインド設定
-- Leader キー（Ctrl+Q）を起点としたペイン・タブ・ワークスペース操作を定義
-- 操作方法: Ctrl+Q を押して離す → 2秒以内に次のキーを押す（tmuxと同じ）
local wezterm = require("wezterm")
local act = wezterm.action

-- アクティブなキーテーブル名を右ステータスに表示
-- resize_pane や activate_pane モード中に右上に "TABLE: ..." と表示される
wezterm.on("update-right-status", function(window, pane)
  local name = window:active_key_table()
  if name then
    name = "TABLE: " .. name
  end
  window:set_right_status(name or "")
end)

return {
  keys = {
    ----------------------------------------------------
    -- Workspace（作業空間）管理
    ----------------------------------------------------
    {
      -- Leader+w: ワークスペース一覧を表示して切り替え
      key = "w",
      mods = "LEADER",
      action = act.ShowLauncherArgs({ flags = "WORKSPACES", title = "Select workspace" }),
    },
    {
      -- Leader+$: 現在のワークスペースをリネーム
      key = "$",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = "(wezterm) Set workspace title:",
        action = wezterm.action_callback(function(win, pane, line)
          if line then
            wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
          end
        end),
      }),
    },
    {
      -- Leader+Shift+W: 新しいワークスペースを作成して移動
      key = "W",
      mods = "LEADER|SHIFT",
      action = act.PromptInputLine({
        description = "(wezterm) Create new workspace:",
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(
              act.SwitchToWorkspace({
                name = line,
              }),
              pane
            )
          end
        end),
      }),
    },

    ----------------------------------------------------
    -- タブ操作
    ----------------------------------------------------
    -- Cmd+P: コマンドパレット表示
    { key = "p", mods = "SUPER", action = act.ActivateCommandPalette },
    -- Ctrl+Tab / Ctrl+Shift+Tab: 次/前のタブへ移動
    { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
    { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
    -- Leader+{ / Leader+}: タブを左/右へ移動
    { key = "{", mods = "LEADER", action = act({ MoveTabRelative = -1 }) },
    { key = "}", mods = "LEADER", action = act({ MoveTabRelative = 1 }) },
    -- Cmd+T: 新規タブを開く
    { key = "t", mods = "SUPER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
    -- Cmd+W: 現在のタブを閉じる（確認あり）
    { key = "w", mods = "SUPER", action = act({ CloseCurrentTab = { confirm = true } }) },
    -- Cmd+1〜9: タブ番号で直接切り替え（9は最後のタブ）
    { key = "1", mods = "SUPER", action = act.ActivateTab(0) },
    { key = "2", mods = "SUPER", action = act.ActivateTab(1) },
    { key = "3", mods = "SUPER", action = act.ActivateTab(2) },
    { key = "4", mods = "SUPER", action = act.ActivateTab(3) },
    { key = "5", mods = "SUPER", action = act.ActivateTab(4) },
    { key = "6", mods = "SUPER", action = act.ActivateTab(5) },
    { key = "7", mods = "SUPER", action = act.ActivateTab(6) },
    { key = "8", mods = "SUPER", action = act.ActivateTab(7) },
    { key = "9", mods = "SUPER", action = act.ActivateTab(-1) },

    ----------------------------------------------------
    -- 画面・ウィンドウ
    ----------------------------------------------------
    -- Alt+Enter: フルスクリーン切り替え
    { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
    -- フォントサイズ変更（macOS 標準の Cmd++/Cmd+-/Cmd+0）
    { key = "+", mods = "SUPER", action = act.IncreaseFontSize },
    { key = "-", mods = "SUPER", action = act.DecreaseFontSize },
    { key = "0", mods = "SUPER", action = act.ResetFontSize },

    ----------------------------------------------------
    -- コピー・ペースト・スクロール
    ----------------------------------------------------
    -- Leader+[: コピーモードに入る（vi風の選択・コピー）
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    -- Cmd+C: クリップボードにコピー
    { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
    -- Cmd+V: クリップボードからペースト
    { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
    -- Shift+↑/↓: 前後のシェルプロンプトまでスクロールジャンプ
    -- shell integration（OSC 133）が必要: zshの場合はshell-integrationを設定する
    { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
    { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },

    ----------------------------------------------------
    -- カーソル・テキスト操作
    ----------------------------------------------------
    -- Meta+←/→: 単語単位でカーソル移動（ESC+b/f シーケンスをシェルに送信）
    { key = "LeftArrow", mods = "META", action = act.SendString("\x1bb") },
    { key = "RightArrow", mods = "META", action = act.SendString("\x1bf") },

    ----------------------------------------------------
    -- ペイン（画面分割）操作
    ----------------------------------------------------
    -- Leader+d: 縦に分割（上下）
    { key = "d", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    -- Leader+r: 横に分割（左右）
    { key = "r", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    -- Cmd+D: 右に分割（VS Code互換）
    { key = "d", mods = "SUPER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    -- Cmd+Shift+D: 下に分割（VS Code互換）
    { key = "d", mods = "SUPER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    -- Leader+x: 現在のペインを閉じる（確認あり）
    { key = "x", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },
    -- Leader+hjkl: vi風ペイン移動
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    -- Ctrl+Shift+[: ペイン選択モード（番号で選択）
    { key = "[", mods = "CTRL|SHIFT", action = act.PaneSelect },
    -- Leader+z: 現在のペインをズーム（全画面表示/解除）
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    -- Leader+f: 左30%にファイルエクスプローラーペインを開く（VS Code風レイアウト）
    -- zsh -l でログインシェルとして起動しHomebrewのPATHを引き継ぐ
    -- yazi をインストールすると args を { "/bin/zsh", "-l", "-c", "yazi" } に変更するとより快適
    {
      key = "f",
      mods = "LEADER",
      action = act.SplitPane({
        direction = "Left",
        size = { Percent = 30 },
        command = { args = { "/bin/zsh", "-l", "-c", "nvim ." } },
      }),
    },

    ----------------------------------------------------
    -- その他・開発支援
    ----------------------------------------------------
    -- Ctrl+Shift+P: コマンドパレット
    { key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    -- Ctrl+Shift+R: 設定ファイルを手動で再読み込み
    { key = "r", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
    -- Leader+e: cc-dev セッション起動（リポジトリとタスクフォルダを入力）
    {
      key = "e",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = "cc-dev [repo] [task_folder]  (Enter=実行, Esc=キャンセル):",
        action = wezterm.action_callback(function(window, pane, line)
          if line and line ~= "" then
            pane:send_text("cc-dev " .. line .. "\n")
          elseif line == "" then
            pane:send_text("cc-dev\n")
          end
        end),
      }),
    },
    -- Leader+s: ペインサイズ調整モード（hjklで調整、Enterで終了）
    { key = "s", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
    -- Leader+a: ペイン移動モード（1000ms タイムアウト）
    {
      key = "a",
      mods = "LEADER",
      action = act.ActivateKeyTable({ name = "activate_pane", timeout_milliseconds = 1000 }),
    },
  },

  ----------------------------------------------------
  -- マウスバインド
  ----------------------------------------------------
  mouse_bindings = {
    -- トリプルクリック: コマンド出力全体（SemanticZone）を選択
    -- shell integration が有効な場合に OSC 133 で区切られた出力ブロックを一括選択できる
    {
      event = { Down = { streak = 3, button = "Left" } },
      action = act.SelectTextAtMouseCursor("SemanticZone"),
    },
  },

  ----------------------------------------------------
  -- キーテーブル（モード別キーバインド）
  -- 参考: https://wezfurlong.org/wezterm/config/key-tables.html
  ----------------------------------------------------
  key_tables = {
    -- ペインサイズ調整モード（Leader+s で起動）
    -- hjkl で1列ずつサイズ変更、Enter で終了
    resize_pane = {
      { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
      { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
      { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
      { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
      { key = "Enter", action = "PopKeyTable" },
    },

    -- ペイン移動モード（Leader+a で起動、1000ms タイムアウト）
    activate_pane = {
      { key = "h", action = act.ActivatePaneDirection("Left") },
      { key = "l", action = act.ActivatePaneDirection("Right") },
      { key = "k", action = act.ActivatePaneDirection("Up") },
      { key = "j", action = act.ActivatePaneDirection("Down") },
    },

    -- コピーモード（Leader+[ で起動）
    -- vi風のカーソル移動でテキストを選択してコピー
    copy_mode = {
      -- カーソル移動（hjkl）
      { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
      { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
      -- 行頭・行末へ移動
      { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      -- 選択範囲の反対端へ移動
      { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
      { key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
      -- 単語単位で移動
      { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
      { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
      -- 文字ジャンプ（t/f: 前方、T/F: 後方）
      { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
      { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
      { key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      -- バッファの先頭・末尾へ移動
      { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
      { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
      -- ビューポート内の移動（H: 上端、M: 中央、L: 下端）
      { key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
      { key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
      { key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
      -- ページスクロール
      { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
      { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
      { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
      { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
      -- 選択モード切り替え（v: 文字、Ctrl+v: ブロック、V: 行）
      { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
      { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      -- y: 選択範囲をクリップボードにコピー
      { key = "y", mods = "NONE", action = act.CopyTo("Clipboard") },
      -- Enter: コピーしてコピーモードを終了
      {
        key = "Enter",
        mods = "NONE",
        action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
      },
      -- Escape / Ctrl+C / q: コピーモードを終了
      { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
      { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
      { key = "q", mods = "NONE", action = act.CopyMode("Close") },
    },
  },
}

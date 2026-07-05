-- WezTerm メイン設定ファイル
-- キーバインドは keybinds.lua に分離して管理
local wezterm = require("wezterm")
local config = wezterm.config_builder()

----------------------------------------------------
-- 基本設定
----------------------------------------------------
-- 設定ファイルの変更を自動検知して再読み込み
config.automatically_reload_config = true
-- フォントサイズ
config.font_size = 12.0
-- macOS IME（日本語入力）を有効化
config.use_ime = true
-- ウィンドウの背景透過度（0.0=完全透明, 1.0=不透明）
config.window_background_opacity = 0.85
-- 背景ブラーの強さ（透過と組み合わせてすりガラス風）
config.macos_window_background_blur = 20
-- スクロールバック行数（多めに確保してログ遡及を容易に）
config.scrollback_lines = 10000
-- フレームレート上限（スクロール・アニメーションを滑らかに）
config.max_fps = 120
-- タブを閉じたとき、直前にアクティブだったタブに戻る
config.switch_to_last_active_tab_when_closing_tab = true
-- タブタイトルの最大文字幅
config.tab_max_width = 32
-- 非アクティブペインを少し暗くしてフォーカス位置を明確に（VS Code風）
config.inactive_pane_hsb = { brightness = 0.85 }

----------------------------------------------------
-- タブバー
----------------------------------------------------
-- タイトルバーを非表示（リサイズハンドルのみ残す）
config.window_decorations = "RESIZE"
-- タブバーを表示
config.show_tabs_in_tab_bar = true
-- タブが1つの時はタブバーを非表示
config.hide_tab_bar_if_only_one_tab = true
-- falseにするとタブバーの透過が効かなくなる
-- config.use_fancy_tab_bar = false

-- タブバーを透過させる（背景色をnoneに設定）
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

-- タブバーの背景を黒に統一してウィンドウ背景と馴染ませる
config.window_background_gradient = {
  colors = { "#000000" },
}

-- タブの追加（+）ボタンを非表示
config.show_new_tab_button_in_tab_bar = false
-- タブの閉じる（×）ボタンを非表示（nightly版のみ）
config.show_close_tab_button_in_tabs = false

-- タブ間の境界線を非表示
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}

-- タブタイトルの装飾用 NerdFonts 文字
-- 左側: 右下三角形でタブ左端を装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- 右側: 左上三角形でタブ右端を装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

-- タブタイトルのカスタム描画
-- アクティブタブ: 金色 (#ae8b2d)、非アクティブ: グレー (#5c6d74)
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"
  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

----------------------------------------------------
-- スクロールバー（動的制御）
----------------------------------------------------
-- コンテンツがビューポートを超えた場合のみスクロールバーを表示
-- オルタネートスクリーン（vim等）では常に非表示
wezterm.on("update-status", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local dimensions = pane:get_dimensions()
  overrides.enable_scroll_bar = dimensions.scrollback_rows > dimensions.viewport_rows
    and not pane:is_alt_screen_active()
  window:set_config_overrides(overrides)
end)

----------------------------------------------------
-- キーバインド・マウスバインド
----------------------------------------------------
-- デフォルトキーバインドを保持しつつカスタムキーバインドで拡張
config.disable_default_key_bindings = false
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.mouse_bindings = require("keybinds").mouse_bindings
-- Leader キー: Ctrl+Q を離した後2秒以内に次のキーを押す（tmuxのプレフィックスと同じ操作）
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

return config

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Terminal — Kitty + Alacritty                                                ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║                                                                              ║
# ║  Два терминала для сравнения:                                                ║
# ║                                                                              ║
# ║  KITTY:                                                                      ║
# ║  • GPU-рендеринг, прозрачность, лигатуры                                     ║
# ║  • Tabs и splits (Ctrl+Shift+T, Ctrl+Shift+Enter)                            ║
# ║  • Запуск: kitty или Super+Return                                            ║
# ║                                                                              ║
# ║  ALACRITTY:                                                                  ║
# ║  • Самый быстрый терминал (Rust + GPU)                                       ║
# ║  • Минималистичный, без tabs (используй tmux)                                ║
# ║  • Запуск: alacritty                                                         ║
# ║                                                                              ║
# ║  ТЕМА: Catppuccin Mocha                                                      ║
# ║                                                                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    font = { name = "JetBrainsMono Nerd Font"; size = 12; };
    settings = {
      background_opacity = "0.85";
      window_padding_width = 10;
      hide_window_decorations = true;
      confirm_os_window_close = 0;
      cursor_shape = "beam";
      scrollback_lines = 10000;
      enable_audio_bell = false;

      foreground = "#CDD6F4";
      background = "#1E1E2E";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";
      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";

      color0 = "#45475A"; color8 = "#585B70";
      color1 = "#F38BA8"; color9 = "#F38BA8";
      color2 = "#A6E3A1"; color10 = "#A6E3A1";
      color3 = "#F9E2AF"; color11 = "#F9E2AF";
      color4 = "#89B4FA"; color12 = "#89B4FA";
      color5 = "#F5C2E7"; color13 = "#F5C2E7";
      color6 = "#94E2D5"; color14 = "#94E2D5";
      color7 = "#BAC2DE"; color15 = "#A6ADC8";
    };
    keybindings = {
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+plus" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
        size = 12;
      };
      window = { padding = { x = 10; y = 10; }; opacity = 0.85; decorations = "None"; };
      cursor = { style = { shape = "Beam"; blinking = "On"; }; };
      colors = {
        primary = { background = "#1E1E2E"; foreground = "#CDD6F4"; };
        cursor = { text = "#1E1E2E"; cursor = "#F5E0DC"; };
        normal = {
          black = "#45475A"; red = "#F38BA8"; green = "#A6E3A1"; yellow = "#F9E2AF";
          blue = "#89B4FA"; magenta = "#F5C2E7"; cyan = "#94E2D5"; white = "#BAC2DE";
        };
        bright = {
          black = "#585B70"; red = "#F38BA8"; green = "#A6E3A1"; yellow = "#F9E2AF";
          blue = "#89B4FA"; magenta = "#F5C2E7"; cyan = "#94E2D5"; white = "#A6ADC8";
        };
      };
    };
  };
}

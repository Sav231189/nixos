# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Home Manager: Терминал (Kitty)                                              ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Настройка GPU-accelerated терминала Kitty с прозрачностью.                  ║
# ║                                                                              ║
# ║  ОСОБЕННОСТИ KITTY:                                                          ║
# ║  • GPU-рендеринг — молниеносная отрисовка текста                             ║
# ║  • Прозрачность 85% — красивый современный вид                               ║
# ║  • Лигатуры — красивые символы для кода (!=, ===, -> и т.д.)                 ║
# ║  • Splits и Tabs — работа с несколькими терминалами                          ║
# ║                                                                              ║
# ║  ТЕМА: Catppuccin Mocha (тёмная, мягкие цвета)                               ║
# ║                                                                              ║
# ║  ХОТКЕИ:                                                                     ║
# ║  Ctrl+Shift+Enter     — новое окно (split)                                   ║
# ║  Ctrl+Shift+T         — новая вкладка                                        ║
# ║  Ctrl+Plus/Minus      — увеличить/уменьшить шрифт                            ║
# ║  Ctrl+Shift+A, M      — увеличить прозрачность                               ║
# ║  Ctrl+Shift+A, L      — уменьшить прозрачность                               ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    
    # Font
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      # === Appearance ===
      
      # Background opacity (transparency!) 
      background_opacity = "0.85";
      dynamic_background_opacity = true;
      
      # Blur (requires compositor support)
      # background_blur = 20;
      
      # Window
      window_padding_width = 10;
      hide_window_decorations = true;
      confirm_os_window_close = 0;
      
      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";
      
      # Scrollback
      scrollback_lines = 10000;
      
      # Bell
      enable_audio_bell = false;
      visual_bell_duration = "0.0";
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
      
      # URLs
      url_style = "curly";
      open_url_with = "default";
      detect_urls = true;

      # === Catppuccin Mocha Theme ===
      
      # Foreground/Background
      foreground = "#CDD6F4";
      background = "#1E1E2E";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";
      
      # Cursor
      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";
      
      # URL
      url_color = "#F5E0DC";
      
      # Tab bar
      active_tab_foreground = "#11111B";
      active_tab_background = "#CBA6F7";
      inactive_tab_foreground = "#CDD6F4";
      inactive_tab_background = "#181825";
      tab_bar_background = "#11111B";
      
      # Colors
      # Black
      color0 = "#45475A";
      color8 = "#585B70";
      # Red
      color1 = "#F38BA8";
      color9 = "#F38BA8";
      # Green
      color2 = "#A6E3A1";
      color10 = "#A6E3A1";
      # Yellow
      color3 = "#F9E2AF";
      color11 = "#F9E2AF";
      # Blue
      color4 = "#89B4FA";
      color12 = "#89B4FA";
      # Magenta
      color5 = "#F5C2E7";
      color13 = "#F5C2E7";
      # Cyan
      color6 = "#94E2D5";
      color14 = "#94E2D5";
      # White
      color7 = "#BAC2DE";
      color15 = "#A6ADC8";
      
      # Marks
      mark1_foreground = "#1E1E2E";
      mark1_background = "#B4BEFE";
      mark2_foreground = "#1E1E2E";
      mark2_background = "#CBA6F7";
      mark3_foreground = "#1E1E2E";
      mark3_background = "#74C7EC";
    };

    # Keybindings
    keybindings = {
      # Splits (like tmux)
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+h" = "previous_window";
      "ctrl+shift+l" = "next_window";
      
      # Tabs
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      
      # Font size
      "ctrl+plus" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+0" = "change_font_size all 0";
      
      # Scrollback
      "ctrl+shift+k" = "scroll_line_up";
      "ctrl+shift+j" = "scroll_line_down";
      "ctrl+shift+page_up" = "scroll_page_up";
      "ctrl+shift+page_down" = "scroll_page_down";
      "ctrl+shift+home" = "scroll_home";
      "ctrl+shift+end" = "scroll_end";
      
      # Opacity
      "ctrl+shift+a>m" = "set_background_opacity +0.1";
      "ctrl+shift+a>l" = "set_background_opacity -0.1";
      "ctrl+shift+a>1" = "set_background_opacity 1";
      "ctrl+shift+a>d" = "set_background_opacity default";
    };
  };
}

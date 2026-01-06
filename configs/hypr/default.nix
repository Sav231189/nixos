# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Hyprland — Конфигурация рабочего стола                                      ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║                                                                              ║
# ║  Hyprland — тайловый Wayland композитор.                                     ║
# ║                                                                              ║
# ║  КОМПОНЕНТЫ:                                                                 ║
# ║  • Hyprland  — оконный менеджер                                              ║
# ║  • Waybar    — верхняя панель                                                ║
# ║  • Wofi      — лаунчер приложений (Super+D)                                  ║
# ║  • Dunst     — уведомления                                                   ║
# ║                                                                              ║
# ║  ГОРЯЧИЕ КЛАВИШИ:                                                            ║
# ║  Super + Return    — терминал                                                ║
# ║  Super + D         — лаунчер                                                 ║
# ║  Super + Q         — закрыть окно                                            ║
# ║  Super + 1-0       — рабочие столы                                           ║
# ║  Super + Shift+1-0 — переместить окно                                        ║
# ║  Super + F         — полноэкранный режим                                     ║
# ║  Super + Space     — плавающий режим                                         ║
# ║  Print             — скриншот области                                        ║
# ║                                                                              ║
# ║  ТЕМА: Catppuccin Mocha                                                      ║
# ║                                                                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1.25";
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$browser" = "firefox";
      "$fileManager" = "nautilus";
      "$menu" = "wofi --show drun";

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ee) rgba(89b4faee) 45deg";
        "col.inactive_border" = "rgba(585b70aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        blur = { enabled = true; size = 8; passes = 3; };
        shadow = {
          enabled = true;
          range = 15;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        active_opacity = 1.0;
        inactive_opacity = 0.9;
      };

      animations = {
        enabled = true;
        bezier = [ "easeOutQuint, 0.22, 1, 0.36, 1" ];
        animation = [
          "windows, 1, 4, easeOutQuint"
          "fade, 1, 3, easeOutQuint"
          "workspaces, 1, 2, easeOutQuint"
        ];
      };

      dwindle = { pseudotile = true; preserve_split = true; };
      misc = { force_default_wallpaper = 0; disable_hyprland_logo = true; };

      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle";
        follow_mouse = 1;
        touchpad = { natural_scroll = true; tap-to-click = true; disable_while_typing = true; };
      };

      # gestures.workspace_swipe = true;

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, B, exec, $browser"
        "$mod, E, exec, $fileManager"
        "$mod, D, exec, $menu"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, F, fullscreen"
        "$mod, Space, togglefloating"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod, 1, workspace, 1" "$mod, 2, workspace, 2" "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4" "$mod, 5, workspace, 5" "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7" "$mod, 8, workspace, 8" "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1" "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3" "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5" "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7" "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9" "$mod SHIFT, 0, movetoworkspace, 10"

        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "SHIFT, Print, exec, grim - | swappy -f -"
      ];

      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
      ];

      bindl = [
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPlay, exec, playerctl play-pause"
      ];

      windowrulev2 = [
        "float, class:^(pavucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(blueman-manager)$"
        "opacity 0.90 0.85, class:^(kitty)$"
      ];

      exec-once = [ "waybar" "dunst" "hyprpaper" "hypridle" ];
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings.mainBar = {
      layer = "top"; position = "top"; height = 32;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "battery" "tray" ];
      clock = { format = " {:%H:%M}"; };
      battery = { format = "{icon} {capacity}%"; format-icons = [ "" "" "" "" "" ]; };
      network = { format-wifi = " {signalStrength}%"; format-disconnected = "󰤮"; };
      pulseaudio = { format = "{icon} {volume}%"; format-icons = { default = [ "" "" "" ]; }; };
    };
    style = ''
      * { font-family: "JetBrainsMono Nerd Font"; font-size: 13px; }
      window#waybar { background: rgba(30, 30, 46, 0.8); color: #cdd6f4; }
      #workspaces button { padding: 0 8px; color: #cdd6f4; background: transparent; }
      #workspaces button.active { background: #cba6f7; color: #1e1e2e; }
      #clock, #battery, #network, #pulseaudio, #tray {
        padding: 0 10px; margin: 4px 2px; background: #313244; border-radius: 8px;
      }
    '';
  };

  programs.wofi = {
    enable = true;
    settings = { width = 400; height = 300; location = "center"; show = "drun"; };
    style = ''
      window { border: 2px solid #cba6f7; border-radius: 15px; background: rgba(30, 30, 46, 0.9); }
      #input { margin: 5px; border-radius: 10px; color: #cdd6f4; background: #313244; }
      #entry:selected { background: #cba6f7; border-radius: 10px; }
      #entry:selected #text { color: #1e1e2e; }
    '';
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300; height = 100; offset = "10x40"; origin = "top-right";
        frame_color = "#cba6f7"; frame_width = 2; corner_radius = 10;
        font = "JetBrainsMono Nerd Font 10";
      };
      urgency_low = { background = "#1e1e2e"; foreground = "#cdd6f4"; timeout = 5; };
      urgency_normal = { background = "#1e1e2e"; foreground = "#cdd6f4"; timeout = 10; };
      urgency_critical = { background = "#1e1e2e"; foreground = "#f38ba8"; frame_color = "#f38ba8"; };
    };
  };
}

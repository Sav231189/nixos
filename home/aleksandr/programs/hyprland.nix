# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Home Manager: Hyprland (Пользовательская конфигурация)                      ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Личные настройки Hyprland: внешний вид, хоткеи, правила для окон.           ║
# ║                                                                              ║
# ║  ЧТО НАСТРАИВАЕТСЯ:                                                          ║
# ║  • Hyprland    — gaps, borders, blur, анимации, keybindings                  ║
# ║  • Waybar      — статус бар с CPU, RAM, батареей, временем                   ║
# ║  • Wofi        — лаунчер приложений (Super+D)                                ║
# ║  • Dunst       — уведомления с закруглёнными углами                          ║
# ║                                                                              ║
# ║  ТЕМА: Catppuccin Mocha                                                      ║
# ║  • Фиолетовые акценты (#cba6f7)                                              ║
# ║  • Тёмный фон (#1e1e2e)                                                      ║
# ║  • Blur и прозрачность                                                       ║
# ║                                                                              ║
# ║  ОСНОВНЫЕ ХОТКЕИ: см. README.md → Hyprland → Горячие клавиши                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, pkgs, lib, ... }:

{
  # Hyprland config
  wayland.windowManager.hyprland = {
    enable = true;
    
    settings = {
      # === Monitor ===
      # Auto-detect monitor (will be configured based on hardware)
      monitor = ",preferred,auto,1";

      # === General ===
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ee) rgba(89b4faee) 45deg";
        "col.inactive_border" = "rgba(585b70aa)";
        layout = "dwindle";
        allow_tearing = false;
      };

      # === Decoration ===
      decoration = {
        rounding = 10;
        
        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = true;
          xray = true;
        };
        
        # Shadows
        drop_shadow = true;
        shadow_range = 15;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
        
        # Dim inactive
        dim_inactive = true;
        dim_strength = "0.1";
        
        # Active opacity
        active_opacity = 1.0;
        inactive_opacity = 0.9;
      };

      # === Animations ===
      animations = {
        enabled = true;
        
        bezier = [
          "easeOutQuint, 0.22, 1, 0.36, 1"
          "easeInOutCubic, 0.65, 0, 0.35, 1"
          "linear, 0, 0, 1, 1"
          "almostLinear, 0.5, 0.5, 0.75, 1.0"
          "quick, 0.15, 0, 0.1, 1"
        ];
        
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      # === Layout ===
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      master = {
        new_status = "master";
      };

      # === Misc ===
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      # === Input ===
      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle";
        
        follow_mouse = 1;
        sensitivity = 0;
        
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
          drag_lock = true;
          disable_while_typing = true;
        };
      };

      # === Gestures ===
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      # === Variables ===
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$browser" = "firefox";
      "$fileManager" = "nautilus";
      "$menu" = "wofi --show drun";

      # === Keybindings ===
      bind = [
        # Apps
        "$mod, Return, exec, $terminal"
        "$mod, B, exec, $browser"
        "$mod, E, exec, $fileManager"
        "$mod, D, exec, $menu"
        "$mod, V, exec, code"
        
        # Window management
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, F, fullscreen"
        "$mod, Space, togglefloating"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        
        # Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
        
        # Move windows
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"
        
        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        
        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        
        # Scratchpad
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        
        # Scroll workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        
        # Screenshots
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "SHIFT, Print, exec, grim - | swappy -f -"
        
        # Lock
        "$mod, L, exec, hyprlock"
      ];
      
      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      
      # Media keys
      bindel = [
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
      ];
      
      bindl = [
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # === Window Rules ===
      windowrulev2 = [
        # Floating
        "float, class:^(pavucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(blueman-manager)$"
        "float, class:^(org.gnome.Nautilus)$"
        "size 1000 700, class:^(org.gnome.Nautilus)$"
        
        # Opacity
        "opacity 0.90 0.85, class:^(kitty)$"
        "opacity 0.95 0.90, class:^(code)$"
      ];

      # === Autostart ===
      exec-once = [
        "waybar"
        "dunst"
        "hyprpaper"
        "hypridle"
        "[workspace 1 silent] kitty"
      ];
    };
  };

  # Waybar
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;
        
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ 
          "pulseaudio" 
          "network" 
          "cpu" 
          "memory" 
          "temperature"
          "battery" 
          "tray" 
        ];
        
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "0";
          };
        };
        
        clock = {
          format = " {:%H:%M}";
          format-alt = " {:%A, %d %B %Y}";
          tooltip-format = "<tt>{calendar}</tt>";
        };
        
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };
        
        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " {ipaddr}";
          format-disconnected = "󰤮";
          tooltip-format = "{essid} - {ipaddr}";
        };
        
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
        
        cpu = {
          format = " {usage}%";
          interval = 2;
        };
        
        memory = {
          format = " {percentage}%";
          interval = 2;
        };
        
        temperature = {
          format = " {temperatureC}°C";
          critical-threshold = 80;
        };
        
        tray = {
          spacing = 10;
        };
      };
    };
    
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.8);
        color: #cdd6f4;
        border-radius: 0;
      }

      #workspaces button {
        padding: 0 8px;
        color: #cdd6f4;
        background: transparent;
        border: none;
        border-radius: 4px;
      }

      #workspaces button.active {
        background: #cba6f7;
        color: #1e1e2e;
      }

      #workspaces button:hover {
        background: #45475a;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        margin: 4px 2px;
        background: #313244;
        border-radius: 8px;
      }

      #battery.charging, #battery.plugged {
        background: #a6e3a1;
        color: #1e1e2e;
      }

      #battery.critical:not(.charging) {
        background: #f38ba8;
        color: #1e1e2e;
        animation: blink 0.5s linear infinite alternate;
      }

      @keyframes blink {
        to {
          background: #eba0ac;
        }
      }
    '';
  };

  # Wofi (app launcher)
  programs.wofi = {
    enable = true;
    settings = {
      width = 400;
      height = 300;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 32;
    };
    style = ''
      window {
        margin: 0px;
        border: 2px solid #cba6f7;
        border-radius: 15px;
        background-color: rgba(30, 30, 46, 0.9);
      }

      #input {
        margin: 5px;
        border: none;
        border-radius: 10px;
        color: #cdd6f4;
        background-color: #313244;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        color: #cdd6f4;
      }

      #entry:selected {
        background-color: #cba6f7;
        border-radius: 10px;
      }

      #entry:selected #text {
        color: #1e1e2e;
      }
    '';
  };

  # Dunst notifications
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 100;
        offset = "10x40";
        origin = "top-right";
        transparency = 10;
        frame_color = "#cba6f7";
        frame_width = 2;
        corner_radius = 10;
        font = "JetBrainsMono Nerd Font 10";
        padding = 10;
        horizontal_padding = 10;
        icon_position = "left";
        max_icon_size = 48;
      };
      
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 5;
      };
      
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
      };
      
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#f38ba8";
        frame_color = "#f38ba8";
        timeout = 0;
      };
    };
  };
}

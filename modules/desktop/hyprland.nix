# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Модуль: Hyprland (Системная часть)                                          ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Системная настройка Hyprland — тайлового Wayland compositor.                ║
# ║                                                                              ║
# ║  ЧТО НАСТРАИВАЕТСЯ:                                                          ║
# ║  • Hyprland WM — оконный менеджер с анимациями и blur                        ║
# ║  • XDG Portal — интеграция с приложениями (открытие файлов, скриншоты)       ║
# ║  • Wayland переменные — для корректной работы Electron/Qt/GTK                ║
# ║  • Polkit — диалоги аутентификации (запрос пароля sudo)                      ║
# ║  • GNOME Keyring — хранение секретов (паролей, токенов)                      ║
# ║                                                                              ║
# ║  УСТАНОВЛЕННЫЕ ПРОГРАММЫ:                                                    ║
# ║  waybar, wofi, dunst, hyprpaper, hyprlock, grim, slurp, swappy              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, inputs, ... }:

{
  # Enable Hyprland
  # Official wiki: https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # Make sure portal package is in sync with Hyprland
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  # XDG Portal for Wayland
  # NOTE: xdg-desktop-portal-hyprland is added automatically by Hyprland flake
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Environment variables for Wayland
  environment.sessionVariables = {
    # Wayland
    NIXOS_OZONE_WL = "1";  # Electron apps on Wayland
    MOZ_ENABLE_WAYLAND = "1";  # Firefox on Wayland
    
    # Qt
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    
    # SDL
    SDL_VIDEODRIVER = "wayland";
    
    # Clutter
    CLUTTER_BACKEND = "wayland";
    
    # GDK
    GDK_BACKEND = "wayland,x11";
    
    # XDG
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  # Essential Hyprland packages
  environment.systemPackages = with pkgs; [
    # Core
    waybar              # Status bar
    wofi                # App launcher
    dunst               # Notifications
    
    # Screen
    hyprpaper           # Wallpaper
    hyprlock            # Lock screen
    hypridle            # Idle daemon
    wlogout             # Logout menu
    
    # Screenshots
    grim                # Screenshot tool
    slurp               # Region selector
    swappy              # Screenshot editor
    
    # Clipboard
    wl-clipboard        # Clipboard utilities
    cliphist            # Clipboard history
    
    # Utils
    brightnessctl       # Brightness control
    playerctl           # Media controls
    pamixer             # Volume control
    
    # File manager
    nautilus            # GUI file manager
    
    # Polkit
    polkit_gnome        # Authentication dialogs
  ];

  # Security - Polkit for authentication dialogs
  security.polkit.enable = true;
  
  # Start polkit agent with Hyprland
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Enable dconf for GTK settings
  programs.dconf.enable = true;

  # GNOME keyring for secrets
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # Auto-login to Hyprland with greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
      # Auto-login for aleksandr
      initial_session = {
        command = "Hyprland";
        user = "aleksandr";
      };
    };
  };

  # Prevent getty on tty1 (greetd uses it)
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}

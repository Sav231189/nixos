# ============================================================================== #
#                                                                                #
#   Apps — Пользовательские графические приложения                               #
#                                                                                #
# ============================================================================== #
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # ── Браузеры ─────────────────────────────────────────────────────────────
    firefox
    chromium

    # ── Мессенджеры ──────────────────────────────────────────────────────────
    telegram-desktop

    # ── IDE и Разработка ─────────────────────────────────────────────────────
    antigravity-fhs
    zed-editor            # Zed — современный редактор кода

    # ── Системные иконки ─────────────────────────────────────────────────────
    networkmanagerapplet  # nm-applet (VPN/WiFi в трее)
  ];

  # ── Скрытие системных приложений из лаунчера ────────────────────────────────
  # nm-applet работает в трее, не нужен в меню приложений
  xdg.desktopEntries = {
    "nm-connection-editor" = {
      name = "Advanced Network Configuration";
      icon = "preferences-system-network";
      exec = "nm-connection-editor";
      terminal = false;
      categories = [ "Settings" "Network" ];
      noDisplay = true;
    };
    "nm-applet" = {
      name = "Network (nm-applet)";
      icon = "nm-device-wireless";
      exec = "nm-applet";
      terminal = false;
      categories = [ "Network" ];
      noDisplay = true;
    };

    # ── Скрытие консольных приложений (не имеют GUI) ─────────────────────────
    "htop" = {
      name = "Htop";
      icon = "htop";
      exec = "htop";
      terminal = true;
      categories = [ "System" "Monitor" ];
      noDisplay = true;
    };
    "btop" = {
      name = "btop++";
      icon = "btop";
      exec = "btop";
      terminal = true;
      categories = [ "System" "Monitor" ];
      noDisplay = true;
    };
    "yazi" = {
      name = "Yazi";
      icon = "yazi";
      exec = "yazi";
      terminal = true;
      categories = [ "System" "FileManager" ];
      noDisplay = true;
    };
    "nixos-manual" = {
      name = "NixOS Manual";
      icon = "nix-snowflake";
      exec = "nixos-help";
      terminal = false;
      categories = [ "Documentation" ];
      noDisplay = true;
    };
    "blueman-manager" = {
      name = "Bluetooth Manager";
      icon = "blueman";
      exec = "blueman-manager";
      terminal = false;
      categories = [ "Settings" "HardwareSettings" ];
      noDisplay = true;
    };
    
    # ── Кастомные иконки ────────────────────────────────────────────────────────
    "firefox" = {
      name = "Firefox";
      comment = "Browse the Web";
      icon = "/home/alxr/nixos/icons/firefox.png";
      exec = "firefox %u";
      terminal = false;
      categories = [ "Network" "WebBrowser" ];
      mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "application/vnd.mozilla.xul+xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
    };
  };
}

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Home Manager: Главный файл пользователя                                     ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Home Manager позволяет декларативно управлять пользовательским окружением.  ║
# ║                                                                              ║
# ║  ЧТО НАСТРАИВАЕТСЯ:                                                          ║
# ║  • XDG директории — ~/Documents, ~/Downloads, ~/Pictures и т.д.              ║
# ║  • GTK/Qt темы — Adwaita Dark, Papirus иконки                                ║
# ║  • Курсор — Adwaita                                                          ║
# ║  • Переменные окружения — EDITOR, BROWSER, TERMINAL                          ║
# ║                                                                              ║
# ║  ИМПОРТИРУЕМЫЕ МОДУЛИ:                                                       ║
# ║  • shell.nix     — Zsh, Starship, fzf, zoxide                                ║
# ║  • terminal.nix  — Kitty терминал                                            ║
# ║  • hyprland.nix  — Конфигурация Hyprland, Waybar, Wofi                       ║
# ║  • git.nix       — Git, lazygit, GitHub CLI                                  ║
# ║  • utilities.nix — CLI утилиты (bat, eza, fd, ripgrep...)                    ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./programs/shell.nix
    ./programs/terminal.nix
    ./programs/hyprland.nix
    ./programs/git.nix
    ./programs/utilities.nix
  ];

  # Home Manager version
  home.stateVersion = "24.11";

  # User info
  home.username = "aleksandr";
  home.homeDirectory = "/home/aleksandr";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Session variables
  home.sessionVariables = {
    EDITOR = "code --wait";
    VISUAL = "code --wait";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  # XDG directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  # GTK theme
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      size = 24;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Qt theme
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # Cursor
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };
}

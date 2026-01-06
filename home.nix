# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Home Manager — Конфигурация пользователя alxr                               ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║                                                                              ║
# ║  Home Manager управляет пользовательским окружением:                         ║
# ║  программы, темы, dotfiles, переменные окружения.                            ║
# ║                                                                              ║
# ║  СТРУКТУРА:                                                                  ║
# ║  ─────────────────────────────────────────────────────────────────────────── ║
# ║  1. Imports   — configs/shell, terminal, hypr, dev, theme                    ║
# ║  2. User      — username, homeDirectory, stateVersion                        ║
# ║  3. Variables — EDITOR, BROWSER, TERMINAL                                    ║
# ║  4. XDG       — стандартные папки (desktop, documents, downloads, media)     ║
# ║                                                                              ║
# ║  КОНФИГИ:                                                                    ║
# ║  ─────────────────────────────────────────────────────────────────────────── ║
# ║  shell/     — Zsh, Starship, fzf, zoxide, алиасы                             ║
# ║  terminal/  — Kitty + Alacritty                                              ║
# ║  hypr/      — Hyprland config, Waybar, Wofi, Dunst                           ║
# ║  dev/       — Git, браузеры, CLI утилиты (ripgrep, fd, bat, eza)             ║
# ║  theme/     — GTK/Qt темы, курсор                                            ║
# ║                                                                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./configs/shell
    ./configs/terminal
    ./configs/hypr
    ./configs/dev
    ./configs/theme
  ];

  home.username = "alxr";
  home.homeDirectory = "/home/alxr";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "nano";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/media";
      pictures = "${config.home.homeDirectory}/media";
      videos = "${config.home.homeDirectory}/media";
    };
  };
}

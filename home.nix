# ============================================================================== #
#                                                                                #
#   ██╗  ██╗ ██████╗ ███╗   ███╗███████╗                                         #
#   ██║  ██║██╔═══██╗████╗ ████║██╔════╝                                         #
#   ███████║██║   ██║██╔████╔██║█████╗                                           #
#   ██╔══██║██║   ██║██║╚██╔╝██║██╔══╝                                           #
#   ██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗                                         #
#   ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝                                         #
#                                                                                #
#   home.nix — Конфигурация пользователя (Home Manager)                          #
#   User: alxr                                                                   #
#                                                                                #
# ============================================================================== #
#
#   ЧТО ЭТО?
#   ─────────────────────────────────────────────────────────────────────────────
#   Home Manager управляет ПОЛЬЗОВАТЕЛЬСКИМ окружением:
#   • Dotfiles — конфиги программ (~/.config/*)
#   • Темы — GTK, Qt, курсоры, иконки
#   • Shell — Zsh, алиасы, промпт
#   • Программы — пользовательские приложения
#
#   Системные настройки (boot, services) — в configuration.nix
#   Этот файл (home.nix) — для пользовательских настроек
#
# ============================================================================== #
{ config, pkgs, lib, inputs, ... }:

let
  # ── Dotfiles — симлинки в ~/.config/ (LIVE RELOAD) ─────────────────────────
  # Репозиторий должен быть склонирован в ~/nixos/
  dotfilesPath = "${config.home.homeDirectory}/nixos/dotfiles";
  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Конфиги через симлинки (live reload без rebuild)
  dotfiles = {
    hypr = "hypr";       # Hyprland
    kitty = "kitty";     # Терминал
    neofetch = "neofetch"; # Инфо о системе
    quickshell = "quickshell"; # Quickshell конфиги
    niri = "niri";       # Niri конфиг
  };

in
{
  # ══════════════════════════════════════════════════════════════════════════════
  # IMPORTS — Home Manager модули
  # ══════════════════════════════════════════════════════════════════════════════
  imports = [
    ./modules/shell.nix      # Zsh, Starship prompt, fzf, zoxide, алиасы
    ./modules/dev.nix        # CLI утилиты
    ./modules/theme.nix      # GTK/Qt темы
    ./modules/apps.nix       # GUI приложения (Telegram, браузеры)
    inputs.noctalia.homeModules.default # Noctalia Shell
  ];

  # Enable import Noctalia Shell
  programs.noctalia-shell.enable = true;

  # Enable import Home Manager
  programs.home-manager.enable = true;

  # ══════════════════════════════════════════════════════════════════════════════
  # USER — Настройки пользователя
  # ══════════════════════════════════════════════════════════════════════════════
  home.username = "alxr";
  home.homeDirectory = "/home/alxr";
  home.stateVersion = "25.05";

  # ══════════════════════════════════════════════════════════════════════════════
  # ENVIRONMENT — Переменные окружения
  # ══════════════════════════════════════════════════════════════════════════════
  home.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "nano";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # DOTFILES — Симлинки (для live reload)
  # ══════════════════════════════════════════════════════════════════════════════
  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = mkSymlink "${dotfilesPath}/${subpath}";
      recursive = true;
    })
    dotfiles;

  # ══════════════════════════════════════════════════════════════════════════════
  # XDG — Стандартные директории
  # ══════════════════════════════════════════════════════════════════════════════
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
      # Отключаем лишние папки (указываем на home чтобы не создавались отдельно)
      publicShare = "${config.home.homeDirectory}";
      templates = "${config.home.homeDirectory}";
    };
  };

  # Удаляем папки Public и Templates, если они указывают на домашнюю директорию
  home.activation.removeXdgDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    rm -rf ${config.home.homeDirectory}/Public
    rm -rf ${config.home.homeDirectory}/Templates
    rm -rf ${config.home.homeDirectory}/Pictures
  '';
}

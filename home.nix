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
  # ── Dotfiles — симлинки в ~/.config/ ───────────────────────────────────────
  # Путь к dotfiles (относительно домашней директории)
  dotfilesPath = "${config.home.homeDirectory}/nixos/dotfiles";

  # Функция для создания симлинка вне Nix store (live reload!)
  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Список конфигов для симлинка
  # Добавить новый: просто добавь строку "имя_программы" = "имя_папки";
  dotfiles = {
    hypr = "hypr";           # Hyprland
    waybar = "waybar";       # Панель
    kitty = "kitty";         # Терминал
    wofi = "wofi";           # Лаунчер
    dunst = "dunst";         # Уведомления
  };

in
{
  # ══════════════════════════════════════════════════════════════════════════════
  # IMPORTS — Home Manager модули
  # ══════════════════════════════════════════════════════════════════════════════
  # Закомментируй строку чтобы отключить модуль
  imports = [
    ./modules/shell.nix      # Zsh, Starship prompt, fzf, zoxide, алиасы
    ./modules/dev.nix        # Git, браузеры, CLI утилиты (ripgrep, fd, bat, eza)
    ./modules/theme.nix      # GTK/Qt темы, Papirus иконки, курсор
  ];

  # ══════════════════════════════════════════════════════════════════════════════
  # USER — Настройки пользователя
  # ══════════════════════════════════════════════════════════════════════════════
  home.username = "alxr";               # Имя пользователя
  home.homeDirectory = "/home/alxr";    # Домашняя директория
  home.stateVersion = "25.05";          # НЕ МЕНЯТЬ! Версия при установке

  programs.home-manager.enable = true;  # Разрешить Home Manager управлять собой

  # ══════════════════════════════════════════════════════════════════════════════
  # ENVIRONMENT — Переменные окружения
  # ══════════════════════════════════════════════════════════════════════════════
  home.sessionVariables = {
    EDITOR = "nano";      # Редактор по умолчанию (для git commit, etc)
    VISUAL = "nano";      # Визуальный редактор
    BROWSER = "firefox";  # Браузер по умолчанию
    TERMINAL = "kitty";   # Терминал (используется в Hyprland биндах)
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # DOTFILES — Симлинки на dotfiles/ (LIVE RELOAD!)
  # ══════════════════════════════════════════════════════════════════════════════
  # Создаёт симлинки: dotfiles/hypr/ → ~/.config/hypr/
  # Изменения применяются мгновенно без rebuild!
  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = mkSymlink "${dotfilesPath}/${subpath}";
      recursive = true;
    })
    dotfiles;

  # ══════════════════════════════════════════════════════════════════════════════
  # XDG — Стандартные пользовательские директории
  # ══════════════════════════════════════════════════════════════════════════════
  # Создаёт и настраивает ~/desktop, ~/documents, ~/downloads, ~/media
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;  # Автосоздание папок при первом запуске

      # Кастомные пути (все lowercase, media объединяет музыку/фото/видео)
      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/media";
      pictures = "${config.home.homeDirectory}/media";
      videos = "${config.home.homeDirectory}/media";
    };
  };
}

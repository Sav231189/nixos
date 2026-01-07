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
    waybar = "waybar";   # Панель
  };

in
{
  # ══════════════════════════════════════════════════════════════════════════════
  # IMPORTS — Home Manager модули
  # ══════════════════════════════════════════════════════════════════════════════
  imports = [
    ./modules/shell.nix      # Zsh, Starship prompt, fzf, zoxide, алиасы
    ./modules/dev.nix        # Git, браузеры, CLI утилиты
    ./modules/theme.nix      # GTK/Qt темы
  ];

  # ══════════════════════════════════════════════════════════════════════════════
  # USER — Настройки пользователя
  # ══════════════════════════════════════════════════════════════════════════════
  home.username = "alxr";
  home.homeDirectory = "/home/alxr";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

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
  # DOTFILES — Симлинки (только hypr и kitty для live reload)
  # ══════════════════════════════════════════════════════════════════════════════
  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = mkSymlink "${dotfilesPath}/${subpath}";
      recursive = true;
    })
    dotfiles;

  # Hyprland включён системно в configuration.nix (programs.hyprland.enable)
  # Конфиг берётся из симлинка dotfiles/hypr/ → ~/.config/hypr/
  # Waybar — конфиг через dotfiles/waybar/ (live reload)

  # ══════════════════════════════════════════════════════════════════════════════
  # WOFI — Лаунчер
  # ══════════════════════════════════════════════════════════════════════════════
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

  # ══════════════════════════════════════════════════════════════════════════════
  # DUNST — Уведомления
  # ══════════════════════════════════════════════════════════════════════════════
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
      publicShare = null;
      templates = null;
    };
  };
}

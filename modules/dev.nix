# ============================================================================== #
#                                                                                #
#   Dev — Разработка и CLI утилиты                                               #
#                                                                                #
# ============================================================================== #
#
#   ЧТО ЭТО?
#   ─────────────────────────────────────────────────────────────────────────────
#   Инструменты для разработки и современные CLI утилиты.
#
#   GIT:
#   • git — система контроля версий
#   • lazygit — TUI для git (команда: lg)
#   • delta — красивые diff'ы
#   • gh — GitHub CLI
#
#   CLI УТИЛИТЫ (замена стандартных):
#   • ripgrep (rg) — замена grep, в 10x быстрее
#   • fd — замена find, проще синтаксис
#   • bat — замена cat, с подсветкой синтаксиса
#   • eza — замена ls, с иконками и цветами
#   • btop — замена top, красивый мониторинг
#   • yazi — файловый менеджер в терминале
#
#
#
# ============================================================================== #
{ config, pkgs, lib, ... }:

{
  # ══════════════════════════════════════════════════════════════════════════════
  # GIT — Система контроля версий
  # ══════════════════════════════════════════════════════════════════════════════
  programs.git = {
    enable = true;  # Отключить: enable = false

    settings = {
      # ── Пользователь ───────────────────────────────────────────────────────
      user.name = "Aleksandr";
      user.email = "sav231189@gmail.com";

      # ── Поведение ──────────────────────────────────────────────────────────
      init.defaultBranch = "main";       # Ветка по умолчанию (не master)
      pull.rebase = true;                # При pull делать rebase вместо merge
      push.autoSetupRemote = true;       # Автоматически создавать upstream

      # ── Редактор ───────────────────────────────────────────────────────────
      core = {
        editor = "nano";                 # Редактор для commit сообщений
        autocrlf = "input";              # Конвертация переносов строк
      };

      # ── Merge и Rebase ─────────────────────────────────────────────────────
      merge.conflictstyle = "diff3";     # Показывать оригинал при конфликтах
      rebase.autoStash = true;           # Автоматически stash перед rebase

      # ── Алиасы (сокращения) ────────────────────────────────────────────────
      alias = {
        st = "status";                   # git st
        co = "checkout";                 # git co branch
        br = "branch";                   # git br
        ci = "commit";                   # git ci
        lg = "log --oneline --graph --decorate --all";  # git lg — красивый лог
        aa = "add --all";                # git aa — добавить всё
        cm = "commit -m";                # git cm "message"
        amend = "commit --amend --no-edit";  # git amend — дополнить последний коммит
      };
    };

    # ── Глобальный .gitignore ────────────────────────────────────────────────
    ignores = [
      # macOS / Windows
      ".DS_Store" "Thumbs.db"

      # IDE
      ".idea/" ".vscode/" "*.swp"

      # Node.js
      "node_modules/" "dist/" "build/" 

      # Секреты
      ".env" ".env.local"

      # Nix
      "result" "result-*"
    ];
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # LAZYGIT — TUI для Git (https://github.com/jesseduffield/lazygit)
  # ══════════════════════════════════════════════════════════════════════════════
  # Запуск: lg (алиас в shell)
  # Интерфейс для работы с git в терминале
  programs.lazygit = {
    enable = true;  # Отключить: enable = false
    settings = {
      gui = {
        showFileTree = true;       # Показывать дерево файлов
        showRandomTip = false;     # Не показывать советы
      };
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never";  # Использовать delta для diff
      };
    };
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # GITHUB CLI — Работа с GitHub из терминала
  # ══════════════════════════════════════════════════════════════════════════════
  # Команды: gh pr create, gh issue list, gh repo clone
  programs.gh = {
    enable = true;  # Отключить: enable = false
    settings = {
      git_protocol = "ssh";        # Использовать SSH вместо HTTPS
      prompt = "enabled";          # Интерактивные подсказки
    };
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # DELTA — Красивые diff'ы
  # ══════════════════════════════════════════════════════════════════════════════
  # Автоматически используется git для вывода diff
  programs.delta = {
    enable = true;  # Отключить: enable = false
    enableGitIntegration = true;
    options = {
      navigate = true;             # n/N для навигации по diff
      light = false;               # Тёмная тема
      side-by-side = true;        # Два столбца (old | new)
      line-numbers = true;         # Номера строк
    };
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # PACKAGES — CLI утилиты и инструменты разработки
  # Терминалы и браузеры — в home.nix
  # ══════════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # ── Node.js ──────────────────────────────────────────────────────────────
    nodejs_22                      # Node.js v22 LTS
    bun                            # Быстрый JS runtime

    # ── Файловый менеджер ────────────────────────────────────────────────────
    yazi                           # TUI файловый менеджер (команда: yazi)

    # ── CLI утилиты (современные замены) ─────────────────────────────────────
    ripgrep                        # rg — замена grep
    fd                             # fd — замена find
    bat                            # bat — замена cat
    eza                            # eza — замена ls
    fzf                            # fzf — fuzzy поиск
    jq                             # jq — работа с JSON
    yq                             # yq — работа с YAML
    nix-search-tv                  # Поисковик пакетов Nix
    
    # Скрипт ns для удобного поиска с хоткеями (как на сайте)
    (writeShellScriptBin "ns" ''
      ${nix-search-tv}/bin/nix-search-tv print | ${fzf}/bin/fzf \
        --preview '${nix-search-tv}/bin/nix-search-tv preview {}' \
        --scheme history \
        --bind 'ctrl-o:execute(xdg-open "https://search.nixos.org/packages?channel=unstable&query=$(echo {} | sed "s|^[^/]*/||" | awk "{print \$1}")")' \
        --bind 'ctrl-s:execute(xdg-open "https://github.com/search?q=repo%3ANixOS%2Fnixpkgs+$(echo {} | sed "s|^[^/]*/||" | awk "{print \$1}")&type=code")' \
        --bind 'ctrl-i:execute(${pkgs.kitty}/bin/kitty -e nix shell nixpkgs#$(echo {} | sed "s|^[^/]*/||" | awk "{print \$1}"))' \
        --header 'Ctrl-o: web | Ctrl-s: github | Ctrl-i: shell | Enter: copy' \
        --bind 'enter:execute(echo {} | sed "s|^[^/]*/||" | awk "{print \$1}" | ${pkgs.wl-clipboard}/bin/wl-copy)+abort'
    '')

    # ── Мониторинг системы ───────────────────────────────────────────────────
    htop                           # htop — просмотр процессов
    btop                           # btop — красивый мониторинг
    duf                            # duf — замена df (диски)
    dust                           # dust — замена du (размер папок)

    # ── Полезные утилиты ─────────────────────────────────────────────────────
    tldr                           # tldr — короткая справка по командам
    curl                           # curl — HTTP запросы
    wget                           # wget — скачивание файлов
    httpie                         # http — удобные HTTP запросы

    # ── Архивы ───────────────────────────────────────────────────────────────
    unzip                          # unzip — распаковка .zip
    zip                            # zip — создание .zip
    p7zip                          # 7z — работа с 7z архивами

    # ── Разное ───────────────────────────────────────────────────────────────
    tree                           # tree — дерево директорий
    tokei                          # tokei — статистика кода
    hyperfine                      # hyperfine — бенчмарки команд
    neofetch                       # neofetch — информация о системе
    wl-clipboard                   # wl-copy/wl-paste — буфер обмена Wayland
  ];

  # ══════════════════════════════════════════════════════════════════════════════
  # BAT — Замена cat с подсветкой синтаксиса
  # ══════════════════════════════════════════════════════════════════════════════
  programs.bat = {
    enable = true;  # Отключить: enable = false
    config = {
      theme = "base16";            # Тема подсветки
      pager = "less -FR";          # Пейджер для длинных файлов
    };
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # EZA — Замена ls с иконками и дополнительной информацией
  # ══════════════════════════════════════════════════════════════════════════════
  programs.eza = {
    enable = true;  # Отключить: enable = false
    enableZshIntegration = true;
    icons = "auto";                     # Иконки для типов файлов
    git = true;                         # Показывать git статус
    extraOptions = [ "--group-directories-first" ];  # Папки сначала
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # YAZI — Файловый менеджер в терминале
  # ══════════════════════════════════════════════════════════════════════════════
  # Запуск: yazi
  # Навигация: hjkl или стрелки, Enter — открыть, q — выйти
  programs.yazi = {
    enable = true;  # Отключить: enable = false
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden = false;       # Не показывать скрытые файлы по умолчанию
        sort_by = "natural";       # Естественная сортировка (1, 2, 10)
        sort_dir_first = true;     # Папки сначала
      };
    };
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # BTOP — Красивый мониторинг системы
  # ══════════════════════════════════════════════════════════════════════════════
  # Запуск: btop или top (алиас)
  programs.btop = {
    enable = true;  # Отключить: enable = false
    settings = {
      color_theme = "catppuccin_mocha";  # Тема
      theme_background = false;          # Прозрачный фон
      vim_keys = true;                   # hjkl навигация
    };
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # DIRENV — Автоматическая загрузка окружения
  # ══════════════════════════════════════════════════════════════════════════════
  # Нужен для автоматической активации dev shells (nix develop) при входе в папку
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}

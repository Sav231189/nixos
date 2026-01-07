# ============================================================================== #
#                                                                                #
#   Shell — Zsh + Starship + утилиты                                             #
#                                                                                #
# ============================================================================== #
#
#   ЧТО ЭТО?
#   ─────────────────────────────────────────────────────────────────────────────
#   Настройка командной оболочки Zsh с плагинами и утилитами:
#   • Zsh — современная оболочка с автодополнением
#   • Starship — красивый и быстрый промпт
#   • fzf — fuzzy поиск (Ctrl+R)
#   • zoxide — умный cd (запоминает частые директории)
#
#   ХОТКЕИ:
#   ─────────────────────────────────────────────────────────────────────────────
#   Ctrl+R       Поиск по истории (fzf)
#   Ctrl+Space   Принять подсказку (autosuggestion)
#   Ctrl+E       Редактировать команду в $EDITOR
#   ESC ESC      Добавить sudo к команде (oh-my-zsh sudo plugin)
#
# ============================================================================== #
{ config, pkgs, lib, ... }:

{
  # ══════════════════════════════════════════════════════════════════════════════
  # ZSH — Командная оболочка
  # ══════════════════════════════════════════════════════════════════════════════
  programs.zsh = {
    enable = true;  # Отключить: enable = false

    # ── История команд ───────────────────────────────────────────────────────
    history = {
      size = 50000;                                    # Сколько команд хранить в памяти
      save = 50000;                                    # Сколько команд сохранять в файл
      path = "${config.xdg.dataHome}/zsh/history";    # Путь к файлу истории
      ignoreDups = true;                               # Не сохранять подряд идущие дубли
      ignoreAllDups = true;                            # Удалять старые дубли
      ignoreSpace = true;                              # Команды с пробелом в начале не сохраняются
      share = true;                                    # Общая история между терминалами
    };

    # ── Автодополнение ───────────────────────────────────────────────────────
    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit
      compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Регистронезависимо
      zstyle ':completion:*' menu select                       # Меню выбора
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}  # Цвета как в ls
    '';

    # ── Подсветка синтаксиса ─────────────────────────────────────────────────
    # Подсвечивает команды прямо при вводе (зелёный = существует, красный = ошибка)
    syntaxHighlighting = {
      enable = true;  # Отключить: enable = false
      highlighters = [ "main" "brackets" "pattern" "cursor" ];
      styles = {
        "command" = "fg=green,bold";       # Существующие команды — зелёные
        "alias" = "fg=green,bold";         # Алиасы — зелёные
        "builtin" = "fg=green,bold";       # Встроенные команды — зелёные
        "unknown-token" = "fg=red,bold";   # Неизвестные — красные
        "path" = "fg=cyan,underline";      # Пути — голубые подчёркнутые
      };
    };

    # ── Автоподсказки ────────────────────────────────────────────────────────
    # Серый текст справа от курсора — подсказка из истории
    # Нажми Ctrl+Space чтобы принять
    autosuggestion = {
      enable = true;  # Отключить: enable = false
      strategy = [ "history" "completion" ];  # Сначала из истории, потом автодополнение
    };

    # ── Oh-My-Zsh плагины ────────────────────────────────────────────────────
    oh-my-zsh = {
      enable = true;  # Отключить: enable = false
      plugins = [
        "git"      # Алиасы для git (gst, gco, gp, и т.д.)
        "docker"   # Автодополнение docker команд
        "kubectl"  # Автодополнение kubectl команд
        "sudo"     # ESC ESC — добавляет sudo к команде
      ];
    };

    # ── Алиасы ───────────────────────────────────────────────────────────────
    shellAliases = {
      # Замена стандартных утилит на современные
      ls = "eza --icons --group-directories-first";    # ls с иконками
      ll = "eza -la --icons --group-directories-first"; # ls -la с иконками
      la = "eza -a --icons --group-directories-first"; # ls -a с иконками
      lt = "eza --tree --icons --level=2";             # Дерево директорий
      cat = "bat";                                      # cat с подсветкой синтаксиса
      grep = "rg";                                      # grep, но быстрее (ripgrep)
      find = "fd";                                      # find, но проще синтаксис
      du = "dust";                                      # du, но красивее
      df = "duf";                                       # df, но красивее
      top = "btop";                                     # top, но красивее

      # Git сокращения
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      lg = "lazygit";                                   # TUI для git

      # NixOS команды
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#matebook";
      update = "nix flake update /etc/nixos";
      clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

      # Навигация
      ".." = "cd ..";

      # Безопасность (спрашивает подтверждение)
      rm = "rm -i";
      mv = "mv -i";
      cp = "cp -i";

      # Sudo с сохранением окружения
      sudoi = "sudo -E -s";  # Сохраняет Zsh, Starship, алиасы
    };

    # ── Хоткеи ───────────────────────────────────────────────────────────────
    initContent = ''
      bindkey -v                                         # Vim режим
      bindkey '^R' history-incremental-search-backward   # Ctrl+R — поиск истории
      bindkey '^ ' autosuggest-accept                    # Ctrl+Space — принять подсказку
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey '^E' edit-command-line                     # Ctrl+E — редактировать в $EDITOR
    '';

    # ── Автозапуск Hyprland ──────────────────────────────────────────────────
    # Запускает Hyprland автоматически на tty1 (после логина)
    profileExtra = ''
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec Hyprland
      fi
    '';
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # STARSHIP — Промпт (то что показывается перед командой)
  # ══════════════════════════════════════════════════════════════════════════════
  # Показывает: директорию, git branch, статус, языки программирования
  programs.starship = {
    enable = true;  # Отключить: enable = false
    settings = {
      # Формат промпта (что показывать и в каком порядке)
      format = lib.concatStrings [
        "$username" "$hostname" "$directory"
        "$git_branch" "$git_status"
        "$nodejs" "$rust" "$golang" "$python"
        "$nix_shell" "$cmd_duration"
        "$line_break" "$character"
      ];

      # Символ перед вводом команды
      character = {
        success_symbol = "[❯](bold green)";     # Зелёный если предыдущая команда успешна
        error_symbol = "[❯](bold red)";         # Красный если ошибка
        vimcmd_symbol = "[❮](bold green)";      # В vim normal mode
      };

      directory = { truncation_length = 3; style = "bold cyan"; };
      git_branch = { symbol = " "; style = "bold purple"; };
      nix_shell = { symbol = " "; style = "bold blue"; };
    };
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # ZOXIDE — Умный cd
  # ══════════════════════════════════════════════════════════════════════════════
  # Запоминает директории куда вы ходите и позволяет прыгать по частичному имени
  # Пример: cd proj → переходит в ~/projects если вы туда часто ходите
  programs.zoxide = {
    enable = true;              # Отключить: enable = false
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ]; # Заменяет стандартный cd
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # FZF — Fuzzy поиск
  # ══════════════════════════════════════════════════════════════════════════════
  # Ctrl+R — поиск по истории с fuzzy matching
  # Ctrl+T — поиск файлов
  programs.fzf = {
    enable = true;              # Отключить: enable = false
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [ "--height 40%" "--layout=reverse" "--border" ];

    # Цвета (Catppuccin Mocha)
    colors = {
      bg = "#1e1e2e"; "bg+" = "#313244";
      fg = "#cdd6f4"; "fg+" = "#cdd6f4";
      hl = "#f38ba8"; "hl+" = "#f38ba8";
      info = "#cba6f7"; prompt = "#cba6f7";
      pointer = "#f5e0dc"; marker = "#f5e0dc";
    };
  };
}

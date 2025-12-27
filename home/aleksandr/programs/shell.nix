# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Home Manager: Shell (Zsh + Плагины)                                         ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Настройка командной оболочки Zsh с современными плагинами.                  ║
# ║                                                                              ║
# ║  УСТАНОВЛЕННЫЕ ПЛАГИНЫ:                                                      ║
# ║  • zsh-autosuggestions   — подсказки из истории (серым текстом)              ║
# ║  • zsh-syntax-highlighting — подсветка команд (зелёный/красный)              ║
# ║  • zsh-completions       — расширенное автодополнение                        ║
# ║  • fzf                   — fuzzy поиск (Ctrl+R для истории)                  ║
# ║  • zoxide                — умный cd (запоминает частые директории)           ║
# ║  • Starship              — красивый минималистичный prompt                   ║
# ║                                                                              ║
# ║  ПОЛЕЗНЫЕ ХОТКЕИ:                                                            ║
# ║  Ctrl+R      — поиск по истории через fzf                                    ║
# ║  Ctrl+Space  — принять autosuggestion                                        ║
# ║  Tab         — автодополнение                                                ║
# ║  ESC ESC     — добавить sudo к команде                                       ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    
    # History
    history = {
      size = 50000;
      save = 50000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };

    # Completion
    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit
      compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
      
      # Case-insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      
      # Menu selection
      zstyle ':completion:*' menu select
      
      # Colors in completion
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
    '';

    # Syntax highlighting 🔥
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "pattern" "cursor" ];
      styles = {
        "command" = "fg=green,bold";
        "alias" = "fg=green,bold";
        "builtin" = "fg=green,bold";
        "unknown-token" = "fg=red,bold";
        "path" = "fg=cyan,underline";
      };
    };

    # Autosuggestions 🔥
    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };

    # Oh My Zsh plugins (optional, using only for plugins)
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "kubectl"
        "sudo"    # Press ESC twice to add sudo
      ];
    };

    # Shell aliases
    shellAliases = {
      # Modern replacements
      ls = "eza --icons --group-directories-first";
      ll = "eza -la --icons --group-directories-first";
      la = "eza -a --icons --group-directories-first";
      lt = "eza --tree --icons --level=2";
      cat = "bat";
      grep = "rg";
      find = "fd";
      du = "dust";
      df = "duf";
      top = "btop";
      
      # Git
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      lg = "lazygit";
      
      # NixOS
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#matebook";
      update = "nix flake update /etc/nixos";
      clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      
      # Directories
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      
      # Safety
      rm = "rm -i";
      mv = "mv -i";
      cp = "cp -i";
    };

    # Init content (runs after plugins) - replaces deprecated initExtra
    initContent = ''
      # Vi mode
      bindkey -v
      
      # Better history search
      bindkey '^R' history-incremental-search-backward
      bindkey '^S' history-incremental-search-forward
      
      # Accept autosuggestion with Ctrl+Space
      bindkey '^ ' autosuggest-accept
      
      # Edit command in editor
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey '^E' edit-command-line
    '';
  };

  # Starship prompt 🚀
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$nodejs"
        "$rust"
        "$golang"
        "$python"
        "$docker_context"
        "$kubernetes"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
      
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };
      
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };
      
      git_branch = {
        symbol = " ";
        style = "bold purple";
      };
      
      git_status = {
        style = "bold yellow";
      };
      
      nodejs = {
        symbol = " ";
        style = "bold green";
      };
      
      rust = {
        symbol = " ";
        style = "bold red";
      };
      
      golang = {
        symbol = " ";
        style = "bold cyan";
      };
      
      python = {
        symbol = " ";
        style = "bold yellow";
      };
      
      docker_context = {
        symbol = " ";
        style = "bold blue";
      };
      
      kubernetes = {
        disabled = false;
        symbol = "☸ ";
        style = "bold blue";
      };
      
      nix_shell = {
        symbol = " ";
        style = "bold blue";
      };
      
      cmd_duration = {
        min_time = 2000;
        style = "bold yellow";
      };
    };
  };

  # Zoxide (smart cd) 🔥
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ];  # Replace cd with zoxide
  };

  # FZF (fuzzy finder) 🔥
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
    ];
    colors = {
      bg = "#1e1e2e";
      "bg+" = "#313244";
      fg = "#cdd6f4";
      "fg+" = "#cdd6f4";
      hl = "#f38ba8";
      "hl+" = "#f38ba8";
      info = "#cba6f7";
      prompt = "#cba6f7";
      pointer = "#f5e0dc";
      marker = "#f5e0dc";
      spinner = "#f5e0dc";
      header = "#f38ba8";
    };
  };
}

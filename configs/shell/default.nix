# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Shell — Zsh + Starship                                                      ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║                                                                              ║
# ║  Командная оболочка Zsh с плагинами:                                         ║
# ║  • zsh-autosuggestions   — подсказки из истории                              ║
# ║  • zsh-syntax-highlighting — подсветка команд                                ║
# ║  • fzf                   — fuzzy поиск (Ctrl+R)                              ║
# ║  • zoxide                — умный cd                                          ║
# ║  • Starship              — минималистичный prompt                            ║
# ║                                                                              ║
# ║  ХОТКЕИ:                                                                     ║
# ║  Ctrl+R      — поиск по истории                                              ║
# ║  Ctrl+Space  — принять autosuggestion                                        ║
# ║  ESC ESC     — добавить sudo                                                 ║
# ║                                                                              ║
# ║  АЛИАСЫ:                                                                     ║
# ║  rebuild    — пересобрать NixOS                                              ║
# ║  update     — обновить flake                                                 ║
# ║  clean      — очистить старые версии                                         ║
# ║                                                                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    
    history = {
      size = 50000;
      save = 50000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };

    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit
      compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
    '';

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

    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "kubectl" "sudo" ];
    };

    shellAliases = {
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

      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      lg = "lazygit";

      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#matebook";
      update = "nix flake update /etc/nixos";
      clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      rm = "rm -i";
      mv = "mv -i";
      cp = "cp -i";
    };

    initContent = ''
      bindkey -v
      bindkey '^R' history-incremental-search-backward
      bindkey '^ ' autosuggest-accept
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey '^E' edit-command-line
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$username" "$hostname" "$directory"
        "$git_branch" "$git_status"
        "$nodejs" "$rust" "$golang" "$python"
        "$nix_shell" "$cmd_duration"
        "$line_break" "$character"
      ];
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };
      directory = { truncation_length = 3; style = "bold cyan"; };
      git_branch = { symbol = " "; style = "bold purple"; };
      nix_shell = { symbol = " "; style = "bold blue"; };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [ "--height 40%" "--layout=reverse" "--border" ];
    colors = {
      bg = "#1e1e2e"; "bg+" = "#313244";
      fg = "#cdd6f4"; "fg+" = "#cdd6f4";
      hl = "#f38ba8"; "hl+" = "#f38ba8";
      info = "#cba6f7"; prompt = "#cba6f7";
      pointer = "#f5e0dc"; marker = "#f5e0dc";
    };
  };
}

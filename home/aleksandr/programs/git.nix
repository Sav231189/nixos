# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Home Manager: Git                                                           ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Настройка системы контроля версий Git и связанных инструментов.             ║
# ║                                                                              ║
# ║  ЧТО НАСТРАИВАЕТСЯ:                                                          ║
# ║  • Git — конфиг, алиасы, глобальный .gitignore                               ║
# ║  • Delta — красивые diff с подсветкой синтаксиса                             ║
# ║  • Lazygit — TUI для Git (наглядный staging, commits, branches)              ║
# ║  • GitHub CLI (gh) — работа с GitHub из терминала                            ║
# ║                                                                              ║
# ║  ⚠️ TODO: Добавь свой email!                                                  ║
# ║  userEmail = "your@email.com";                                               ║
# ║                                                                              ║
# ║  ПОЛЕЗНЫЕ АЛИАСЫ:                                                            ║
# ║  g st     — git status                                                       ║
# ║  g lg     — красивый лог                                                     ║
# ║  lg       — запустить lazygit                                                ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    
    userName = "Aleksandr";
    # userEmail = "your@email.com";  # TODO: Set your email!
    
    # Default branch
    extraConfig = {
      init.defaultBranch = "main";
      
      # Better diffs
      diff.colorMoved = "default";
      
      # Pull strategy
      pull.rebase = true;
      
      # Push
      push.autoSetupRemote = true;
      
      # Core
      core = {
        editor = "code --wait";
        autocrlf = "input";
      };
      
      # Merge
      merge.conflictstyle = "diff3";
      
      # Rebase
      rebase.autoStash = true;
      
      # URL shortcuts
      url = {
        "git@github.com:" = {
          insteadOf = "gh:";
        };
      };
    };
    
    # Delta for better diffs
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "Catppuccin-mocha";
      };
    };
    
    # Aliases
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      lg = "log --oneline --graph --decorate --all";
      aa = "add --all";
      cm = "commit -m";
      amend = "commit --amend --no-edit";
      undo = "reset --soft HEAD~1";
    };
    
    # Ignores
    ignores = [
      # OS
      ".DS_Store"
      "Thumbs.db"
      
      # IDE
      ".idea/"
      ".vscode/"
      "*.swp"
      "*.swo"
      
      # Dependencies
      "node_modules/"
      
      # Build
      "dist/"
      "build/"
      "target/"
      
      # Env
      ".env"
      ".env.local"
      
      # Nix
      "result"
      "result-*"
    ];
  };

  # Lazygit 🔥
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          lightTheme = false;
          activeBorderColor = [ "green" "bold" ];
          inactiveBorderColor = [ "white" ];
          selectedLineBgColor = [ "reverse" ];
        };
        showFileTree = true;
        showRandomTip = false;
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
      keybinding = {
        universal = {
          quit = "q";
        };
      };
    };
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
}

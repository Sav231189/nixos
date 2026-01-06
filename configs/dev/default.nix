# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Dev — Разработка и CLI утилиты                                              ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║                                                                              ║
# ║  Инструменты разработчика:                                                   ║
# ║  • Git + Lazygit + GitHub CLI                                                ║
# ║  • Delta — красивый diff                                                     ║
# ║                                                                              ║
# ║  Современные CLI утилиты:                                                    ║
# ║  • ripgrep (rg) — замена grep                                                ║
# ║  • fd — замена find                                                          ║
# ║  • bat — замена cat                                                          ║
# ║  • eza — замена ls                                                           ║
# ║  • btop — замена top                                                         ║
# ║  • yazi — файловый менеджер                                                  ║
# ║                                                                              ║
# ║  Браузеры: Firefox, Chromium                                                 ║
# ║  Node.js: nodejs_22, bun                                                     ║
# ║                                                                              ║
# ║  TODO: Добавить email в git config!                                          ║
# ║                                                                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Aleksandr";
      # user.email = "your@email.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core = { editor = "nano"; autocrlf = "input"; };
      merge.conflictstyle = "diff3";
      rebase.autoStash = true;
      alias = {
        st = "status"; co = "checkout"; br = "branch"; ci = "commit";
        lg = "log --oneline --graph --decorate --all";
        aa = "add --all"; cm = "commit -m";
        amend = "commit --amend --no-edit";
      };
    };
    ignores = [
      ".DS_Store" "Thumbs.db"
      ".idea/" ".vscode/" "*.swp"
      "node_modules/" "dist/" "build/"
      ".env" ".env.local"
      "result" "result-*"
    ];
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = { showFileTree = true; showRandomTip = false; };
      git.paging = { colorArg = "always"; pager = "delta --dark --paging=never"; };
    };
  };

  programs.gh = {
    enable = true;
    settings = { git_protocol = "ssh"; prompt = "enabled"; };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = { navigate = true; light = false; side-by-side = true; line-numbers = true; };
  };

  home.packages = with pkgs; [
    firefox chromium
    nodejs_22 bun

    yazi
    ripgrep fd bat eza fzf jq yq
    htop btop duf dust
    tldr
    curl wget httpie
    unzip zip p7zip
    tree tokei hyperfine
    neofetch
    wl-clipboard
  ];

  programs.bat = {
    enable = true;
    config = { theme = "base16"; pager = "less -FR"; };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [ "--group-directories-first" ];
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = { manager = { show_hidden = false; sort_by = "natural"; sort_dir_first = true; }; };
  };

  programs.btop = {
    enable = true;
    settings = { color_theme = "catppuccin_mocha"; theme_background = false; vim_keys = true; };
  };
}

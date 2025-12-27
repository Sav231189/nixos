# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Home Manager: CLI Утилиты                                                   ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Современные замены стандартных Unix команд.                                 ║
# ║                                                                              ║
# ║  УСТАНОВЛЕННЫЕ УТИЛИТЫ:                                                      ║
# ║  • ripgrep (rg)  — замена grep, в 10x быстрее                                ║
# ║  • fd            — замена find, простой синтаксис                            ║
# ║  • bat           — замена cat с подсветкой синтаксиса                        ║
# ║  • eza           — замена ls с иконками и git-статусом                       ║
# ║  • btop          — замена top с красивыми графиками                          ║
# ║  • dust          — замена du для визуализации размера                        ║
# ║  • duf           — замена df для просмотра дисков                            ║
# ║  • tldr          — замена man с примерами использования                      ║
# ║  • yazi          — TUI файловый менеджер с превью                            ║
# ║                                                                              ║
# ║  ТЕМА: Catppuccin Mocha (единый стиль везде)                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # === File Management ===
    yazi              # TUI file manager with preview
    
    # === Modern CLI Tools ===
    ripgrep           # rg - faster grep
    fd                # faster find
    bat               # cat with syntax highlighting
    eza               # ls with icons and colors
    fzf               # fuzzy finder (configured in shell.nix)
    jq                # JSON processor
    yq                # YAML processor
    
    # === System Monitoring ===
    htop              # Process viewer
    btop              # Beautiful process viewer
    duf               # Disk usage (df replacement)
    dust              # Disk usage analyzer (du replacement)
    
    # === Help & Docs ===
    tldr              # Simplified man pages
    
    # === Network ===
    curl
    wget
    httpie           # Better curl for APIs
    
    # === Archive ===
    unzip
    zip
    p7zip
    
    # === Development ===
    tree              # Directory tree
    tokei             # Code statistics
    hyperfine         # Benchmarking
    
    # === Fun ===
    neofetch          # System info
    
    # === Clipboard ===
    wl-clipboard      # Wayland clipboard
  ];

  # Bat configuration (cat replacement)
  programs.bat = {
    enable = true;
    config = {
      # Using built-in theme (custom theme URL is 404)
      theme = "base16";
      pager = "less -FR";
      style = "numbers,changes,header";
    };
    # themes removed - catppuccin repo structure changed
  };

  # Eza configuration (ls replacement)
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  # Yazi file manager 🔥
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden = false;
        sort_by = "natural";
        sort_dir_first = true;
      };
    };
  };

  # Btop configuration
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = false;  # Transparent
      vim_keys = true;
    };
  };
}

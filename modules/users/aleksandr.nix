# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Модуль: Пользователь Aleksandr                                              ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Системная настройка пользователя и его окружения.                           ║
# ║                                                                              ║
# ║  ЧТО НАСТРАИВАЕТСЯ:                                                          ║
# ║  • Создание пользователя aleksandr                                           ║
# ║  • Группы — wheel (sudo), networkmanager, video, audio                       ║
# ║  • Shell — zsh по умолчанию                                                  ║
# ║  • Базовые программы — браузеры, VS Code, Node.js, bun                       ║
# ║                                                                              ║
# ║  ВАЖНО:                                                                      ║
# ║  После первой установки смени пароль командой: passwd aleksandr              ║
# ║  Начальный пароль: changeme                                                  ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, ... }:

{
  users.users.aleksandr = {
    isNormalUser = true;
    description = "Aleksandr";
    
    # Groups
    extraGroups = [
      "wheel"           # sudo access
      "networkmanager"  # Network management
      "video"           # Brightness control
      "audio"           # Audio access
      "input"           # Input devices
      "docker"          # Docker (if enabled)
    ];
    
    # Default shell
    shell = pkgs.zsh;
    
    # Password is set during nixos-install
  };

  # Root needs a password for emergency mode access
  users.users.root.initialPassword = "root";

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # User packages (available to all users)
  # Most packages are managed by Home Manager
  environment.systemPackages = with pkgs; [
    # Browsers
    firefox
    chromium
    
    # Development
    vscode
    nodejs_22
    bun
    
    # CLI essentials (some managed by home-manager too)
    git
    lazygit
  ];
}

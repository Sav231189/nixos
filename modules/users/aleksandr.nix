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
    
    # Password: changeme - user should change after first login
    initialPassword = "changeme";
  };

  # Root password: root (needed for emergency mode)
  # Hash generated with: openssl passwd -6 root
  users.users.root.hashedPassword = "$6$a6Kvvy8.mCz.POd5$yzrA0QruLcS1quV7T2a45eZRSHqeOo999/9QvbfC/Cu38HaZWT7xhIe77iDdgLZGvKZEiXFaZMzx1v8/i1/ML..";

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

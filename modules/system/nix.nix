# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Модуль: Настройки Nix                                                       ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Конфигурация пакетного менеджера Nix и системных пакетов.                   ║
# ║                                                                              ║
# ║  ЧТО НАСТРАИВАЕТСЯ:                                                          ║
# ║  • Flakes — включаем экспериментальные фичи (nix-command, flakes)            ║
# ║  • Binary caches — откуда скачивать готовые пакеты (cache.nixos.org и др.)   ║
# ║  • Garbage collection — автоочистка старых поколений (раз в неделю)          ║
# ║  • Unfree packages — разрешаем несвободные пакеты (VS Code и др.)            ║
# ║  • Системные пакеты — базовые утилиты для всех пользователей                 ║
# ║                                                                              ║
# ║  ПОЛЕЗНЫЕ КОМАНДЫ:                                                           ║
# ║  nix-collect-garbage -d     — удалить все старые поколения                   ║
# ║  nix store gc               — очистить неиспользуемые пакеты                 ║
# ║  nix store optimise         — дедупликация store                             ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, ... }:

{
  # Enable Flakes and new nix command
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      
      # Optimise store automatically
      auto-optimise-store = true;
      
      # Trusted users for remote builds
      trusted-users = [ "root" "@wheel" ];
      
      # Substituters (binary caches)
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];
      
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Allow unfree packages (VS Code, etc.)
  nixpkgs.config.allowUnfree = true;

  # System packages (available to all users)
  environment.systemPackages = with pkgs; [
    # Essential
    git
    vim
    wget
    curl
    unzip
    
    # System tools
    pciutils
    usbutils
    lshw
    
    # File systems
    btrfs-progs
    ntfs3g
  ];
}

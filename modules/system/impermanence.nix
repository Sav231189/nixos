# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Модуль: Impermanence (Эфемерный корень)                                     ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Настройка stateless системы — корень очищается при каждой перезагрузке.     ║
# ║                                                                              ║
# ║  КАК ЭТО РАБОТАЕТ:                                                           ║
# ║  1. При загрузке корневой раздел (@) полностью пустой                        ║
# ║  2. Impermanence создаёт симлинки из /persist в нужные места                 ║
# ║  3. Все важные данные хранятся только в /persist                             ║
# ║                                                                              ║
# ║  ЗАЧЕМ ЭТО НУЖНО:                                                            ║
# ║  • Система всегда "чистая" как после установки                               ║
# ║  • Никакой "мусор" не накапливается со временем                              ║
# ║  • Если что-то сломалось — просто перезагрузись                              ║
# ║  • Точно знаешь, какие файлы реально нужны системе                           ║
# ║                                                                              ║
# ║  ЕСЛИ ЧТО-ТО ПРОПАЛО ПОСЛЕ ПЕРЕЗАГРУЗКИ:                                     ║
# ║  Добавь путь к файлу/директории в соответствующий список ниже!               ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, ... }:

{
  # Impermanence - define what persists across reboots
  environment.persistence."/persist" = {
    hideMounts = true;
    
    # System directories to persist
    directories = [
      "/etc/nixos"                    # NixOS configuration
      "/etc/NetworkManager/system-connections"  # WiFi passwords
      "/var/lib/bluetooth"            # Bluetooth pairings
      "/var/lib/systemd/coredump"     # Core dumps
      "/var/lib/nixos"                # NixOS state
    ];
    
    # System files to persist
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
    
    # User-specific persistence
    users.aleksandr = {
      directories = [
        # Shell & terminal
        ".local/share/zoxide"         # Zoxide history
        ".local/share/zsh"            # Zsh history
        
        # Development
        ".ssh"                        # SSH keys
        ".gnupg"                      # GPG keys
        ".config/git"                 # Git config
        
        # VS Code
        ".config/Code"
        ".vscode"
        
        # Browsers
        ".mozilla"                    # Firefox
        ".config/chromium"            # Chromium
        
        # Projects (if you want them in home)
        "projects"
        "work"
        
        # Downloads
        "Downloads"
        "Documents"
        "Pictures"
        
        # Application data
        ".local/share/applications"
        ".local/state"
      ];
      
      files = [
        ".config/starship.toml"       # Starship config (if not managed by home-manager)
      ];
    };
  };

  # Needed for impermanence to work properly
  programs.fuse.userAllowOther = true;

  # Create the persist directory structure
  systemd.tmpfiles.rules = [
    "d /persist/home 0755 root root -"
    "d /persist/home/aleksandr 0700 aleksandr users -"
  ];
}

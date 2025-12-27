# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Модуль: Файловая система (Filesystem)                                       ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Настройка BTRFS subvolumes и swap для системы.                              ║
# ║                                                                              ║
# ║  ЧТО НАСТРАИВАЕТСЯ:                                                          ║
# ║  • BTRFS subvolumes — логическое разделение одного раздела                   ║
# ║  • Опции монтирования — компрессия zstd, SSD оптимизации                     ║
# ║  • Swapfile — для гибернации (suspend-to-disk)                               ║
# ║  • zram — быстрый swap в сжатой RAM                                          ║
# ║                                                                              ║
# ║  SUBVOLUMES:                                                                 ║
# ║  @         → /           (корень, очищается при перезагрузке)                ║
# ║  @home     → /home       (данные пользователя)                               ║
# ║  @nix      → /nix        (Nix store — пакеты и конфиги)                      ║
# ║  @persist  → /persist    (данные, которые должны сохраняться)                ║
# ║  @log      → /var/log    (логи системы)                                      ║
# ║  @swap     → /swap       (swapfile для гибернации)                           ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, ... }:

{
  # BTRFS mount options
  # These will be applied to all BTRFS mounts
  
  fileSystems = {
    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ 
        "subvol=@"
        "compress=zstd:1"
        "noatime"
        "ssd"
        "discard=async"
        "space_cache=v2"
      ];
    };

    "/home" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ 
        "subvol=@home"
        "compress=zstd:1"
        "noatime"
        "ssd"
        "discard=async"
        "space_cache=v2"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ 
        "subvol=@nix"
        "compress=zstd:1"
        "noatime"
        "ssd"
        "discard=async"
        "space_cache=v2"
      ];
      neededForBoot = true;
    };

    "/persist" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ 
        "subvol=@persist"
        "compress=zstd:1"
        "noatime"
        "ssd"
        "discard=async"
        "space_cache=v2"
      ];
      neededForBoot = true;
    };

    "/var/log" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ 
        "subvol=@log"
        "compress=zstd:1"
        "noatime"
        "ssd"
        "discard=async"
        "space_cache=v2"
      ];
      neededForBoot = true;
    };

    "/.snapshots" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ 
        "subvol=@snapshots"
        "compress=zstd:1"
        "noatime"
        "ssd"
        "discard=async"
        "space_cache=v2"
      ];
    };

    "/swap" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ 
        "subvol=@swap"
        "noatime"
        "ssd"
        # No compression for swap!
      ];
    };

    # ВАЖНО: /boot определён в hardware.nix с правильным UUID!
    # Не дублируем здесь, иначе будет конфликт.
  };

  # Swap configuration
  # Swapfile for hibernation (18GB = RAM + buffer)
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 18 * 1024;  # 18GB in MB
    }
  ];

  # zram - compressed RAM swap (16GB)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;  # Use up to 100% of RAM for zram
  };

  # BTRFS maintenance
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
}

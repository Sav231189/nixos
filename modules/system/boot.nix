# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Модуль: Загрузка системы (Boot)                                             ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Настройка загрузчика, шифрования и процесса запуска системы.                ║
# ║                                                                              ║
# ║  ЧТО НАСТРАИВАЕТСЯ:                                                          ║
# ║  • Systemd-boot    — современный UEFI загрузчик (вместо GRUB)                ║
# ║  • LUKS            — расшифровка диска при загрузке                          ║
# ║  • Plymouth        — красивый splash-screen при загрузке                     ║
# ║  • Ядро Linux      — используем последнюю стабильную версию                  ║
# ║                                                                              ║
# ║  ЦЕПОЧКА ЗАГРУЗКИ:                                                           ║
# ║  UEFI → Systemd-boot → Ядро Linux → LUKS расшифровка → Plymouth → Система   ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, ... }:

{
  # Bootloader - systemd-boot (modern, fast, simple)
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;  # Keep last 10 generations
      editor = false;           # Disable kernel cmdline editing for security
    };
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  # LUKS encryption
  boot.initrd.luks.devices = {
    "cryptroot" = {
      device = "/dev/disk/by-label/cryptroot";
      preLVM = true;
      allowDiscards = true;  # Enable TRIM for SSD
      bypassWorkqueues = true;  # Better SSD performance
    };
  };

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel parameters
  boot.kernelParams = [
    "quiet"
    "splash"
    "mitigations=auto"
  ];

  # Plymouth for boot splash (optional but pretty)
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  # Initrd modules for fast boot
  boot.initrd.systemd.enable = true;

  # Silent boot
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
}

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

  # LUKS encryption options
  # ВАЖНО: Само устройство (device) определено в hardware.nix!
  # Здесь только дополнительные опции для производительности SSD
  boot.initrd.luks.devices."cryptroot" = {
    preLVM = true;
    allowDiscards = true;  # Enable TRIM for SSD
    bypassWorkqueues = true;  # Better SSD performance
  };

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel parameters
  boot.kernelParams = [
    "quiet"
    "splash"
    "mitigations=auto"
    # Intel WiFi AX211 stability fixes
    "iwlwifi.power_save=0"
    "iwlwifi.uapsd_disable=1"
    "iwlmvm.power_scheme=1"
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

  # Intel WiFi firmware
  hardware.firmware = [ pkgs.linux-firmware ];
}

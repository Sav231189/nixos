# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Hardware Configuration — Автогенерированный файл                            ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Этот файл описывает аппаратную конфигурацию конкретной машины.              ║
# ║                                                                              ║
# ║  ⚠️ ВАЖНО: Это ЗАГЛУШКА!                                                      ║
# ║  При установке замени этот файл реальным hardware-configuration.nix          ║
# ║                                                                              ║
# ║  КАК ПОЛУЧИТЬ РЕАЛЬНЫЙ КОНФИГ:                                               ║
# ║  1. Загрузись с USB NixOS                                                    ║
# ║  2. Разметь диск и смонтируй в /mnt                                          ║
# ║  3. Выполни: nixos-generate-config --root /mnt                               ║
# ║  4. Скопируй /mnt/etc/nixos/hardware-configuration.nix сюда                  ║
# ║                                                                              ║
# ║  Этот файл автоматически определяет:                                         ║
# ║  • UUID разделов                                                             ║
# ║  • Необходимые модули ядра                                                   ║
# ║  • Специфичные настройки железа                                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # NOTE: This is a placeholder configuration!
  # Replace this file with the output of `nixos-generate-config --root /mnt`
  # after partitioning and mounting your drives during installation.

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-partlabel/primary";

  # Kernel modules for Intel 12th Gen + NVMe
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Placeholder filesystem configuration
  # These will be overwritten by the real hardware-configuration.nix
  
  # IMPORTANT: During installation, run:
  # 1. nixos-generate-config --root /mnt
  # 2. Copy the generated hardware-configuration.nix to this file
  
  # Example of what the real config will look like:
  fileSystems."/" = {
    device = "/dev/disk/by-partlabel/primary";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd" "noatime" ];
  };

  # Enable firmware updates
  hardware.enableRedistributableFirmware = true;
  
  # CPU
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

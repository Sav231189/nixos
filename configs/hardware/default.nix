# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Hardware — Intel Laptop (MateBook X Pro)                                    ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║                                                                              ║
# ║  Аппаратные настройки для Intel ноутбука:                                    ║
# ║  • Intel GPU — драйвера для видео                                            ║
# ║  • Power Management — управление питанием, hibernate                         ║
# ║  • Touchpad — настройки тачпада                                              ║
# ║                                                                              ║
# ║  Для AMD ноутбука создать отдельный конфиг.                                  ║
# ║                                                                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, ... }:

{
  # Intel GPU
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver intel-compute-runtime vpl-gpu-rt ];
  };
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Power Management
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;
  programs.light.enable = true;
  services.acpid.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "lock";
    HandlePowerKey = "suspend";
  };

  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "Hibernate";
  };

  # Touchpad
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      clickMethod = "clickfinger";
      disableWhileTyping = true;
    };
  };
}

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Модуль: Intel Hardware                                                      ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Настройка железа для Intel 12th Gen (Alder Lake) в ноутбуке.                ║
# ║                                                                              ║
# ║  ЧТО НАСТРАИВАЕТСЯ:                                                          ║
# ║  • Intel GPU — драйверы, VAAPI для аппаратного декодирования видео           ║
# ║  • Power Management — термалы, энергосбережение, TLP                         ║
# ║  • Touchpad — тап, natural scroll, отключение при печати                     ║
# ║  • Lid Switch — что делать при закрытии крышки                               ║
# ║  • Battery — уровни предупреждений, гибернация при критическом заряде        ║
# ║                                                                              ║
# ║  УПРАВЛЕНИЕ ЯРКОСТЬЮ:                                                        ║
# ║  brightnessctl s +5%    — увеличить яркость                                  ║
# ║  brightnessctl s 5%-    — уменьшить яркость                                  ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, ... }:

{
  # Intel GPU drivers
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver    # VAAPI driver for Intel Gen 8+
      intel-compute-runtime # OpenCL
      vpl-gpu-rt            # Intel Quick Sync Video
    ];
  };

  # Intel power management
  services.thermald.enable = true;
  
  # Power management for laptop
  services.power-profiles-daemon.enable = true;
  
  # TLP for advanced power management (alternative to power-profiles-daemon)
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #   };
  # };

  # Backlight control
  programs.light.enable = true;
  
  # Lid switch behavior (updated syntax for 2025)
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "lock";
    HandlePowerKey = "suspend";
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

  # Fingerprint reader (if available on MateBook)
  # services.fprintd.enable = true;

  # Intel microcode updates
  hardware.cpu.intel.updateMicrocode = true;

  # ACPI events
  services.acpid.enable = true;

  # Battery stats
  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "Hibernate";
  };
}

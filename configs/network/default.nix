# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Network — Сеть                                                              ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║                                                                              ║
# ║  Настройки сети для NixOS:                                                   ║
# ║  • NetworkManager — управление WiFi                                          ║
# ║  • Bluetooth — беспроводные устройства                                       ║
# ║  • Firewall — защита сети                                                    ║
# ║  • DNS — systemd-resolved с fallback серверами                               ║
# ║  • Avahi — обнаружение устройств в локальной сети                            ║
# ║                                                                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, ... }:

{
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
  };

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    fallbackDns = [ "1.1.1.1" "8.8.8.8" "9.9.9.9" ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Enable = "Source,Sink,Media,Socket";
  };

  services.blueman.enable = true;
}

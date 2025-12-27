# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Модуль: Сеть (Networking)                                                   ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Настройка WiFi, Bluetooth, DNS и firewall.                                  ║
# ║                                                                              ║
# ║  ЧТО НАСТРАИВАЕТСЯ:                                                          ║
# ║  • NetworkManager — управление WiFi и проводными подключениями               ║
# ║  • systemd-resolved — DNS с fallback на Cloudflare/Google                    ║
# ║  • Bluetooth — с поддержкой A2DP (наушники)                                  ║
# ║  • Avahi — mDNS для обнаружения устройств в локальной сети                   ║
# ║  • Firewall — базовая защита, открываем порты по необходимости               ║
# ║                                                                              ║
# ║  КАК ПОДКЛЮЧИТЬСЯ К WIFI:                                                    ║
# ║  1. nmtui                    — текстовый интерфейс                           ║
# ║  2. nmcli device wifi list   — список сетей                                  ║
# ║  3. nmcli device wifi connect "SSID" password "пароль"                       ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, ... }:

{
  # NetworkManager for WiFi and network management
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };

  # Disable wpa_supplicant (NetworkManager handles WiFi)
  networking.wireless.enable = false;

  # Firewall
  networking.firewall = {
    enable = true;
    allowPing = true;
    # Add ports as needed:
    # allowedTCPPorts = [ 22 80 443 ];
    # allowedUDPPorts = [ ];
  };

  # DNS (using systemd-resolved)
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    fallbackDns = [
      "1.1.1.1"      # Cloudflare
      "8.8.8.8"      # Google
      "9.9.9.9"      # Quad9
    ];
  };

  # mDNS for local network discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;
}

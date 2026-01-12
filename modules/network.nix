# ============================================================================== #
#                                                                                #
#   Network — Сеть, WiFi, Bluetooth                                              #
#                                                                                #
# ============================================================================== #
#
#   ЧТО ЭТО?
#   ─────────────────────────────────────────────────────────────────────────────
#   Настройки сети для NixOS. Это СИСТЕМНЫЙ модуль (не Home Manager).
#
#   КОМПОНЕНТЫ:
#   • NetworkManager — управление WiFi и Ethernet
#   • Bluetooth — беспроводные устройства (наушники, мышь)
#   • Firewall — защита от внешних подключений
#   • DNS — systemd-resolved с fallback серверами
#   • Avahi — обнаружение устройств в локальной сети (.local домены)
#
#   КОМАНДЫ:
#   nmcli device wifi list           — список WiFi сетей
#   nmcli device wifi connect SSID   — подключиться к сети
#   nmtui                            — TUI для сети
#   bluetoothctl                     — управление Bluetooth
#
# ============================================================================== #
{ config, lib, pkgs, ... }:

{
  # ══════════════════════════════════════════════════════════════════════════════
  # NETWORKMANAGER — Управление сетью
  # ══════════════════════════════════════════════════════════════════════════════
  networking.networkmanager = {
    enable = true;           # Отключить: enable = false (не рекомендуется)
    wifi.powersave = false;  # Отключить энергосбережение WiFi (стабильнее)
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # FIREWALL — Защита сети
  # ══════════════════════════════════════════════════════════════════════════════
  networking.firewall = {
    enable = true;           # Отключить: enable = false (НЕ РЕКОМЕНДУЕТСЯ!)
    allowPing = true;        # Разрешить ping (для диагностики)
    # allowedTCPPorts = [ 22 80 443 ];  # Открыть порты если нужно
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # DNS — Резолвер доменных имён
  # ══════════════════════════════════════════════════════════════════════════════
  services.resolved = {
    enable = true;                     # Отключить: enable = false
    dnssec = "allow-downgrade";        # DNSSEC с fallback
    fallbackDns = [
      "1.1.1.1"                        # Cloudflare
      "8.8.8.8"                        # Google
      "9.9.9.9"                        # Quad9
    ];
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # AVAHI — Обнаружение устройств в локальной сети
  # ══════════════════════════════════════════════════════════════════════════════
  # Позволяет использовать hostname.local для устройств в сети
  services.avahi = {
    enable = true;           # Отключить: enable = false
    nssmdns4 = true;         # Поддержка .local доменов
    openFirewall = true;     # Открыть порты для Avahi
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # BLUETOOTH — Беспроводные устройства
  # ══════════════════════════════════════════════════════════════════════════════
  hardware.bluetooth = {
    enable = true;           # Отключить: enable = false
    powerOnBoot = true;      # Включать Bluetooth при загрузке
    settings.General.Enable = "Source,Sink,Media,Socket";  # Все профили аудио
  };

  # Blueman — GUI для Bluetooth (иконка в трее)
  services.blueman.enable = true;  # Отключить: enable = false

  # ══════════════════════════════════════════════════════════════════════════════
  # COMPLEMENTARY PACKAGES
  # ══════════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    wireguard-tools  # Утилиты для настройки WireGuard (wg)
  ];

  # ══════════════════════════════════════════════════════════════════════════════
  # VPN — WireGuard
  # ══════════════════════════════════════════════════════════════════════════════
  # Теперь управляется через NetworkManager (GUI).
  # Для добавления конфигов используйте:
  # sudo nmcli connection import type wireguard file /etc/wireguard/ams.conf
  # sudo nmcli connection import type wireguard file /etc/wireguard/home-lab.conf
  # sudo nmcli connection import type wireguard file /etc/wireguard/ckb.conf
}

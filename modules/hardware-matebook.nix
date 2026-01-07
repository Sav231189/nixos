# ============================================================================== #
#                                                                                #
#   Hardware — Huawei MateBook X Pro (Intel)                                     #
#                                                                                #
# ============================================================================== #
#
#   ЧТО ЭТО?
#   ─────────────────────────────────────────────────────────────────────────────
#   Аппаратные настройки специфичные для Intel ноутбука.
#   Это СИСТЕМНЫЙ модуль (NixOS, не Home Manager).
#
#   КОМПОНЕНТЫ:
#   • Intel GPU — драйвера для интегрированной графики
#   • Power Management — управление питанием, сон, гибернация
#   • Touchpad — настройки тачпада (libinput)
#
#   ПРИМЕЧАНИЕ:
#   Для другого ноутбука создайте отдельный модуль:
#   • modules/hardware-thinkpad
#   • modules/hardware-amd
#   • и т.д.
#
# ============================================================================== #
{ config, lib, pkgs, ... }:

{
  # ══════════════════════════════════════════════════════════════════════════════
  # INTEL GPU — Драйвера видеокарты
  # ══════════════════════════════════════════════════════════════════════════════
  hardware.graphics = {
    enable = true;  # Отключить: enable = false (НЕ РЕКОМЕНДУЕТСЯ)
    extraPackages = with pkgs; [
      intel-media-driver     # VA-API для аппаратного декодирования видео
      intel-compute-runtime  # OpenCL для вычислений на GPU
      vpl-gpu-rt             # Intel Video Processing Library
    ];
  };

  # Обновление микрокода процессора (исправления безопасности)
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # ══════════════════════════════════════════════════════════════════════════════
  # POWER MANAGEMENT — Управление питанием
  # ══════════════════════════════════════════════════════════════════════════════
  services.thermald.enable = true;             # Контроль температуры (Intel)
  services.power-profiles-daemon.enable = true; # Профили питания (performance/balanced/power-saver)
  programs.light.enable = true;                 # Управление яркостью (команда: light)
  services.acpid.enable = true;                 # ACPI события (кнопка питания, крышка)

  # ── Поведение при закрытии крышки и нажатии кнопки питания ─────────────────
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";           # Закрытие крышки — сон
    HandleLidSwitchExternalPower = "lock"; # Закрытие крышки на зарядке — блокировка
    HandlePowerKey = "suspend";            # Кнопка питания — сон
  };

  # ── UPower — мониторинг батареи ────────────────────────────────────────────
  services.upower = {
    enable = true;           # Отключить: enable = false
    percentageLow = 15;      # Низкий заряд (предупреждение)
    percentageCritical = 5;  # Критический заряд
    percentageAction = 3;    # Действие при критическом заряде
    criticalPowerAction = "Hibernate";  # Гибернация при 3%
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # TOUCHPAD — Настройки тачпада (libinput)
  # ══════════════════════════════════════════════════════════════════════════════
  services.libinput = {
    enable = true;  # Отключить: enable = false (НЕ РЕКОМЕНДУЕТСЯ на ноутбуке)

    touchpad = {
      naturalScrolling = true;      # Естественная прокрутка (как на телефоне)
      tapping = true;               # Тап = клик
      clickMethod = "clickfinger";  # Два пальца = правый клик
      disableWhileTyping = true;    # Отключать тачпад при наборе текста
    };
  };
}

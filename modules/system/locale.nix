# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Модуль: Локализация (Locale)                                                ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Настройка языка, часового пояса и раскладки клавиатуры.                     ║
# ║                                                                              ║
# ║  ЧТО НАСТРАИВАЕТСЯ:                                                          ║
# ║  • Timezone — Asia/Yekaterinburg (UTC+5)                                     ║
# ║  • Основной язык — English (en_US.UTF-8)                                     ║
# ║  • Дополнительный — Русский (ru_RU.UTF-8) для дат, денег и т.д.              ║
# ║  • Раскладка — us,ru с переключением через Alt+Shift                         ║
# ║                                                                              ║
# ║  ПЕРЕКЛЮЧЕНИЕ РАСКЛАДКИ:                                                     ║
# ║  Alt + Shift — переключение между английской и русской раскладкой            ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, ... }:

{
  # Timezone
  time.timeZone = "Asia/Yekaterinburg";  # UTC+5

  # Locale
  i18n = {
    defaultLocale = "en_US.UTF-8";
    
    extraLocaleSettings = {
      LC_ADDRESS = "ru_RU.UTF-8";
      LC_IDENTIFICATION = "ru_RU.UTF-8";
      LC_MEASUREMENT = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
      LC_NAME = "ru_RU.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "ru_RU.UTF-8";
      LC_TELEPHONE = "ru_RU.UTF-8";
      LC_TIME = "ru_RU.UTF-8";
    };
    
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];
  };

  # Console (TTY) configuration
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;  # Use same keyboard config as X11/Wayland
  };

  # Keyboard layout (for Wayland/X11)
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:alt_shift_toggle";  # Alt+Shift to switch layout
  };
}

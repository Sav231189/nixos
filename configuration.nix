# ============================================================================== #
#                                                                                #
#   ███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗                                       #
#   ████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝                                       #
#   ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗                                       #
#   ██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║                                       #
#   ██║ ╚████║██║██╔╝ ╚██╗╚██████╔╝███████║                                       #
#   ╚═╝  ╚═══╝╚═╝╚═╝   ╚═╝ ╚═════╝ ╚══════╝                                       #
#                                                                                #
#   configuration.nix — Системная конфигурация NixOS                             #
#   Host: matebook (Huawei MateBook X Pro)                                       #
#                                                                                #
# ============================================================================== #
#
#   ЧТО ЭТО?
#   ─────────────────────────────────────────────────────────────────────────────
#   Главный файл системы NixOS. Всё что здесь — это СИСТЕМНЫЕ настройки:
#   загрузчик, ядро, сервисы, пользователи, системные пакеты.
#
#   Пользовательские настройки (dotfiles, темы) — в home.nix
#
#   КОМАНДЫ:
#   ─────────────────────────────────────────────────────────────────────────────
#   sudo nixos-rebuild switch --flake ~/nixos#matebook   применить изменения
#   sudo nixos-rebuild test --flake ~/nixos#matebook     тест без сохранения
#   nix flake update ~/nixos                             обновить пакеты
#   sudo nix-collect-garbage -d                          очистить старые поколения
#
# ============================================================================== #
{ config, lib, pkgs, ... }:

{
  # ══════════════════════════════════════════════════════════════════════════════
  # IMPORTS — Внешние модули
  # ══════════════════════════════════════════════════════════════════════════════
  # Закомментируй строку чтобы отключить модуль
  imports = [
    ./hardware-configuration.nix    # Автогенерированный (диски, LUKS) — НЕ ТРОГАТЬ
    ./modules/hardware-matebook.nix # Intel GPU, управление питанием, тачпад
    ./modules/network.nix           # WiFi, Bluetooth, firewall
  ];

  # ══════════════════════════════════════════════════════════════════════════════
  # SYSTEM — Базовые настройки системы
  # ══════════════════════════════════════════════════════════════════════════════
  networking.hostName = "matebook";       # Имя хоста (показывается в терминале)
  system.stateVersion = "25.05";          # НЕ МЕНЯТЬ! Версия при установке

  # ══════════════════════════════════════════════════════════════════════════════
  # NIX — Настройки пакетного менеджера
  # ══════════════════════════════════════════════════════════════════════════════
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];  # Включает flakes
      auto-optimise-store = true;                          # Дедупликация файлов
      trusted-users = [ "root" "@wheel" ];                 # Кто может управлять nix
    };
    # Автоочистка старых поколений (раз в неделю, старше 14 дней)
    gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 14d"; };
  };
  nixpkgs.config.allowUnfree = true;  # Разрешить проприетарные пакеты (Chrome, Discord)

  # ══════════════════════════════════════════════════════════════════════════════
  # BOOT — Загрузчик и ядро
  # ══════════════════════════════════════════════════════════════════════════════
  boot.loader = {
    systemd-boot = {
      enable = true;              # Загрузчик systemd-boot (для UEFI)
      configurationLimit = 10;    # Сколько поколений хранить в меню
      editor = false;             # Отключить редактор (безопасность)
    };
    efi.canTouchEfiVariables = true;  # Разрешить запись в EFI
    timeout = 3;                      # Секунд в меню загрузки
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;  # Последнее ядро Linux
  boot.kernelParams = [
    # Тихий запуск (без логов в консоли)
    "quiet" "splash" "mitigations=auto"
    # Стабильность WiFi (Intel iwlwifi) — отключить если НЕ Intel WiFi
    "iwlwifi.power_save=0" "iwlwifi.uapsd_disable=1" "iwlmvm.power_scheme=1"
  ];

  # Plymouth — графическая заставка при загрузке
  boot.plymouth = { enable = true; theme = "breeze"; };  # Отключить: enable = false
  boot.initrd.systemd.enable = true;   # systemd в initrd (для Plymouth)
  boot.consoleLogLevel = 0;            # Убрать логи при загрузке
  boot.initrd.verbose = false;         # Тихий initrd

  # ══════════════════════════════════════════════════════════════════════════════
  # FILESYSTEM — Файловая система и swap
  # ══════════════════════════════════════════════════════════════════════════════
  # ZRAM — swap в сжатой RAM (быстрее чем на диске)
  zramSwap = {
    enable = true;           # Отключить: enable = false
    algorithm = "zstd";      # Алгоритм сжатия
    memoryPercent = 50;      # Использовать 50% RAM под swap
  };

  # BTRFS scrub — проверка целостности данных (раз в месяц)
  services.btrfs.autoScrub = {
    enable = true;               # Отключить: enable = false
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # SERVICES — Системные сервисы
  # ══════════════════════════════════════════════════════════════════════════════
  # Файловый менеджер
  services.gvfs.enable = true;     # GVFS — нужен для Nautilus (корзина, монтирование)
  services.udisks2.enable = true;  # UDisks2 — автомонтирование USB

  # ══════════════════════════════════════════════════════════════════════════════
  # DESKTOP — Wayland окружение
  # ══════════════════════════════════════════════════════════════════════════════
  # Переменные окружения для Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";            # Electron приложения через Wayland
    MOZ_ENABLE_WAYLAND = "1";        # Firefox через Wayland
    QT_QPA_PLATFORM = "wayland";     # Qt приложения через Wayland
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  # Hyprland — тайловый Wayland композитор
  programs.hyprland = {
    enable = true;          # Отключить: enable = false
    xwayland.enable = true; # Поддержка X11 приложений
  };

  # XDG Portal — диалоги открытия файлов, скриншоты
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland  # Portal для Hyprland
      pkgs.xdg-desktop-portal-gtk       # GTK fallback
    ];
  };

  # Polkit — окна авторизации sudo
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
  };

  # Dconf и Keyring — нужны для GTK приложений
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;          # Хранение паролей
  security.pam.services.login.enableGnomeKeyring = true;

  # ══════════════════════════════════════════════════════════════════════════════
  # AUDIO — Звуковая система (PipeWire)
  # ══════════════════════════════════════════════════════════════════════════════
  services.pulseaudio.enable = false;  # Отключаем PulseAudio
  security.rtkit.enable = true;        # Realtime приоритет для звука

  services.pipewire = {
    enable = true;            # Отключить: enable = false (только если не нужен звук)
    alsa.enable = true;       # ALSA совместимость
    alsa.support32Bit = true; # 32-bit приложения (Steam, Wine)
    pulse.enable = true;      # PulseAudio совместимость
    jack.enable = true;       # JACK для профессионального аудио
  };

  # Upower needed for Noctalia Shell
  services.upower.enable = true;

  # ══════════════════════════════════════════════════════════════════════════════
  # FONTS — Шрифты системы
  # ══════════════════════════════════════════════════════════════════════════════
  fonts = {
    enableDefaultPackages = true;  # Базовые шрифты
    packages = with pkgs; [
      # Моноширинные (терминал, код)
      nerd-fonts.jetbrains-mono    # JetBrains Mono + иконки Nerd Fonts
      nerd-fonts.fira-code         # Fira Code + лигатуры

      # UI шрифты
      inter                        # Inter — современный UI шрифт
      roboto                       # Roboto — Google шрифт
      noto-fonts                   # Noto — покрывает все языки
      noto-fonts-color-emoji       # Эмодзи
      font-awesome                 # Иконки для Waybar
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Inter" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # LOCALE — Язык, время, клавиатура
  # ══════════════════════════════════════════════════════════════════════════════
  time.timeZone = "Asia/Yekaterinburg";  # Часовой пояс

  i18n = {
    defaultLocale = "en_US.UTF-8";                                        # Системный язык
    extraLocaleSettings = { LC_TIME = "ru_RU.UTF-8"; LC_MONETARY = "ru_RU.UTF-8"; };
    supportedLocales = [ "en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" ];
  };

  console = { font = "Lat2-Terminus16"; useXkbConfig = true; };           # Консольный шрифт
  services.xserver.xkb = { layout = "us,ru"; options = "grp:alt_shift_toggle"; };  # Alt+Shift переключение

  # ══════════════════════════════════════════════════════════════════════════════
  # USER — Пользователь
  # ══════════════════════════════════════════════════════════════════════════════
  services.getty.autologinUser = "alxr";  # Автологин (убрать для пароля)

  users.users.alxr = {
    isNormalUser = true;
    description = "Aleksandr";
    extraGroups = [
      "wheel"          # sudo
      "networkmanager" # управление сетью
      "video"          # яркость экрана
      "audio"          # звук
      "input"          # устройства ввода
      "docker"         # Docker (если установлен)
    ];
    shell = pkgs.zsh;  # Оболочка по умолчанию
  };
  programs.zsh.enable = true;  # Включить Zsh для системы

  # ══════════════════════════════════════════════════════════════════════════════
  # PACKAGES — Системные пакеты
  # ══════════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # ── Базовые утилиты ──────────────────────────────────────────────────────
    vim                   # Текстовый редактор
    wget curl             # Скачивание файлов
    unzip                 # Распаковка архивов

    # ── Диагностика железа ───────────────────────────────────────────────────
    pciutils              # lspci — PCI устройства
    usbutils              # lsusb — USB устройства
    lshw                  # Полная информация о железе

    # ── Файловые системы ─────────────────────────────────────────────────────
    btrfs-progs           # Утилиты BTRFS
    ntfs3g                # Монтирование Windows NTFS дисков

    # ── Hyprland Desktop ─────────────────────────────────────────────────────
    quickshell            # Quickshell (для кастомных конфигов)
    # quickshell          # Removed: managed by noctalia module
    waybar                # Верхняя панель
    wofi                  # Лаунчер приложений (Super+D)
    dunst                 # Уведомления
    hyprpaper             # Обои рабочего стола
    hyprlock              # Экран блокировки
    hypridle              # Автоблокировка при бездействии
    wlogout               # Меню выхода/перезагрузки

    # ── Терминалы ────────────────────────────────────────────────────────────
    kitty                 # Основной терминал (конфиг в ~/nixos/dotfiles/kitty/)
    alacritty             # Запасной терминал

    # ── Скриншоты и буфер обмена ─────────────────────────────────────────────
    grim                  # Скриншоты Wayland
    slurp                 # Выбор области экрана
    swappy                # Редактор скриншотов
    wl-clipboard          # Буфер обмена Wayland
    cliphist              # История буфера обмена

    # ── Медиа и управление ───────────────────────────────────────────────────
    brightnessctl         # Яркость экрана
    playerctl             # Управление медиаплеером
    pamixer               # Управление громкостью
    pavucontrol           # GUI настройки звука

    # ── Файловый менеджер ────────────────────────────────────────────────────
    nautilus              # GNOME Files
    polkit_gnome          # Окна авторизации
  ];
}

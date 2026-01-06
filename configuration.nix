# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  NixOS Configuration — matebook (Huawei MateBook X Pro)                      ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║                                                                              ║
# ║  Главный файл конфигурации системы NixOS.                                    ║
# ║                                                                              ║
# ║  СТРУКТУРА:                                                                  ║
# ║  ─────────────────────────────────────────────────────────────────────────── ║
# ║  1. Imports    — configs/network, configs/hardware                           ║
# ║  2. System     — hostname, stateVersion                                      ║
# ║  3. Nix        — flakes, gc, unfree                                          ║
# ║  4. Boot       — systemd-boot, LUKS, Plymouth                                ║
# ║  5. Filesystem — BTRFS subvolumes, swap, zram                                ║
# ║  6. Hardware   — firmware                                                    ║
# ║  7. Desktop    — Hyprland, PipeWire, fonts, polkit                           ║
# ║  8. Locale     — timezone, языки, клавиатура                                 ║
# ║  9. User       — пользователь                                                ║
# ║  10. Packages  — системные утилиты                                           ║
# ║                                                                              ║
# ║  СИСТЕМНЫЕ ПАКЕТЫ:                                                           ║
# ║  ─────────────────────────────────────────────────────────────────────────── ║
# ║  vim          — текстовый редактор                                           ║
# ║  wget, curl   — скачивание файлов                                            ║
# ║  unzip        — распаковка архивов                                           ║
# ║  pciutils     — lspci (просмотр PCI устройств)                               ║
# ║  usbutils     — lsusb (просмотр USB устройств)                               ║
# ║  lshw         — информация о железе                                          ║
# ║  btrfs-progs  — утилиты BTRFS                                                ║
# ║  ntfs3g       — монтирование NTFS дисков                                     ║
# ║                                                                              ║
# ║  DESKTOP ПАКЕТЫ:                                                             ║
# ║  ─────────────────────────────────────────────────────────────────────────── ║
# ║  waybar       — верхняя панель                                               ║
# ║  wofi         — лаунчер приложений                                           ║
# ║  dunst        — уведомления                                                  ║
# ║  hyprpaper    — обои                                                         ║
# ║  hyprlock     — экран блокировки                                             ║
# ║  hypridle     — автоблокировка при бездействии                               ║
# ║  wlogout      — меню выхода/перезагрузки                                     ║
# ║  grim         — скриншоты                                                    ║
# ║  slurp        — выбор области экрана                                         ║
# ║  swappy       — редактор скриншотов                                          ║
# ║  wl-clipboard — буфер обмена Wayland                                         ║
# ║  cliphist     — история буфера обмена                                        ║
# ║  brightnessctl— управление яркостью                                          ║
# ║  playerctl    — управление медиаплеером                                      ║
# ║  pamixer      — управление громкостью                                        ║
# ║  nautilus     — файловый менеджер                                            ║
# ║  polkit_gnome — окна авторизации                                             ║
# ║  pavucontrol  — настройки звука                                              ║
# ║                                                                              ║
# ║  ПАРОЛЬ: passwd alxr                                                         ║
# ║                                                                              ║
# ║  КОМАНДЫ:                                                                    ║
# ║  rebuild  — sudo nixos-rebuild switch --flake ~/nixos#matebook               ║
# ║  test     — sudo nixos-rebuild test --flake ~/nixos#matebook                 ║
# ║  update   — nix flake update ~/nixos                                         ║
# ║  clean    — sudo nix-collect-garbage -d && nix-collect-garbage -d            ║
# ║                                                                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, ... }:

{
  imports = [
    ./configs/network
    ./configs/hardware
  ];

  # System
  networking.hostName = "matebook";
  system.stateVersion = "25.05";

  # Nix
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
    gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 14d"; };
  };
  nixpkgs.config.allowUnfree = true;

  # Boot
  boot.loader = {
    systemd-boot = { enable = true; configurationLimit = 10; editor = false; };
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-partlabel/primary";
    preLVM = true;
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "quiet" "splash" "mitigations=auto"
    "iwlwifi.power_save=0" "iwlwifi.uapsd_disable=1" "iwlmvm.power_scheme=1"
  ];

  boot.plymouth = { enable = true; theme = "breeze"; };
  boot.initrd.systemd.enable = true;
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  # Filesystem
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd" "noatime" ];
  };

  fileSystems."/swap" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [ "subvol=@swap" "noatime" "ssd" ];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [ "subvol=@snapshots" "compress=zstd:1" "noatime" "ssd" "discard=async" "space_cache=v2" ];
  };

  swapDevices = [{ device = "/swap/swapfile"; size = 18 * 1024; }];
  zramSwap = { enable = true; algorithm = "zstd"; memoryPercent = 100; };
  services.btrfs.autoScrub = { enable = true; interval = "monthly"; fileSystems = [ "/" ]; };

  # Hardware
  hardware.firmware = [ pkgs.linux-firmware ];
  hardware.enableRedistributableFirmware = true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Desktop (Hyprland)
  programs.hyprland = { enable = true; xwayland.enable = true; };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  };

  # Auto-mount & File management
  services.gvfs.enable = true; # Nautilus needs this for trash and mounting
  services.udisks2.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  security.polkit.enable = true;
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

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

  # Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono nerd-fonts.fira-code
      inter roboto noto-fonts noto-fonts-color-emoji font-awesome
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

  # Locale
  time.timeZone = "Asia/Yekaterinburg";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { LC_TIME = "ru_RU.UTF-8"; LC_MONETARY = "ru_RU.UTF-8"; };
    supportedLocales = [ "en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" ];
  };
  console = { font = "Lat2-Terminus16"; useXkbConfig = true; };
  services.xserver.xkb = { layout = "us,ru"; options = "grp:alt_shift_toggle"; };

  # User
  services.getty.autologinUser = "alxr";
  users.users.alxr = {
    isNormalUser = true;
    description = "Aleksandr";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" "docker" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    vim wget curl unzip
    pciutils usbutils lshw btrfs-progs ntfs3g
    waybar wofi dunst hyprpaper hyprlock hypridle wlogout
    grim slurp swappy wl-clipboard cliphist
    brightnessctl playerctl pamixer nautilus polkit_gnome pavucontrol
  ];
}

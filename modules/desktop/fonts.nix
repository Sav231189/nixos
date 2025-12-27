# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Модуль: Шрифты (Fonts)                                                      ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Настройка шрифтов системы для красивого отображения текста.                 ║
# ║                                                                              ║
# ║  УСТАНОВЛЕННЫЕ ШРИФТЫ:                                                       ║
# ║  • JetBrains Mono Nerd Font — для терминала и кода (с иконками)              ║
# ║  • Fira Code — альтернативный шрифт для кода с лигатурами                    ║
# ║  • Inter — современный UI шрифт для интерфейсов                              ║
# ║  • Noto Fonts — полное покрытие Unicode (все языки + emoji)                  ║
# ║  • Font Awesome — иконки для Waybar и других приложений                      ║
# ║                                                                              ║
# ║  НАСТРОЙКИ РЕНДЕРИНГА:                                                       ║
# ║  • Subpixel rendering для LCD мониторов                                      ║
# ║  • Hinting для чёткости при малых размерах                                   ║
# ║  • Антиалиасинг для сглаживания                                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    
    packages = with pkgs; [
      # Nerd Fonts (icons + programming fonts)
      # В nixpkgs-unstable используется новый формат nerd-fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.caskaydia-cove  # CascadiaCode в nerd-fonts
      
      # System fonts
      inter              # Modern UI font
      roboto             # Google's font
      noto-fonts         # Unicode coverage
      noto-fonts-emoji   # Emoji
      noto-fonts-cjk-sans # Chinese/Japanese/Korean
      
      # Code fonts
      jetbrains-mono
      fira-code
      
      # Icons
      font-awesome
      material-design-icons
    ];

    fontconfig = {
      enable = true;
      
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Inter" "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" "Fira Code" ];
        emoji = [ "Noto Color Emoji" ];
      };
      
      # Subpixel rendering for LCD
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      
      # Better font rendering
      hinting = {
        enable = true;
        style = "slight";
      };
      
      antialias = true;
    };
  };
}

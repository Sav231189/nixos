# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Theme — GTK, Qt, Cursor                                                     ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║                                                                              ║
# ║  Глобальные темы для приложений:                                             ║
# ║  • GTK (Firefox, Nautilus, и др.) — Adwaita Dark                             ║
# ║  • Qt (Dolphin, VLC, и др.) — Adwaita Dark                                   ║
# ║  • Cursor — Adwaita                                                          ║
# ║  • Icons — Papirus Dark                                                      ║
# ║                                                                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, pkgs, lib, ... }:

{
  gtk = {
    enable = true;
    theme = { name = "Adwaita-dark"; package = pkgs.gnome-themes-extra; };
    iconTheme = { name = "Papirus-Dark"; package = pkgs.papirus-icon-theme; };
    cursorTheme = { name = "Adwaita"; size = 24; };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = { name = "adwaita-dark"; package = pkgs.adwaita-qt; };
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };
}

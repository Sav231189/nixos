# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Модуль: Аудио (PipeWire)                                                    ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Настройка звуковой системы на базе PipeWire.                                ║
# ║                                                                              ║
# ║  ЧТО ТАКОЕ PIPEWIRE:                                                         ║
# ║  Современная замена PulseAudio и JACK. Низкая задержка, поддержка            ║
# ║  Bluetooth, совместимость со старыми приложениями.                           ║
# ║                                                                              ║
# ║  ЧТО НАСТРАИВАЕТСЯ:                                                          ║
# ║  • PipeWire — основной аудио сервер                                          ║
# ║  • ALSA — низкоуровневый доступ к звуковым картам                            ║
# ║  • PulseAudio — совместимость со старыми приложениями                        ║
# ║  • JACK — для профессиональной работы со звуком                              ║
# ║                                                                              ║
# ║  УПРАВЛЕНИЕ ЗВУКОМ:                                                          ║
# ║  pavucontrol — графический микшер                                            ║
# ║  pamixer -i 5  — увеличить громкость на 5%                                   ║
# ║  pamixer -d 5  — уменьшить громкость на 5%                                   ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, ... }:

{
  # Disable PulseAudio (updated syntax for 2025)
  services.pulseaudio.enable = false;
  
  # Enable PipeWire
  security.rtkit.enable = true;  # Realtime scheduling
  
  services.pipewire = {
    enable = true;
    
    # Audio
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    
    # JACK support (for audio production)
    jack.enable = true;
    
    # Low latency settings
    extraConfig.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 2048;
      };
    };
  };

  # Audio control packages
  environment.systemPackages = with pkgs; [
    pavucontrol    # PulseAudio volume control (GUI)
    pwvucontrol    # PipeWire volume control (GUI)
    helvum         # PipeWire patchbay
    easyeffects    # Audio effects (equalizer, etc.)
  ];
}

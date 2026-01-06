# NixOS Configuration

Конфигурация NixOS для **Huawei MateBook X Pro**.

## 📁 Структура

```
nixos/
├── flake.nix               # Точка входа
├── configuration.nix       # NixOS: system, boot, desktop
├── home.nix                # Home Manager: user config
└── configs/
    ├── dev/                # Git, браузеры, CLI утилиты
    ├── hardware/           # Intel GPU, power, touchpad
    ├── hypr/               # Hyprland, Waybar, Wofi, Dunst
    ├── network/            # WiFi, Bluetooth, DNS
    ├── shell/              # Zsh, Starship, алиасы
    ├── terminal/           # Kitty + Alacritty
    └── theme/              # GTK, Qt, Cursor
```

## 🚀 Команды

```bash
# Сборка и применение
rebuild     # sudo nixos-rebuild switch --flake ~/nixos#matebook

# Тест без применения
test        # sudo nixos-rebuild test --flake ~/nixos#matebook

# Обновление flake
update      # nix flake update ~/nixos

# Очистка старых версий
clean       # sudo nix-collect-garbage -d && nix-collect-garbage -d
```

## 🔧 Первая установка

```bash
# 1. Клонировать репозиторий
git clone <repo> ~/nixos

# 2. Собрать систему
sudo nixos-rebuild switch --flake ~/nixos#matebook

# 3. Установить пароль
passwd alxr

# 4. Перезагрузиться
reboot
```

## ⌨️ Горячие клавиши Hyprland

| Клавиша | Действие |
|---------|----------|
| `Super + Return` | Терминал (Kitty) |
| `Super + D` | Лаунчер (Wofi) |
| `Super + B` | Браузер (Firefox) |
| `Super + E` | Файловый менеджер |
| `Super + Q` | Закрыть окно |
| `Super + F` | Полноэкранный режим |
| `Super + Space` | Плавающий режим |
| `Super + 1-0` | Рабочие столы |
| `Super + Shift + 1-0` | Переместить окно |
| `Print` | Скриншот области |
| `Shift + Print` | Скриншот всего экрана |

## 🎨 Тема

**Catppuccin Mocha**
- Фон: `#1e1e2e`
- Акцент: `#cba6f7`
- Текст: `#cdd6f4`

## 📦 Что включено

### Система (configuration.nix)
- systemd-boot + LUKS шифрование
- BTRFS с subvolumes + zram
- Hyprland + PipeWire
- Intel GPU драйвера

### Пользователь (home.nix)
- Zsh + Starship + fzf + zoxide
- Kitty + Alacritty
- Waybar + Wofi + Dunst
- Git + Lazygit + GitHub CLI
- Firefox + Chromium
- Современные CLI: ripgrep, fd, bat, eza, btop

## 📝 TODO

- [ ] Добавить email в git config (`configs/dev/default.nix`)
- [ ] Выбрать один терминал (Kitty или Alacritty)
- [ ] Настроить hyprpaper (обои)

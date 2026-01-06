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

## 📀 Чистая установка с шифрованием

> ⚠️ **ВНИМАНИЕ**: Все данные на диске будут удалены!

### 1. Подготовка диска

Переходим в root и находим наш диск:
```bash
sudo -i
lsblk  # Например, nvme0n1
DISK=/dev/nvme0n1
```

Разметка (1GB для Boot, остальное под LUKS):
```bash
parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MB 1024MB
parted $DISK -- set 1 esp on
parted $DISK -- mkpart primary 1024MB 100%
```

Форматирование:
```bash
mkfs.fat -F 32 -n BOOT ${DISK}p1
cryptsetup luksFormat ${DISK}p2
cryptsetup open ${DISK}p2 cryptroot
mkfs.btrfs -L nixos /dev/mapper/cryptroot
```

### 2. Монтирование

```bash
mount /dev/mapper/cryptroot /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@swap
btrfs subvolume create /mnt/@snapshots
umount /mnt

mount -o subvol=@,compress=zstd,noatime /dev/mapper/cryptroot /mnt
mkdir -p /mnt/{home,boot,swap,.snapshots}
mount -o subvol=@home,compress=zstd,noatime /dev/mapper/cryptroot /mnt/home
mount -o subvol=@swap,noatime /dev/mapper/cryptroot /mnt/swap
mount -o subvol=@snapshots,compress=zstd,noatime /dev/mapper/cryptroot /mnt/.snapshots
mount ${DISK}p1 /mnt/boot
```

### 3. Установка системы

Клонируем конфигурацию:
```bash
mkdir -p /mnt/etc/nixos
git clone https://github.com/Sav231189/nixos /mnt/etc/nixos/temp
cp -r /mnt/etc/nixos/temp/* /mnt/etc/nixos/
rm -rf /mnt/etc/nixos/temp
```

Генерируем конфигурацию железа (чтобы UUID дисков прописались сами!):
```bash
nixos-generate-config --root /mnt
```

> **ВАЖНО**: Проверь `/mnt/etc/nixos/configuration.nix`. Убедись, что там НЕТ дублирующихся строк `fileSystems`, если они уже есть в `hardware-configuration.nix`. В нашем репо `fileSystems` вынесены, так что конфликтов быть не должно.

Запускаем установку:
```bash
nixos-install --flake /mnt/etc/nixos#matebook
```

После завершения:
```bash
reboot
```

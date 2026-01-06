# NixOS Configuration

Конфигурация NixOS для **Huawei MateBook X Pro**.

## 📁 Структура

```
nixos/
├── flake.nix               # Точка входа
├── configuration.nix       # NixOS: system, boot, desktop
├── hardware-configuration.nix  # Автогенерируемый при установке
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

---

## 📀 Чистая установка с шифрованием

> ⚠️ **ВНИМАНИЕ**: Все данные на диске будут удалены!

### Шаг 1. Загрузка с Live USB

1. Скачай NixOS ISO: https://nixos.org/download
2. Запиши на флешку (Rufus / `dd`)
3. Загрузись с флешки
4. Подключи WiFi:
   ```bash
   sudo systemctl start NetworkManager
   nmtui  # или nmcli device wifi connect "SSID" password "PASSWORD"
   ```

### Шаг 2. Разметка диска

```bash
# Переходим в root
sudo -i

# Определяем диск (обычно nvme0n1 или sda)
lsblk
DISK=/dev/nvme0n1

# Создаём разделы: 1GB для Boot, остальное под LUKS
parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MB 1024MB
parted $DISK -- set 1 esp on
parted $DISK -- mkpart primary 1024MB 100%
```

### Шаг 3. Шифрование и форматирование

```bash
# Boot раздел (FAT32, без шифрования)
mkfs.fat -F 32 -n BOOT ${DISK}p1

# Шифруем основной раздел (запомни пароль!)
cryptsetup luksFormat ${DISK}p2
cryptsetup open ${DISK}p2 cryptroot

# Создаём BTRFS
mkfs.btrfs -L nixos /dev/mapper/cryptroot
```

### Шаг 4. Создание subvolumes и монтирование

```bash
# Создаём subvolumes
mount /dev/mapper/cryptroot /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@swap
btrfs subvolume create /mnt/@snapshots
umount /mnt

# Монтируем для установки
mount -o subvol=@,compress=zstd,noatime /dev/mapper/cryptroot /mnt
mkdir -p /mnt/{home,boot,swap,.snapshots}
mount -o subvol=@home,compress=zstd,noatime /dev/mapper/cryptroot /mnt/home
mount -o subvol=@swap,noatime /dev/mapper/cryptroot /mnt/swap
mount -o subvol=@snapshots,compress=zstd,noatime /dev/mapper/cryptroot /mnt/.snapshots
mount ${DISK}p1 /mnt/boot
```

### Шаг 5. Клонирование конфигурации

```bash
# Клонируем репозиторий
git clone https://github.com/Sav231189/nixos /mnt/etc/nixos
```

### Шаг 6. Генерация hardware-configuration.nix

```bash
# Генерируем конфигурацию железа (UUID дисков пропишутся автоматически!)
nixos-generate-config --root /mnt
```

> ℹ️ Эта команда создаст `/mnt/etc/nixos/hardware-configuration.nix` с правильными UUID для LUKS и BTRFS. Файл `configuration.nix` уже его импортирует.

**Проверка:** Убедись, что оба файла на месте:
```bash
ls -la /mnt/etc/nixos/
# Должны быть: configuration.nix, hardware-configuration.nix, flake.nix, home.nix, configs/
```

### Шаг 7. Установка

```bash
cd /mnt/etc/nixos
git add .
nixos-install --flake .#matebook
```

После установки система попросит установить пароль root.

### Шаг 8. Перезагрузка

```bash
reboot
```

После загрузки:
```bash
# Установи пароль пользователя
passwd alxr

# Запусти Hyprland
Hyprland
```

---

## 📝 TODO

- [ ] Добавить email в git config (`configs/dev/default.nix`)
- [ ] Выбрать один терминал (Kitty или Alacritty)
- [ ] Настроить hyprpaper (обои)

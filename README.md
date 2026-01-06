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
| `Print` | Скриншот области |

---

##  Чистая установка с шифрованием

> ⚠️ **ВНИМАНИЕ**: Все данные на диске будут удалены!

---

### Шаг 1. WiFi

```bash
sudo systemctl start NetworkManager
```

```bash
nmtui
```

---

### Шаг 2. Стать root

```bash
sudo -i
```

---

### Шаг 3. Определить диск

```bash
lsblk
```

```bash
DISK=/dev/nvme0n1
```

---

### Шаг 4. Разметка диска

```bash
parted $DISK -- mklabel gpt
```

```bash
parted $DISK -- mkpart ESP fat32 1MB 1024MB
```

```bash
parted $DISK -- set 1 esp on
```

```bash
parted $DISK -- mkpart primary 1024MB 100%
```

```bash
partprobe $DISK
```

```bash
lsblk
```

> Убедись, что видны `nvme0n1p1` и `nvme0n1p2`

---

### Шаг 5. Форматирование Boot

```bash
mkfs.fat -F 32 -n BOOT ${DISK}p1
```

---

### Шаг 6. Шифрование (запомни пароль!)

```bash
cryptsetup luksFormat ${DISK}p2
```

```bash
cryptsetup open ${DISK}p2 cryptroot
```

---

### Шаг 7. Создание BTRFS

```bash
mkfs.btrfs -L nixos /dev/mapper/cryptroot
```

---

### Шаг 8. Создание subvolumes

```bash
mount /dev/mapper/cryptroot /mnt
```

```bash
btrfs subvolume create /mnt/@
```

```bash
btrfs subvolume create /mnt/@home
```

```bash
btrfs subvolume create /mnt/@swap
```

```bash
btrfs subvolume create /mnt/@snapshots
```

```bash
umount /mnt
```

---

### Шаг 9. Монтирование

```bash
mount -o subvol=@,compress=zstd,noatime /dev/mapper/cryptroot /mnt
```

```bash
mkdir -p /mnt/{home,boot,swap,.snapshots}
```

```bash
mount -o subvol=@home,compress=zstd,noatime /dev/mapper/cryptroot /mnt/home
```

```bash
mount -o subvol=@swap,noatime /dev/mapper/cryptroot /mnt/swap
```

```bash
mount -o subvol=@snapshots,compress=zstd,noatime /dev/mapper/cryptroot /mnt/.snapshots
```

```bash
mount ${DISK}p1 /mnt/boot
```

---

### Шаг 10. Клонирование конфига

```bash
git clone https://github.com/Sav231189/nixos /mnt/etc/nixos
```

---

### Шаг 11. Генерация hardware-configuration.nix

```bash
nixos-generate-config --root /mnt
```

---

### Шаг 12. Проверка

```bash
ls -la /mnt/etc/nixos/
```

> Должны быть: `configuration.nix`, `hardware-configuration.nix`, `flake.nix`, `home.nix`, `configs/`

---

### Шаг 13. Установка

```bash
cd /mnt/etc/nixos
```

```bash
git add .
```

```bash
nixos-install --flake .#matebook
```

> Введи пароль root когда попросит

---

### Шаг 14. Перезагрузка

```bash
reboot
```

---

### Шаг 15. После загрузки

```bash
passwd alxr
```

```bash
Hyprland
```

---

## 📝 TODO

- [ ] Добавить email в git config
- [ ] Настроить hyprpaper (обои)

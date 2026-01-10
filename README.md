# NixOS Configuration

Конфигурация NixOS для **Huawei MateBook X Pro**.

---

## 📀 Чистая установка с шифрованием

> ⚠️ **ВНИМАНИЕ**: Все данные на диске будут удалены!

### 1. Подключение к WiFi (если есть)

```bash
sudo systemctl start NetworkManager
nmtui
```

### 2. Разметка диска

```bash
sudo -i
```

```bash
lsblk
```

```bash
DISK=/dev/nvme0n1

parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MB 1024MB
parted $DISK -- set 1 esp on
parted $DISK -- mkpart primary 1024MB 100%
partprobe $DISK
lsblk
```

### 3. Шифрование и форматирование

```bash
mkfs.fat -F 32 -n BOOT ${DISK}p1
cryptsetup luksFormat ${DISK}p2
cryptsetup open ${DISK}p2 cryptroot
mkfs.btrfs -L nixos /dev/mapper/cryptroot
```

### 4. Создание subvolumes

```bash
mount /dev/mapper/cryptroot /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@swap
btrfs subvolume create /mnt/@snapshots
umount /mnt
```

### 5. Монтирование

```bash
mount -o subvol=@,compress=zstd,noatime /dev/mapper/cryptroot /mnt
mkdir -p /mnt/{home,boot,swap,.snapshots}
mount -o subvol=@home,compress=zstd,noatime /dev/mapper/cryptroot /mnt/home
mount -o subvol=@swap,noatime /dev/mapper/cryptroot /mnt/swap
mount -o subvol=@snapshots,compress=zstd,noatime /dev/mapper/cryptroot /mnt/.snapshots
mount ${DISK}p1 /mnt/boot
```

### 6. Клонирование и генерация конфига

```bash
git clone https://github.com/Sav231189/nixos /mnt/etc/nixos
nixos-generate-config --root /mnt
ls /mnt/etc/nixos/
```

### 7. Установка

```bash
cd /mnt/etc/nixos
git add .
nixos-install --flake .#matebook
```

### 8. После перезагрузки

```bash
reboot
```

После загрузки:
```bash
passwd alxr
Hyprland
```

---

## � Команды для работы

```bash
sudo nixos-rebuild switch --flake ~/nixos#matebook  # Применить изменения
sudo nixos-rebuild test --flake ~/nixos#matebook    # Тест без применения
nix flake update ~/nixos                             # Обновить flake
sudo nix-collect-garbage -d                          # Очистка
```

## ⌨️ Горячие клавиши Hyprland

| Клавиша | Действие |
|---------|----------|
| `Super + Return` | Терминал |
| `Super + D` | Лаунчер |
| `Super + Q` | Закрыть окно |
| `Super + 1-0` | Рабочие столы |
| `Print` | Скриншот |


gpg --keyserver-options auto-key-retrieve --verify archlinux-version-x86_64.iso.sig

cat /sys/firmware/efi/fw_platform_size # verify boot mode, corret result 64
ip address add 10.129.3.254/24 dev ens32
ip route add default via 10.129.3.254 dev ens32

ping archlinux.org
timedatectl

fdisk -l
fdisk /dev/sda
g # convert to gpt
n # new partition
# uefi boot
[default 1]
[default] first sector
+1G # last sector
t
parition number 1
partition type 1
Changed to EFI

# swap
n
default 2
first sector default
last sector +2G
L to list all types
19 linux swap

# system
n
default 3
start default
end default

# verify
p

# write to disk
w

# file systems
mkfs.ext4 /dev/sda3 # root
mkswap /dev/sda2 # swap
mkfs.fat -F 32 /dev/sda1 # efi

mount /dev/sda3 /mnt

# mount efi
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/sda2

pacstrap -K /mnt base linux linux-firmware vim openssh sudo man-db man-pages amd-ucode
 fsck archlinux-keyring curl dig networkmanager

genfstab -U /mnt >> /mnt/etc/fstab

# chroot
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc
# edit /etc/locale.gen uncomment en_US.UTF-8
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "arch" > /etc/hostname
mkinitcpio -P
passwd capstone
pacman -S grub efibootmgr amd-ucode
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
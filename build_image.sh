#!/bin/bash

set -e

# Diretórios temporários
WORKDIR=$(mktemp -d)
IMAGEDIR="$WORKDIR/image"
mkdir -p "$IMAGEDIR"

# Baixar e extrair Alpine base
wget -q https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/alpine-minirootfs-latest-x86_64.tar.gz -O "$WORKDIR/alpine.tar.gz"
tar -xzf "$WORKDIR/alpine.tar.gz" -C "$IMAGEDIR"

# Chroot para instalação de pacotes e configuração
cat <<EOF | chroot "$IMAGEDIR" /bin/sh
apk update
apk add --no-cache xorg-server xf86-video-vesa xf86-input-libinput mesa-gl \
    weston chromium

# Configurações para iniciar automaticamente o navegador
echo "exec chromium --kiosk --disable-infobars --noerrdialogs --disable-session-crashed-bubble --disable-popup-blocking" > /root/.xinitrc
apk del eudev hwids  # Remoção de pacotes desnecessários
exit
EOF

# Compactar o sistema com squashfs
mksquashfs "$IMAGEDIR" "$WORKDIR/alpine-kiosk.squashfs" -comp xz -e boot

# Criar kernel e initramfs customizados
cp "$IMAGEDIR/boot/vmlinuz-virt" "$WORKDIR/vmlinuz"
mkinitfs -c "$WORKDIR/alpine-kiosk.conf" -o "$WORKDIR/initramfs" "$IMAGEDIR"

# Resultado final
cp "$WORKDIR/"{vmlinuz,initramfs,alpine-kiosk.squashfs} ./output/
echo "Imagens criadas em ./output/"

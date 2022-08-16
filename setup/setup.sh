# Copyright (c) 2022 AstreaOS
# /!\ Requires root privileges!

# Update repositories
apt update -y

# Install minimal packages
apt install -y sudo wget curl ufw git

# Install basic desktop enviroment
apt install -y openbox nitrogen tint2 lightdm xorg

systemctl enable lightdm

# Create System Directories
mkdir -p /etc/astreaos
mkdir -p /etc/meteorite

# Create autostart file for openbox
mkdir -p /etc/xdg/openbox/
echo /etc/meteorite/startup > /etc/xdg/openbox/autostart

# Install Meteorite
curl https://raw.githubusercontent.com/AstreaOS/installer/dev/meteorite/meteorite.desktop \
  -o /usr/share/xsessions/meteorite.desktop

curl https://raw.githubusercontent.com/AstreaOS/installer/dev/meteorite/startup \
  -o /etc/meteorite/startup

# Updating Permissions
chmod 0755 /etc/xdg/openbox/autostart
chmod +x /etc/meteorite/startup
chmod +x ./sudo.sh

# Download wallpapers
mkdir -p /tmp/aos_wp
mkdir -p /usr/share/backgrounds/AstreaOS
git clone https://www.github.com/astreaos/wallpapers /tmp/aos_wp
cp /tmp/aos_wp/Wallpapers/* /usr/share/backgrounds/AstreaOS/*

printf "\n\n\(i) You can now reboot.\n\n"
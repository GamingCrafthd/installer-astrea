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
mkdir /etc/astreaos
mkdir /etc/meteorite

# Create autorun file for openbox
echo /etc/meteorite/startup > /etc/xdg/openbox/autorun

# Install Meteorite
curl https://raw.githubusercontent.com/AstreaOS/installer/dev/meteorite/meteorite.desktop \
  -o /usr/share/xsessions/meteorite.desktop

curl https://raw.githubusercontent.com/AstreaOS/installer/dev/meteorite/startup \
  -o /etc/meteorite/startup

printf "\n\n(!) You can now reboot.\n\n"
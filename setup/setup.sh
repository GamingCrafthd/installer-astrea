# Copyright (c) 2022 AstreaOS
# /!\ Requires root privileges!

# Update repositories
apt update -y

# Install minimal packages
apt install -y sudo wget curl ufw git

# Install basic desktop enviroment
apt install -y openbox nitrogen tint2 lightdm xorg

# Install Meteorite
# soon(tm)
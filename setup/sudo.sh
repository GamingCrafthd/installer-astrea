#!/bin/bash
# Copyright (c) 2022 AstreaOS
# /!\ Requires execution using the root account!

# Print password creation message
printf "\nPlease enter a password for the admin account.\n\n"

# Create the admin user
sudo useradd admin -M -s /bin/bash
passwd admin

# Give admin sudo privileges
sudo usermod -aG sudo admin

# Display success message
printf "\n\n(i) Script finished.\n(i) You can now log into the admin account using \"su admin\""
printf "\n    If you want to give your own user sudo rights, log into the admin account and run \"sudo usermod -aG sudo <username>\"\n\n"

#!/bin/bash
# Copyright (c) 2022 AstreaOS
# /!\ Requires execution using the root account!

# Print password creation message
printf "\n\nPlease enter a password after the prompt\n\n"

# Create the admin user
sudo useradd admin -M -s /bin/bash
passwd admin

# Give admin sudo privileges
sudo usermod -aG sudo admin

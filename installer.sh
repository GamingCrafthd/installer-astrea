#!/bin/bash
# Copyright (c) 2022 - AstreaOS
# Set up the AstreaOS desktop!

# Set column variable for banner
columns=$(tput cols)
# Specify script options
options=("Install AstreaOS" "Uninstall Packages" "Create User" "Logs" "Quit")

# Colors
error_col="\033[0;31m"
warning_col="\033[0;33m"
info_col="\033[96m"
success_col="\033[1;32m"
reset_col="\033[0m"
bold_col="\033[1m"
italic_col="\033[3m"
underline_col="\033[4m"
strike_col="\033[9m"

# Package list
dependencies="sudo wget curl ufw git"
de_packages="openbox nitrogen tint2 lightdm xorg xcompmgr"

# System directories
system_dirs="/etc/astreaos, /etc/meteorite, /etc/xdg/openbox, /usr/share/backgrounds/AstreaOS"

# Define show and hide cursor shortcuts
show_cursor() {
    printf '\e[?25h'
}
hide_cursor() {
    printf '\e[?25l'
}

exit_error() {
    show_cursor
    echo -e "\n"
    printf %${columns}s | tr " " "="
    echo -e "${error_col}(i) Error! Please check above log for more info.\n${reset_col}" >> /dev/stderr
    exit 1
}

#start_script() {
     # Figure out the current operating system to figure out weather to run the script.
      #case "$OSTYPE" in
        #linux*)
            #script()
        #;;
        # Everything else.
        #*)
            #echo -e "\e[91mYou need to be on AstreaOS to be able to use this command!"
            #exit
        #;;
    #esac
#}

if [ "$EUID" -ne 0 ]
then
show_cursor
printf %${columns}s | tr " " "="
echo -e "\n\033[45m🪐 AstreaOS Setup Script\033[0m"
echo -e "${error_col}Please run this script as root.${reset_col}"
printf %${columns}s | tr " " "="
exit 126
fi

startup() {
    show_cursor
    printf %${columns}s | tr " " "="
    echo -e "\n\033[45m🪐 AstreaOS Installer\033[0m"
    echo -e "Please select an option."
    printf %${columns}s | tr " " "="

    echo -e "\n\n${info_col}(1) Install AstreaOS${reset_col}"
    echo -e "This installs the AstreaOS linux distro."
    echo -e "${info_col}(2) Uninstall Packages${reset_col}"
    echo -e "This uninstalls all packages installed by this installer."
    echo -e "${info_col}(3) Create User${reset_col}"
    echo -e "Creates a user with optional admin permissions."
    echo -e "${info_col}(4) Logs${reset_col}"
    echo -e "Prints out the previous log."
    echo -e "${info_col}(5) Quit${reset_col}"
    echo -e "Quits out of the installer safely.\n"
}

refresh_log() {
    if [ -f /var/log/astrea-setup.log ]
    then
        mv /var/log/astrea-setup.log /var/log/astrea-setup.log.old
    fi
}

startup

select opt in "${options[@]}"
do
   case $opt in
            "Install AstreaOS")
                refresh_log
                hide_cursor
                echo -e "${info_col}Installing system dependencies...${reset_col}"
                {
                    apt-get -y update || exit_error
                    apt-get -y install ${dependencies} || exit_error
                } &>> /var/log/astrea-setup.log

                echo -e "${info_col}Installing desktop environment...${reset_col}"
                {
                    apt-get -y install ${de_packages} || exit_error
                    systemctl enable lightdm || exit_error
                } &>> /var/log/astrea-setup.log

                echo -e "${info_col}Creating system directories...${reset_col}"
                {
                    mkdir -p ${system_dirs} || exit_error
                } &>> /var/log/astrea-setup.log

                echo -e "${info_col}Downloading system files...${reset_col}"
                {
                    echo -e "# Copyright (c) 2022 AstreaOS\n# Edit following file for configuration." || exit_error
                    echo /etc/meteorite/startup > /etc/xdg/openbox/autostart || exit_error
                    curl https://raw.githubusercontent.com/AstreaOS/installer/dev/meteorite/meteorite.desktop \
                        -o /usr/share/xsessions/meteorite.desktop || exit_error
                    curl https://raw.githubusercontent.com/AstreaOS/installer/dev/meteorite/startup \
                        -o /etc/meteorite/startup || exit_error
                } &>> /var/log/astrea-setup.log

                echo -e "${info_col}Downloading wallpapers...${reset_col}"
                {
                    mkdir -p /tmp/aos-wp || exit_error
                    git clone https://www.github.com/astreaos/wallpapers /tmp/aos-wp || exit_error
                    mv /tmp/aos-wp/Wallpapers/* /usr/share/backgrounds/AstreaOS || exit_error
                    rm -rf /tmp/aos-wp || exit_error
                } &>> /var/log/astrea-setup.log

                echo -e "${info_col}Setting permissions...${reset_col}"
                {
                    chmod 0755 /etc/xdg/openbox/autostart || exit_error
                    chmod +x /etc/meteorite/startup || exit_error
                } &>> /var/log/astrea-setup.log

                echo -e "${success_col}Installation successful!${reset_col}"
                echo -e "${warning_col}${bold_col}(i) Rebooting in 5 seconds...${reset_col}"
                sleep 5
                sudo reboot
                startup
                ;;
            "Uninstall Packages")
                refresh_log
                hide_cursor
                echo -e "${info_col}Removing system directories...${reset_col}"
                {
                    rm -rf ${system_dirs} || exit_error
                } &>> /var/log/astrea-setup.log
                #####
                echo -e "${info_col}Removing desktop environment...${reset_col}"
                {
                    systemctl disable lightdm || exit_error
                    apt-get -y remove ${de_packages} || exit_error
                } &>> /var/log/astrea-setup.log
                #####
                echo -e "${info_col}Removing system dependencies...${reset_col}"
                {
                    apt-get -y remove ${dependencies} || exit_error
                    apt-get -y autoremove || exit_error
                } &>> /var/log/astrea-setup.log

                echo -e "${success_col}Uninstall successful!${reset_col}"
                echo -e "${warning_col}${bold_col}(i) Rebooting in 5 seconds...${reset_col}"
                sleep 5
                reboot
                ;;
            "Create User")
                hide_cursor
                if ! command -v sudo &> /dev/null
                then
                    echo -e "${error_col}(i) Error! You need to install AstreaOS first.${reset_col}"
                    show_cursor
                    exit 1
                fi
                ######
                echo -e "${info_col}Create a user...${reset_col}"
                show_cursor
                read -p $'\033[96mChoose a username: \033[0m' create_user
                read -s -p $'\033[96mEnter new password: \033[0m' create_password
                sudo useradd ${create_user}
                echo -e "${create_user}:${create_password}" | sudo chpasswd
                ######
                echo -e "${info_col}\nChoose one of the following shells:\n${reset_col}"
                grep -v -e "#" -e '^$' -e '^$' /etc/shells
                read -p $'\033[96mType in your desired shell: \033[0m' choose_shell
                sudo usermod --shell ${choose_shell} ${create_user}
                ######
                read -p $'\033[96mShould this user be a sudoer? \033[0m[y/n] ' choose_sudoer
                if [ "$choose_sudoer" == "y" ]
                then
                    sudo usermod -aG sudo ${create_user}
                    echo -e "${success_col}'${create_user}' is now a sudoer!${reset_col}"
                else
                    echo -e "${warning_col}'${create_user}' won't be a sudoer!${reset_col}"
                fi
                ######
                echo -e "${success_col}User created successfully!${reset_col}"
                startup
                ;;
            "Logs")
                cat /var/log/astrea-setup.log
                startup
                ;;
            "Quit")
                echo -e "${success_col}Goodbye!${reset_col}"
                exit
                ;;
            *) echo -e "${error_col}(i) Error: '$REPLY' is an invalid option.${reset_col}"
    esac
done
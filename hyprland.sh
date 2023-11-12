#!/bin/bash

# Script based on https://github.com/SolDoesTech/HyprV4 By SolDoesTech

PREP_STAGE=(
    hyprland
    dunst
    wezterm
    dolphin
    wofi
    xdg-desktop-portal-hyprland
    qt5-wayland
    qt5ct
    qt5-svg
    qt5-quickcontrols2
    qt5-graphicaleffects
    qt6-wayland
    qt6ct
    gtk3 
    pipewire 

    wireplumber 
    wl-clipboard 
    cliphist 
    python-requests 
    pacman-contrib
)

NVIDIA_STAGE=(
    linux-headers 
    nvidia-dkms 
    nvidia-settings 
    libva 
    libva-nvidia-driver-git
)

INSTALL_STAGE=(
    # mako 
    waybar
    swww 
    swaylock-effects 
    wofi 
    rofi
    beautyline
    wlogout 
    xdg-desktop-portal-hyprland 
    swappy 
    grim 
    slurp 
    thunar 
    btop
    chromium
    mpv
    pamixer 
    pavucontrol 
    brightnessctl 
    bluez 
    bluez-utils 
    blueman 
    network-manager-applet 
    gvfs 
    thunar-archive-plugin 
    file-roller
    papirus-icon-theme 
    ttf-meslo-nerd
    ttf-jetbrains-mono-nerd 
    noto-fonts-emoji 
    lxappearance 
    xfce4-settings
    nwg-look-bin
    sddm
)

CNT="[\e[1;36mNOTE\e[0m]"
COK="[\e[1;32mOK\e[0m]"
CER="[\e[1;31mERROR\e[0m]"
CAT="[\e[1;37mATTENTION\e[0m]"
CWR="[\e[1;35mWARNING\e[0m]"
CAC="[\e[1;33mACTION\e[0m]"
INSTLOG="install.log"

show_progress() {
    while ps | grep $1 &> /dev/null;
    do
        echo -n "."
        sleep 2
    done
    echo -en "Done!\n"
    sleep 2
}

install_software() {
    if yay -Q $1 &>> /dev/null ; then
        echo -e "$COK - $1 is already installed."
    else
        echo -en "$CNT - Now installing $1 ."
        yay -S --noconfirm $1 &>> $INSTLOG &
        show_progress $!

        if yay -Q $1 &>> /dev/null ; then
            echo -e "\e[1A\e[K$COK - $1 was installed."
        else
            echo -e "\e[1A\e[K$CER - $1 install had failed, please check the install.log"
            exit
        fi
    fi
}

clear

echo -e "$CNT - You are about to execute a script that would attempt to setup Hyprland.
Please note that Hyprland is still in Beta."
sleep 1

echo -e "$CNT - Checking for Physical or VM..."
ISVM=$(hostnamectl | grep Chassis)
echo -e "Using $ISVM"
if [[ $ISVM == *"vm"* ]]; then
    echo -e "$CWR - Please note that VMs are not fully supported and if you try to run this on
    a Virtual Machine there is a high chance this will fail."
    sleep 1
fi

echo -e "$CNT - This script will run some commands that require sudo. You will be prompted to enter your password.
If you are worried about entering your password then you may want to review the content of the script."
sleep 1

read -rep $'[\e[1;33mACTION\e[0m] - Would you like to continue with the install (y,n) ' CONTINST
if [[ $CONTINST == "y" ]]; then
    echo -e "$CNT - Setup starting..."
    sudo touch /tmp/hyprv.tmp
else
    echo -e "$CNT - This script will now exit, no changes were made to your system."
    exit
fi

if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
    ISNVIDIA=true
else
    ISNVIDIA=false
fi

read -rep $'[\e[1;33mACTION\e[0m] - Would you like to disable WiFi powersave? (y,n) ' WIFI
if [[ $WIFI == "y" ]]; then
    LOC="/etc/NetworkManager/conf.d/wifi-powersave.conf"
    echo -e "$CNT - The following file has been created $LOC.\n"
    echo -e "[connection]\nwifi.powersave = 2" | sudo tee -a $LOC &>> $INSTLOG
    echo -en "$CNT - Restarting NetworkManager service, Please wait."
    sleep 2
    sudo systemctl restart NetworkManager &>> $INSTLOG
    
    for i in {1..6}; do
        echo -n "."
        sleep 1
    done
    echo -en "Done!\n"
    sleep 2
    echo -e "\e[1A\e[K$COK - NetworkManager restart completed."
fi

read -rep $'[\e[1;33mACTION\e[0m] - Do you want to check/install yay ? (y,n) ' YAY
if [[ $YAY == "y" ]]; then
    if [ ! -f /sbin/yay ]; then  
        echo -en "$CNT - Configuring yay."
        git clone https://aur.archlinux.org/yay-bin &>> $INSTLOG
        cd yay
        makepkg -si --noconfirm &>> ../$INSTLOG &
        show_progress $!
        if [ -f /sbin/yay ]; then
            echo -e "\e[1A\e[K$COK - yay configured"
            cd ..
            
            echo -en "$CNT - Updating yay."
            yay -Syu --noconfirm &>> $INSTLOG &
            show_progress $!
            echo -e "\e[1A\e[K$COK - yay updated."
        else
            echo -e "\e[1A\e[K$CER - yay install failed, please check the install.log"
            exit
        fi
    fi
fi

read -rep $'[\e[1;33mACTION\e[0m] - Would you like to install the packages? (y,n) ' INST
if [[ $INST == "y" ]]; then
    echo -e "$CNT - Prep Stage - Installing needed components, this may take a while..."
    for SOFTWR in ${PREP_STAGE[@]}; do
        install_software $SOFTWR 
    done

    if [[ "$ISNVIDIA" == true ]]; then
        echo -e "$CNT - Nvidia GPU support setup stage, this may take a while..."
        for SOFTWR in ${NVIDIA_STAGE[@]}; do
            install_software $SOFTWR
        done
    
        sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
        sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
        echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf &>> $INSTLOG
    fi

    echo -e "$CNT - Installing Hyprland, this may take a while..."
    if [[ "$ISNVIDIA" == true ]]; then
        if yay -Q hyprland &>> /dev/null ; then
            yay -R --noconfirm hyprland &>> $INSTLOG &
        fi
        install_software hyprland-nvidia
    else
        install_software hyprland
    fi

    echo -e "$CNT - Installing main components, this may take a while..."
    for SOFTWR in ${INSTALL_STAGE[@]}; do
        install_software $SOFTWR 
    done

    echo -e "$CNT - Starting the Bluetooth Service..."
    sudo systemctl enable --now bluetooth.service &>> $INSTLOG
    sleep 2

    echo -e "$CNT - Enabling the SDDM Service..."
    sudo systemctl enable sddm &>> $INSTLOG
    sleep 2
    
    echo -e "$CNT - Cleaning out conflicting xdg portals..."
    yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk &>> $INSTLOG
fi

read -rep $'[\e[1;33mACTION\e[0m] - Would you like to copy config files? (y,n) ' CFG
if [[ $CFG == "y" ]]; then
    echo -e "$CNT - Copying config files..."

    mkdir -p ~/.config/
    ln -sf _hypr ~/.config/hypr

    for DIR in $(\ls _hypr -D || tr "\n" " "); do
        if [[ $DIR == _* ]]; then
            continue
        fi

        ln -sf $PWD/_hypr/$DIR ~/.config/$DIR
        echo "Symlinked $DIR into ~/.config folder"
    done

    # add the Nvidia env file to the config (if needed)
    if [[ "$ISNVIDIA" == true ]]; then
        echo -e "\nsource = ~/.config/_hypr_utils/env_var_nvidia.conf" >> _hypr/hypr/hyprland.conf
    fi

    echo -e "$CNT - Setting up the login screen."
    sudo cp -R _hypr/_sdt /usr/share/sddm/themes/sdt
    sudo chown -R $USER:$USER /usr/share/sddm/themes/sdt
    sudo mkdir /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent=sdt" | sudo tee -a /etc/sddm.conf.d/10-theme.conf &>> $INSTLOG
    WLDIR=/usr/share/wayland-sessions
    if [ -d "$WLDIR" ]; then
        echo -e "$COK - $WLDIR found"
    else
        echo -e "$CWR - $WLDIR NOT found, creating..."
        sudo mkdir $WLDIR
    fi 
    
    sudo cp _hypr_utils/hyprland.desktop /usr/share/wayland-sessions/

    # setup the first look and feel as dark
    # xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
    # xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
    # gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    # gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
    # cp -f ~/.config/HyprV/backgrounds/v4-background-dark.jpg /usr/share/sddm/themes/sdt/wallpaper.jpg
fi

echo -e "$CNT - Script had completed!"
if [[ "$ISNVIDIA" == true ]]; then 
    echo -e "$CAT - Since we attempted to setup an Nvidia GPU the script will now end and you should reboot.
    Please type 'reboot' at the prompt and hit Enter when ready."
    exit
fi

read -rep $'[\e[1;33mACTION\e[0m] - Would you like to start Hyprland now? (y,n) ' HYP
if [[ $HYP == "y" ]]; then
    exec sudo systemctl start sddm &>> $INSTLOG
else
    exit
fi

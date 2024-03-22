if [[ $(uname) -ne "Darwin" ]]; then
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    gsettings set org.gnome.desktop.interface icon-theme "BeautyLine"
    xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
fi

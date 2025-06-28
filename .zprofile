if [[ $(uname) == "Linux" ]]; then
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    gsettings set org.gnome.desktop.interface icon-theme "BeautyLine"
    [[ $(which xfconf-query 2>&1 > /dev/null) ]] && xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
    [ -f ~/.zshrc ] && source ~/.zshrc
fi

echo -e "[Unity-for-Arch]\nSigLevel = Optional TrustAll\nServer = http://dl.dropbox.com/u/486665/Repos/$repo/$arch" > /etc/pacman.conf
echo -e "[Unity-for-Arch-Extra]\nSigLevel = Optional TrustAll\nServer = http://dl.dropbox.com/u/486665/Repos/$repo/$arch" > /etc/pacman.conf

pacman -Syu
pacman -S $(pacman -Slq Unity-for-Arch)
pacman -S $(pacman -Slq Unity-for-Arch-Extra)
pacman -S lightdm-ubuntu

echo -e "exec unity" > ~/.xinitrc

systemctl enable lightdm-ubuntu
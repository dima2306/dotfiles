#!/bin/bash

echo "----Firstly let's update dnf cache:----"
dnf update -y

echo "----Adding Anydesk repository----"
cat > /etc/yum.repos.d/AnyDesk-Fedora.repo << "EOF" 
[anydesk]
name=AnyDesk Fedora - stable
baseurl=http://rpm.anydesk.com/fedora/$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
EOF

echo "----Adding Sublime configuration----"
echo "----Installing the GPG key:----"
rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

echo "----Adding stable challenge configuration----"
dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

echo "----Adding Visual Studio Code key & repository:----"
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

echo "----Adding Playonlinux repository----"
wget http://rpm.playonlinux.com/playonlinux.repo -P /etc/yum.repos.d/
echo "----Downloading Playonlinux:----"
wget http://rpm.playonlinux.com/playonlinux-yum-4-1.noarch.rpm
echo "----Installing Playonlinux:----"
rpm -Uvh playonlinux-yum-4-1.noarch.rpm

echo "----Adding Virtualbox key & repository----"
wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo -P /etc/yum.repos.d/


echo "----Configure RPMfusion Repository----"
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "----Updating dnf cache:----"
dnf check-update -y

echo "----Downloading Dbeaver:----"
wget https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm
echo "----Installing Dbeaver:----"
rpm -Uvh ./dbeaver-ce-latest-stable.x86_64.rpm

echo "----Downloading Mailspring:----"
wget https://updates.getmailspring.com/download?platform=linuxRpm
echo "----Installing Mailspring:----"
rpm -Uvh ./download?platform=linuxRpm.rpm

echo "----Installing Development Tools:----"
dnf install -y @development-tools kernel-devel kernel-headers dkms qt5-qtx11extras elfutils-libelf-devel zlib-devel
# During the VirtualBox package installation, the installer created a group called vboxusers, all system users who are going to use USB devices from Oracle VM VirtualBox guests must be a member of that group.
# usermod -a -G vboxusers $USER

echo "----Installing httpd:----"
dnf install -y httpd
echo "----Adding httpd server to autostart and starting the service:----"
systemctl enable --now httpd
echo "----Enabling HTTP requests through firewall on '80' port:----"
firewall-cmd --permanent --add-service=http
echo "----Reloading firewall service for changes to take effect:----"
firewall-cmd --reload

echo "----Installing MariaDB:----"
dnf install -y mariadb-server
echo "----Adding MariaDB server to autostart and starting the service:----"
systemctl enable --now mariadb
#echo "----configuring mysql root user----"
sudo mysql -Be "GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY 'toor' WITH GRANT OPTION; FLUSH PRIVILEGES; exit;"

echo "----Installing PHP & phpmyadmin:----"
dnf install -y php php-mysqlnd phpMyAdmin

echo "----Restarting Apache server:----"
systemctl restart httpd

echo "----Installing all other packages:----"
dnf install -y anydesk nano mc ffmpeg ffmpeg-devel stacer fuse-exfat fira-code-fonts sublime-text timeshift code gimp git htop nodejs okular vlc unrar screenfetch redis remmina ImageMagick php-bcmath php-common php-gd php-json php-mbstring php-mysqlnd php-pear php-pecl-imagick php-pecl-xdebug php-xml

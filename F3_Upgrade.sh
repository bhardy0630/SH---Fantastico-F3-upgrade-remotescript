#!/bin/bash
if [[ -f '/usr/local/cpanel/version' ]]
then
   echo "cPanel installed, proceeding..."
else
   echo "cPanel not installed, quitting installation - Install cPanel first!"
   exit 1
fi

if [ -a /usr/local/cpanel/base/frontend/x/cells/fantastico.html ]
then
echo "Detected Fantastico De Luxe installation, removing..."
cd /var/cpanel/registered_cpanelplugins
cp -p Fantastico_De_Luxe Fantastico_De_Luxe.cpanelplugin
/usr/local/cpanel/bin/unregister_cpanelplugin Fantastico_De_Luxe.cpanelplugin
rm -f /var/cpanel/registered_cpanelplugins/Fantastico_De_Luxe.cpanelplugin
rm -rf /var/netenberg/fantastico_de_luxe/
rm -rf /usr/local/cpanel/whostmgr/docroot/cgi/fantastico/
rm -rf /usr/local/cpanel/3rdparty/fantastico
rm -rf /usr/local/cpanel/base/frontend/*/fantastico
rm -f /usr/local/cpanel/base/frontend/x/cells/fantastico.html
rm -f /usr/local/cpanel/base/frontend/x/cells/cpanelplugin_Fantastico_De_Luxe.html
rm -f /usr/local/cpanel/whostmgr/docroot/cgi/addon_fantastico.cgi
echo "Fantastico De Luxe files removed, removing De Luxe cronjob..."
crontab -u root -l | grep -v 'fantastico/scripts/'  | crontab -u root -
echo "De Luxe removed, proceeding with F3 install..."
fi

if [[ `rpm -qa | grep wget` ]]
then
echo "wget is installed - continuing..."
else
echo "wget not installed, installing wget then continuing..."
yum -y install wget
fi

echo "Grabbing and installing Fantastico F3..."
cd /root
wget http://174.120.165.106/fantastico_f3/install.sh
sh install.sh
echo "Finished F3 install, confirming licensing..."
cd /var/netenberg/fantastico_f3/sources
/usr/local/cpanel/3rdparty/bin/php index.php license
echo "If the above does not show this IP as passing, license main IP (device eth0) manually per Wiki."
echo "Cleaning up install script..."
rm -f /root/install.sh
echo "Cleanup complete, post install now running..."
cd /var/netenberg/fantastico_f3/sources
/usr/local/cpanel/3rdparty/bin/php index.php optimize
/usr/local/cpanel/3rdparty/bin/php index.php scripts
echo Fantastico installation completed\!

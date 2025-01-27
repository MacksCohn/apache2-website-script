#!/bin/bash
echo Installing apache2...
sudo apt update -y
sudo apt install apache2
sudo rm -rf /var/www/html
echo Installing rpl for renaming...
sudo apt install rpl

export SITE_LOCATION="/var/www/building"
echo Using environment variable SITE_LOCATION with current value $SITE_LOCATION

echo Making folder for the website...
sudo mkdir $SITE_LOCATION

echo Copying config for site to /etc/apache2/sites-available/
sudo cp buildings-site.conf /etc/apache2/sites-available/
sudo cp index.html $SITE_LOCATION

echo Modifying buildings-site.conf to have the proper address.
rpl "/var/www/hosting" $SITE_LOCATION /etc/apache2/sites-available/buildings-site.conf

echo Enabling the website...
sudo a2ensite buildings-site.conf
sudo a2dissite 000-default.conf

echo Enabling mod for https ssl...
sudo a2enmod ssl

echo Reloading apache2...
sudo service apache2 reload

echo Generating OpenSSl certificate, Please answer questions...
sudo mkdir /etc/apache2/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/test.com.key -out /etc/apache2/ssl/test.com.crt

echo Starting up website:
sudo service apache2 reload

echo Complete.
echo The site is now active, place the unity build files at the location $SITE_LOCATION

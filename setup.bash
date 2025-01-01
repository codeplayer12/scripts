#!/bin/bash
# Update the local repositories
sudo apt update -y

# Upgrade the system to the latest packages
sudo apt upgrade -y


# Installing Nginx Server
sudo apt install nginx

#  Installing the Mariadb php and mysql server
# Note change the php-fpm in the wordpress configuration to match the installed version
# to check run `ls /var/run/php`
sudo apt install mariadb-server php-mysql php-fpm

# Dowloading lates wordpress into the www folder
cd /var/www/
sudo rm latest.tar.gz
sudo wget http://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sudo rm latest.tar.gz

# Change User and file permissions of wordpress files
sudo chown -R www-data:www-data wordpress/
sudo find wordpress/ -type d -exec chmod 755 {} \;
sudo find wordpress/ -type f -exec chmod 644 {} \;

echo 'To Change the password for mysql type *** sudo mysql_secure_installation **** else it will remain empty password' 
sleep(10s)

# Setup User and Database with default credentials for example user
# Can change the user, password and database to your own for your wordpress site
mysql -u root -p
create database example_db default character set utf8 collate utf8_unicode_ci;
create user 'example_user'@'localhost' identified by 'example_pw';
grant all privileges on example_db.* TO 'example_user'@'localhost';
flush privileges
exit;

# Link the wordpress cinfig to become the default location for the nginx landing page
sudo mv /webconfig/worpress.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled

#Check if no errors are found in the worpress configuration
sudo nginx -t

#Restart webserver
sudo systemctl restart nginx
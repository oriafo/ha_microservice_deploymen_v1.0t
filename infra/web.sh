#!/bin/bash -xe
exec > /tmp/script_output.log 2>&1 
sleep 10
sudo apt update
sudo apt install wget unzip -y
sudo apt install nginx -y
sudo ufw allow 'Nginx HTTP'
sudo ufw status
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
cd /tmp 
wget https://www.tooplate.com/zip-templates/2137_barista_cafe.zip
# if [ -f "2137_barista_cafe.zip" ]; then
sudo mkdir -p /var/www/html
sudo unzip -o 2137_barista_cafe.zip /var/www/html
sudo cp -r /var/www/html/2137_barista_cafe/* /var/www/html
sudo nginx -s reload
sudo systemctl restart nginx
# else
    # echo "Something went wrong while downloading the file"
# fi



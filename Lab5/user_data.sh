#!/bin/bash
sudo apt update
sudo apt install apache2 -y
instance_id= 'curl http://169.254.169.254/latest/meta-data/instance-id'
echo "Hello $$instance_id" >> /var/www/html/index.html
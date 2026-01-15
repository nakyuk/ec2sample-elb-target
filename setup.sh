#!/bin/bash
sudo cp -r html/* /var/www/html/
sudo cp -r cgi-bin/* /var/www/cgi-bin/
sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.orign
sudo cp httpd.conf /etc/httpd/conf/httpd.conf
cd /var/www/cgi-bin/timeout/
sudo mv timeout.cgi index.cgi
sudo mkdir {1..999}
for i in {1..999} ; do sudo cp index.cgi ${i}/ ; done
sudo chown -R apache:apache /var/www/*
sudo chmod -R 755 /var/www/cgi-bin/*
sudo service httpd start
sudo chkconfig httpd on

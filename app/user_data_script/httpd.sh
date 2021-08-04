#!/bin/bash

sudo yum -y install httpd
sudo service httpd start
echo "<html><h1>Hello from whithin private EC2 instance.You are directed here via load balancer</h1></html>" > /var/www/html/hello.html    
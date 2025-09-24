#!/bin/bash
yum install -y httpd awscli
sleep 5
aws s3 sync s3://project-website-bucket1 /var/www/html/ --region ap-south-1
sleep 5
echo $(hostname) >> /var/www/html/index.html
service httpd restart
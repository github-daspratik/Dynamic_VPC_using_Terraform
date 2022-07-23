Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
cd /var/www/html
/bin/echo "<html><style>body{background-color: green;}</style><body><h1><b><i> Hello Gurus, I am host with public identity $(curl -s http://169.254.169.254/latest/meta-data/public-hostname), public-ip of $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4), local-ip of $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4) and located in AZ $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone) </i></b></h1></body></html>" > /var/www/html/index.html
--//

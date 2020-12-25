locals {
  user_data = <<EOF
  #!/bin/bash
  sudo yum update -y 
  sudo yum upgrade -y
  sudo yum install telnet mysql -y
  sudo yum -y install httpd
  echo "Hello World" > /var/www/html/index.html
  service httpd start
  chkconfig httpd on
  EOF
}

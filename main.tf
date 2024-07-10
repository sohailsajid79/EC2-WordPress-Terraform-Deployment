# AWS Provider
provider "aws" {
  region    = "eu-west-2"
}

# VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "sajid-vpc"
    }
}

# Subnet
resource "aws_subnet" "subnet" {
    vpc_id      = aws_vpc.main.id
    cidr_block  = "10.0.1.0/24"
    tags = {
        Name = "sajid-subnet"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
  
}

# Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.igw.id
  }
}

# Route Table Association with Subnet
resource "aws_route_table_association" "rta" {
  subnet_id         = aws_subnet.subnet.id
  route_table_id    = aws_route_table.rt.id
}

# Security Group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id

  # Ingress rule to allow HTTP traffic on port 80 from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule to allow SSH traffic on port 22 from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sajid-security-group"
  }
}


# Allocate Elastic IP
resource "aws_eip" "eip" {
    domain = "vpc" 
}

# Associate Elastic IP
resource "aws_eip_association" "eip_assoc" {
    instance_id     = aws_instance.web.id
    allocation_id   = aws_eip.eip.id 
}

# Launch the EC2 instance, configure to install and run WordPress
resource "aws_instance" "web" {
    ami             = "ami-079bd1a083298389f" # Amazon Linux 2 AMI
    instance_type   = "t2.micro"
    subnet_id       = aws_subnet.subnet.id
    #security_groups = [aws_security_group.sg.name]
    vpc_security_group_ids = [aws_security_group.sg.id] # security group IDs
    key_name = "ssh_key"

    user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd php mysql php-mysql
              cd /var/www/html
              wget http://wordpress.org/latest.tar.gz
              tar -xvzf latest.tar.gz
              cp -r wordpress/* /var/www/html/
              rm -rf wordpress latest.tar.gz
              chown -R apache:apache /var/www/html/
              systemctl enable httpd
              systemctl start httpd
              EOF

    tags = {
        Name = "wordpress-server"
    }
}
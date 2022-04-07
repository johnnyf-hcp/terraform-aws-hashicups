terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.8.0"
    }
  }
}

provider "aws" {
  region  = var.region
}

# Latest Amazon LINUX 2 AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# limit SSH, HTTP and API (8080) ports to my IP
resource "aws_security_group" "hashicups-sg" {
  name = "${var.prefix}-${var.environment}-hashicups-sg"

  ingress {
    from_port   = 8222
    to_port     = 8222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.prefix}-${var.environment}-hashicups-sg"
  }
}

# Provision in default VPC and subnet.  Make sure the routing tables provide internet access
resource "aws_instance" "hashicups-docker-server" {
  ami                         = "${data.aws_ami.amazon-linux-2.id}"
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_role_name
  instance_type               = var.instance_type
  key_name                    = var.keypair
  vpc_security_group_ids      = ["${aws_security_group.hashicups-sg.id}"]
  user_data = templatefile("${path.module}/configs/deploy_app.tpl", {})

  tags = {
    Name = "${var.prefix}-${var.environment}-hashicups-app"
    Owner = "${var.prefix}"
    Purpose = "Field Demo"
    Environment = "${var.environment}"
  }
}

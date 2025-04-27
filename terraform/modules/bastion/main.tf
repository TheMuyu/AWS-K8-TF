# 1. Create SSH key pair
resource "tls_private_key" "bastion_tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# resource "local_file" "bastion_private_key" {
#   content         = tls_private_key.bastion_tls.private_key_pem
#   filename        = "${path.module}/bastion_key.pem"
#   file_permission = "0600"
# }

resource "aws_key_pair" "bastion_key" {
  key_name   = var.key_name
  public_key = tls_private_key.bastion_tls.public_key_openssh
}

# 2. Bastion SG
resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Allow SSH access"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Later restrict to my IPs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# 4. Bastion EC2
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.bastion_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "task-ce-bastion"
  }
}


resource "aws_security_group" "jenkins_sg" {
  name        = "Jenkins-Security-Group"
  description = "Open 22, 80, 443, 8080, 9000, 3000"

  dynamic "ingress" {
    for_each = [22, 80, 443, 8080, 9000, 3000]
    content {
      description      = "Allow traffic on port ${ingress.value}"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-sg"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0f403e3180720dd7e"
  instance_type          = "t2.large"
  key_name               = "Amazon-app-key"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  user_data              = file("./install_jenkins.sh")

  tags = {
    Name = "Jenkins-sonar"
  }

  root_block_device {
    volume_size = 30
  }
}

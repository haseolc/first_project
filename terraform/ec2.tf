data "aws_security_group" "ssh_sg" {
  name = var.ssh_sg_name
}

data "aws_security_group" "web_sg" {
  name = var.web_sg_name
}

resource "aws_instance" "AWS_ec2_sg_7th_room" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.key_pair_name

  subnet_id = data.aws_subnets.public_az_a.ids[0]

  vpc_security_group_ids = [
    data.aws_security_group.ssh_sg.id,
    data.aws_security_group.web_sg.id
  ]

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
    delete_on_termination = true

    tags = {
      Name = "${var.instance_name}_root_volume"
    }
  }

  # MySQL 설치
  user_data = <<-EOF
              #!/bin/bash
              sudo dnf install -y mysql
              EOF

  tags = {
    Name        = var.instance_name
    Environment = var.environment
    Project     = "infra-auto"
  }
}


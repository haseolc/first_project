data "aws_security_group" "ec2_sg" {
  name = var.ec2_sg_name
}

resource "aws_instance" "ec2_7th_room" {
  ami                         = var.ami_id # data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  associate_public_ip_address = var.associate_public_ip

  subnet_id = data.aws_subnets.public_az_a.ids[0]

  vpc_security_group_ids = [data.aws_security_group.ec2_sg.id]

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

  tags = {
    Name        = var.instance_name
    Environment = var.environment
    Project     = var.project
  }
}

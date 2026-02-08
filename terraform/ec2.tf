/*
  EC2 생성
*/
resource "aws_instance" "AWS_ec2_sg_7th_room" {
  ami           = data.aws_ami.amazon_linux_2023.id      # 아마존 리눅스 2023 최신 AMI
  instance_type = "t3.small"                             # 인스턴스 타입
  subnet_id     = data.aws_subnets.default.ids[0]        # 퍼블릭 서브넷
  associate_public_ip_address = true                     # Public IP 자동 할당
  vpc_security_group_ids = [aws_security_group.sg_7th_room.id, aws_security_group.web-sg.id]   # 보안 그룹 적용
  key_name      = "infra-dev-key"                           # 키페어 이름
  #infra-dev-key
  tags = {
    Name = "AWS_ec2_sg_7th_room"
  }
}

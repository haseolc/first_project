/*
  EC2 생성 (7팀 메인 서버)
*/
resource "aws_instance" "AWS_ec2_sg_7th_room" {
  ami           = data.aws_ami.amazon_linux_2023.id         # 아마존 리눅스 2023 최신 AMI
  instance_type = "t3.small"                                # 인스턴스 타입 (RAM 2GB)
  subnet_id     = data.aws_subnets.default.ids[0]           # 퍼블릭 서브넷
  associate_public_ip_address = true                         # Public IP 자동 할당
  
  # 보안 그룹 적용 (관리자용 + 웹 서비스용)
  vpc_security_group_ids = [
    aws_security_group.sg_7th_room.id, 
    aws_security_group.web-sg.id
  ]
  
  key_name = "7th_room-key"                                 # 키페어 이름

  # ★ [보안/인프라 최적화] 루트 디스크 용량 설정 (20GB)
  root_block_device {
    volume_size           = 20       # 2GB에서 20GB로 증설하여 서비스 안정성 확보
    volume_type           = "gp3"    # 최신 고성능 범용 SSD 타입
    iops                  = 3000     # gp3 기본 성능
    throughput            = 125      # gp3 기본 성능
    delete_on_termination = true     # 인스턴스 삭제 시 볼륨도 함께 삭제 (비용 방지)
    
    tags = {
      Name = "AWS_ec2_sg_7th_room_root_volume"
    }
  }

  tags = {
    Name = "AWS_ec2_sg_7th_room"
  }
}
/*
  Outputs 주소 정보
*/

output "room7_public_ip" {
  value = aws_instance.AWS_ec2_sg_7th_room.public_ip # 7th-room 서버 접속용
}
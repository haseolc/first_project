/*
  AMI 데이터 소스 및 AWS Provider 설정
*/
# 자동으로 아마존 리눅스2 AMI 최신 이미지 가져오기
data "aws_ami" "amazon_linux_2023" {		               # data → 기존 리소스를 참조
  most_recent = true			                         # 최신 AMI 선택
  owners      = ["amazon"]                         # 공식 Amazon 계정 AMI만 선택

  filter {
    name   = "name"                                # 이름 기준 필터
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]        # Amazon Linux 2, 64비트, GP2 볼륨
  }
}

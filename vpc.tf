# 기본 서브넷 중 하나를 자동으로 가져오기
# vpc.tf 상단에 추가
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
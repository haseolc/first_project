# 가용영역 목록 조회
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC 조회
data "aws_vpc" "default" {
  default = true
}

# AZ a에 있는 public subnet만 조회
data "aws_subnets" "public_az_a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = [data.aws_availability_zones.available.names[0]] # AZ a 할당 (RDS와 같은 AZ 사용 -> RDS: AZ a private subnet)
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

# ---------- 발표 시 참고 (삭제 예정) ----------

# EC2는 단일 리소스이므로 특정 subnet/AZ를 하드코딩하면
# RDS 등 다른 리소스와 AZ 불일치가 발생할 수 있음.
# 따라서 aws_availability_zones + subnet 필터링을 통해
# 조건에 맞는 subnet을 동적으로 선택한다.

# RDS는 DB Subnet Group을 사용하므로,
# Terraform으로 의도적으로 생성한 private subnet만 명시적으로 지정한다.
# 이는 하드코딩이 아니라 설계된 네트워크 경계를 명확히 하기 위함이다.

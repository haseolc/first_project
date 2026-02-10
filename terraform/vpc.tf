data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
}

# Default VPC 내에서 첫 번째 AZ의 public subnet을 선택 (public IP 자동 할당되는 서브넷 기대)
data "aws_subnets" "public_az_a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = [data.aws_availability_zones.available.names[0]]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

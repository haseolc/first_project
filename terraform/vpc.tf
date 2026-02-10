data "aws_availability_zones" "available" {
  state = "available"
}

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
    values = [data.aws_availability_zones.available.names[0]]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

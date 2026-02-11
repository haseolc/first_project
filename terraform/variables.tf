variable "region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "ap-northeast-2"
}

#variable "ami_name_pattern" { # AMI 오류나서 주석처리 해놓았습니다.
#  description = "AMI name pattern used to pick the most recent Amazon Linux 2023 x86_64 image."
#  type        = string
#  default     = "al2023-ami-*-x86_64"
#}

# variable "ami_owners" {
#  description = "List of AMI owner accounts. Use ['amazon'] to restrict to official Amazon AMIs."
#  type        = list(string)
#  default     = ["amazon"]
#}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.small"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID (서울 리전)"
  type        = string
  default     = "ami-0dec6548c7c0d0a96"
}

variable "key_pair_name" {
  description = "Existing EC2 Key Pair name in the target region (must already exist in AWS)."
  type        = string
  default     = "infra-dev-key"
}

variable "ssh_sg_name" {
  description = "Existing Security Group name for SSH access."
  type        = string
  default     = "ssh_sg_7th_room"
}

variable "web_sg_name" {
  description = "Existing Security Group name for web/cluster traffic."
  type        = string
  default     = "web_sg_7th_room"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance."
  type        = string
  default     = "AWS_ec2_sg_7th_room"
}

variable "environment" {
  description = "Environment tag (e.g., dev, prod)."
  type        = string
  default     = "dev"
}

variable "project" {
  description = "프로젝트"
  type        = string
  default     = "infra-auto"
}

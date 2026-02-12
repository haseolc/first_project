variable "region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "ap-northeast-2"
}

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

variable "associate_public_ip" {
  description = "Whether to associate a public IPv4 address to the instance in the selected subnet."
  type        = bool
  default     = true
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
  default     = "ec2-7th-room"
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

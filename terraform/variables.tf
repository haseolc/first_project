variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID (서울 리전)"
  type        = string
  default     = "ami-0dec6548c7c0d0a96"
}

variable "key_pair_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "infra-dev-key"
}

variable "associate_public_ip" {
  description = "Associate a public IP with the instance"
  type        = bool
  default     = true
}

variable "ssh_sg_name" {
  description = "SSH access Security Group name"
  type        = string
  default     = "ssh_sg_7th_room"
}

variable "web_sg_name" {
  description = "Web/cluster traffic Security Group name"
  type        = string
  default     = "web_sg_7th_room"
}

variable "instance_name" {
  description = "EC2 instance Name tag"
  type        = string
  default     = "ec2-7th-room-02"
}

variable "environment" {
  description = "EC2 instance Environment tag"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "EC2 instance Project tag"
  type        = string
  default     = "infra-auto"
}

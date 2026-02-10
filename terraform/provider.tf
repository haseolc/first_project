/* 
  AWS Provider 설정
*/

# AWS Provider 설정
provider "aws" {		                               # provider → Terraform과 AWS 연결
  region = var.aws_region                        # 서울 리전 선택
}


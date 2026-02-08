/* 
  AWS Provider 설정
*/

# AWS Provider 설정
provider "aws" {		                               # provider → Terraform과 AWS 연결
  region = "ap-northeast-2"                        # 서울 리전 선택
}
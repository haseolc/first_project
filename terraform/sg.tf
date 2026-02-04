/*
    보안 그룹(Security Group) 설정 파일
*/

# 보안 그룹 생성                       aws_security_group → 방화벽 역할
resource "aws_security_group" "sg_7th_room" { # 그룹명: 7th-room-sg
    vpc_id = data.aws_vpc.default.id  # 기본 VPC에 생성

  ingress {                                  # 들어오는 트래픽 허용
    from_port   = 22                         # SSH 포트
    to_port     = 22
    protocol    = "tcp"                      # TCP 프로토콜
    #cidr_blocks = ["0.0.0.0/0"]              # 모든 IP 허용
    #-> 개인 주소 수기 입력 예정
    cidr_blocks = ["0.0.0.0/32", "0.0.0.0/32", "0.0.0.0/32"]
  }

  egress {                                   # 나가는 트래픽 허용
    from_port   = 0
    to_port     = 0
    protocol    = "-1"                       # 모든 프로토콜
    cidr_blocks = ["0.0.0.0/0"]              # 모든 목적지 허용
  }

  tags = {
    Name = "sg_7th_room"
  }
}

# Web 서버 보안 그룹
resource "aws_security_group" "web-sg" {     # 그룹명: web-sg
    vpc_id = data.aws_vpc.default.id  # 기본 VPC에 생성

  ingress {                                  # 외부에서 HTTP 요청 허용
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    # cidr_blocks = ["0.0.0.0/0"] 
    ##변경 해야함 지정 주소로 변경 해줘야 안전 문제 줄어듬

    # VPC 내부(10.0.0.0/16)에서의 트래픽만 허용
    cidr_blocks = [data.aws_vpc.default.cidr_block]

  }

  # K3s API 서버 (관리용)
  ingress {
    from_port       = 6443
    to_port         = 6443
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_7th_room.id] # 7th-room에서만 접근
  }

  # HTTP/HTTPS (WAF 입구)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # 내부에서 오는 트래픽 허용
  }

  # K3s 내부 통신 (Flannel CNI) - 노드 간 통신 필수
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true # 자기 자신(웹 서버 그룹)끼리는 모든 통신 허용
  }

  ingress {                                  # 7th-room 서버만 SSH 허용
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.sg_7th_room.id]
  }

  egress {                                   # 모든 트래픽 나감 허용
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}
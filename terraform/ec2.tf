resource "aws_security_group" "web_sg" {

  name        = "company-website-sg"
  description = "Allow web and ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30007
    to_port     = 30007
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- IAM Instance Profile for EC2 ---
resource "aws_iam_instance_profile" "company_profile" {
  name = "company-oidc-profile"
  role = "aws-oidc-role"  # This must be your existing IAM role
}

resource "aws_instance" "company_server" {

  ami           = "ami-002dc43e5c8f29c3e"
  instance_type = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.company_profile.name
  key_name = "aws-dev-key"

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

   # Root volume configuration
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

   
  tags = {
    Name = "company-website-server"
  }

}

# resource "aws_ecr_repository" "app_repo" {
#   name                 = "company-backend"
#   force_delete = true
#   image_tag_mutability = "MUTABLE"
 
#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }
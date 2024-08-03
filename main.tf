# Sample Terraform Code

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vulnerable-vpc"
  }
}

resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Overly permissive rule
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Overly permissive rule
  }

  tags = {
    Name = "allow-all"
  }
}

resource "aws_instance" "instance1" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_vpc.main.id

  tags = {
    Name = "vulnerable-instance-1"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket"
  acl    = "public-read"  # Publicly accessible S3 bucket

  tags = {
    Name = "vulnerable-bucket"
  }
}

resource "aws_iam_policy" "example" {
  name = "example-policy"
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",  # Wildcard permissions
      "Resource": "*"
    }
  ]
}
EOF

  tags = {
    Name = "vulnerable-policy"
  }
}
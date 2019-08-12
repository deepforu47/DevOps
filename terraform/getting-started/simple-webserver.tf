provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "example" {
  ami           = "ami-0cfee17793b08a293"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example-ec2-sg.id]
  user_data = <<-EOF
               #!/bin/bash
               echo "Hello, World" > index.html
               nohup busybox httpd -f -p 8080 &
               EOF
  tags = {
    Name = "terraform-example"
  }
}
resource "aws_security_group" "example-ec2-sg" {  // <Provider>_<SG Name>
  name = "terraform-example-instance"    // Name of the security Group

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    // Allow from everything
  }
}

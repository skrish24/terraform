provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "test1" {
  ami                    = "ami-d874e0a0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.Web.id}"]

  user_data = <<-EOF
              #!bin/bash
              echo "Hello World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags {
    Name = "terraform-test"
  }
}

resource "aws_security_group" "Web" {
  name = "terraform-test-instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

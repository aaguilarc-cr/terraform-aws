# Tell Terraform to use AWS and which region
provider "aws" {
  region = "us-east-1"
}

# Upload your public key to AWS
resource "aws_key_pair" "monitor_key" {
  key_name   = "monitor-key"
  public_key = file("~/.ssh/monitor-key.pub")
}

# Create a security group (firewall rules)
resource "aws_security_group" "monitor_sg" {
  name        = "monitor-sg"
  description = "Security group for server monitor"

  # Allow SSH from anywhere (so we can connect)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance (your server in the cloud)
resource "aws_instance" "monitor_server" {
  ami                    = "ami-0d7405d05f836d0d4"  # Ubuntu 20.04 us-east-1
  instance_type          = "t3.micro"               # free tier eligible
  vpc_security_group_ids = [aws_security_group.monitor_sg.id]
  key_name               = aws_key_pair.monitor_key.key_name
  
  tags = {
    Name        = "monitor-server"
    Environment = "learning"
    Project     = "server-health-monitor"
  }
}

# Show the server's public IP after creation
output "server_ip" {
  value = aws_instance.monitor_server.public_ip
}

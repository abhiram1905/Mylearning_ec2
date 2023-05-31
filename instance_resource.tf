resource "aws_instance" "Docker_server" {
  ami = var.ami-abhi
  //subnet_id = var.subnet_id
 subnet_id = aws_subnet.docker_subnet.id
 vpc_security_group_ids      = [aws_security_group.public_access_sg.id]


  instance_type = var.type
  tags          = var.tags

  key_name = "terraform-key"
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./terraform-key.pem")
    host        = self.public_ip

    # depends_on = [null_resource.install_docker]



    

#     provisioner "remote-exec" {
#    inline = [
#       "sudo apt-get update",
#      "curl -fsSL https://get.docker.com -o get-docker.sh",
#     "sudo sh get-docker.sh",
     
#  ]
#   connection {
#     type        = "ssh"
#     host        = self.public_ip
#     user        = "ubuntu"              # Update with the appropriate user on your AMI
#     private_key = file("./terraform-key.pem") # Update with the path to your SSH private key
#   }
}
    }

  #   resource "null_resource" "install_docker" {
  # provisioner "local-exec" {
  #   # command = "curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh"
   
  #   "curl -fsSL https://get.docker.com -o get-docker.sh",
  #   "sudo sh get-docker.sh",
  # }

  




resource "aws_vpc" "docker_VPC" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "docker"
  }
}

resource "aws_subnet" "docker_subnet" {
  vpc_id     = aws_vpc.docker_VPC.id
  cidr_block = "172.16.0.0/24"

  tags = {
    Name = "Main"
  }
}

# resource "aws_subnet" "docker_subnet2" {
#   vpc_id     = aws_vpc.docker_VPC.id
#   cidr_block = "172.16.1.0/24"
#   availability_zone = "us-east-1c"

#   tags = {
#     Name = "Main"
#   }
# }
resource "aws_eip" "demo-eip" {
  instance = aws_instance.Docker_server.id
  vpc      = true
}

resource "aws_eip_association" "demo-eip-association" {
  instance_id   = aws_instance.Docker_server.id
  allocation_id = aws_eip.demo-eip.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.docker_VPC.id

  tags = {
    Name = "main"
  }
}

resource "aws_security_group" "public_access_sg" {
  vpc_id = aws_vpc.docker_VPC.id
# Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  
# SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
    Name = "Web SG"
  }
}

resource "aws_route_table" "docker_table" {
  vpc_id = aws_vpc.docker_VPC.id
}



resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.docker_subnet.id
  
  route_table_id = aws_route_table.docker_table.id
}

resource "aws_route" "docker_route" {
  route_table_id         = aws_route_table.docker_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# provisioner "remote-exec" {
#   inline = [
#     "curl -fsSL https://get.docker.com -o get-docker.sh",
#     "sudo sh get-docker.sh",
#     "sudo usermod -aG docker ubuntu"   # Update 'ubuntu' with the appropriate user on your AMI
#   ]

#    connection {
#     type        = "ssh"
#     host        = self.public_ip
#     user        = "ubuntu"              # Update with the appropriate user on your AMI
#     private_key = file("./terraform-key.pem") # Update with the path to your SSH private key
#   }
# }
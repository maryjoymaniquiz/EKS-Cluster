
# This creates a VPC for EKS
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "maniquiz_eks_vpc"
  }
}

resource "aws_eip" "eks_eip" {
  vpc = true
}

resource "aws_nat_gateway" "eks_nat_gateway" {
  allocation_id = aws_eip.eks_eip.id
  subnet_id     = aws_subnet.eks_public_subnet.id
}

# This creates an internet gateway for the VPC
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "maniquiz_eks_igw"
  }
}

# This creates a public subnet for EKS
resource "aws_subnet" "eks_public_subnet" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "maniquiz_eks_public_subnet"
  }
}

# This creates a private subnet for EKS
resource "aws_subnet" "eks_private_subnet" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "maniquiz_eks_private_subnetter"
  }
}

# This creates a route table for the public subnet
resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = {
    Name = "maniquiz_eks_public_rtbl"
  }
}

# This creates a route table for the private subnet
resource "aws_route_table" "eks_private_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat_gateway.id
  }

  tags = {
    Name = "maniquiz_eks_private_rtbl"
  }
}
# Route table is being associate with the subnets
resource "aws_route_table_association" "eks_public_subnet_association" {
  subnet_id      = aws_subnet.eks_public_subnet.id
  route_table_id = aws_route_table.eks_public_rt.id
}
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.eks_private_subnet.id
  route_table_id = aws_route_table.eks_private_rt.id
}

# This creates a security group for the EKS nodes
resource "aws_security_group" "eks_node_sg" {
  name_prefix = "eks-node-sg-"

  vpc_id = aws_vpc.eks_vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "maniquz_eks_node_sg"
  }
}

# This will show the IDs of the public and private subnets once you run the terraform apply command
output "public_subnet_id" {
  value = aws_subnet.eks_public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.eks_private_subnet.id
}
#######################VPC####################################################
resource "aws_vpc" "this" {
  cidr_block = "172.18.0.0/16"
  tags = {
    Name = "VPC_1"
  }
}
#######################PUBLIC_SUBNET####################################################
resource "aws_subnet" "VPC_Subnet_1" {
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 8, 0)
  availability_zone = "us-east-1a"
  tags = {
    Name = "VPC_Subnet_1_public"
  }
}

resource "aws_subnet" "VPC_Subnet_2" {
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 8, 2)
  availability_zone = "us-east-1b"
  tags = {
    Name = "VPC_Subnet_2_public"
  }
}
#######################PRIVATE_SUBNET####################################################
resource "aws_subnet" "VPC_Subnet_3" {
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 8, 4)
  availability_zone = "us-east-1a"
  tags = {
    Name = "VPC_Subnet_3_private"
  }
}
resource "aws_subnet" "VPC_Subnet_4" {
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 8, 6)
  availability_zone = "us-east-1b"
  tags = {
    Name = "VPC_Subnet_4_private"
  }
}
#######################INTERNET_GATEWAY####################################################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "VPC_INTERNET_GATEWAY_1"
  }
}

/*###################AWS_INSTANCE####################################################
resource "aws_instance" "this" {
  ami           = "ami-0e472933a1395e172"
  instance_type = "t2.micro"
  vpc_id  = aws_vpc.this.id

  tags = {
    Name = "AWS_VPC_INSTANCE_EC2"
  }
}*/
#######################AWS_EIP############################################
resource "aws_eip" "this" {
  
  vpc      = true
  tags = {
    Name = "NAT_GATEWAY_EIP"
  }
}
#######################AWS_NAT_GATEWAY###########################################
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.VPC_Subnet_1.id

  tags = {
    Name = "VPC_NAT_GATEWAY"
  }
}
#######################ROUTE_TABLE_PUBLIC####################################################
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
  tags = {
    Name = "rt_public"
  }
}
#######################ROUTE_TABLE_ASSOCIATION_PUBLIC###########################################
resource "aws_route_table_association" "SUBNET_1_RT" {
  subnet_id      = aws_subnet.VPC_Subnet_1.id
  route_table_id = aws_route_table.rt_public.id
}
resource "aws_route_table_association" "SUBNET_2_RT" {
  subnet_id      = aws_subnet.VPC_Subnet_2.id
  route_table_id = aws_route_table.rt_public.id
}
#####################ROUTE_TABLE_PRIVATE##############################################
resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this.id
  }
  tags = {
    Name = "rt_private"
  }
}
#####################ROUTE_TABLE_ASSOCIATION_PRIVATE##############################################
resource "aws_route_table_association" "SUBNET_3_RT" {
  subnet_id      = aws_subnet.VPC_Subnet_3.id
  route_table_id = aws_route_table.rt_private.id
}
resource "aws_route_table_association" "SUBNET_4_RT" {
  subnet_id      = aws_subnet.VPC_Subnet_4.id
  route_table_id = aws_route_table.rt_private.id
}


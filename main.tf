#vpc

resource "aws_vpc" "zomato-vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  region               = "ap-south-1"
  tags = {
    Name = "zomato-vpc"
  }

}

#subnet

resource "aws_subnet" "zomato-subnet-ap-south-1a" {
  vpc_id                  = aws_vpc.zomato-vpc.id
  cidr_block              = "172.16.0.0/18"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "zomato-subnet-ap-south-1a"
  }
}



resource "aws_subnet" "zomato-subnet-ap-south-1b" {
  vpc_id                  = aws_vpc.zomato-vpc.id
  cidr_block              = "172.16.64.0/18"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "zomato-subnet-ap-south-1"
  }
}

resource "aws_subnet" "zomato-subnet-ap-south-1c" {
  vpc_id                  = aws_vpc.zomato-vpc.id
  cidr_block              = "172.16.128.0/18"
  availability_zone       = "ap-south-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "zomato-subnet-ap-south-c"
  }
}

#zomato-internet-gate-way

resource "aws_internet_gateway" "zomato-internet-gate-way" {
  vpc_id = aws_vpc.zomato-vpc.id

  tags = {
    Name = "zomato-internet-gate-way"
  }
}




# zomato-route-table



resource "aws_route_table" "zomato-route-table-ap-south-1a" {
  vpc_id = aws_vpc.zomato-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.zomato-internet-gate-way.id
  }

  tags = {
    Name = "zomato-route-table-ap-south-1a"
  }
}

#zomato-route-table

resource "aws_route_table" "zomato-route-table-ap-south-1b" {
  vpc_id = aws_vpc.zomato-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.zomato-internet-gate-way.id
  }

  tags = {
    Name = "zomato-route-table-ap-south-1b"
  }
}

resource "aws_route_table" "zomato-route-table-ap-south-1c" {
  vpc_id = aws_vpc.zomato-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.zomato-internet-gate-way.id
  }

  tags = {
    Name = "zomato-route-table-ap-south-1c"
  }
}


#zomato-route-table-assososication

resource "aws_route_table_association" "zomato-route-table-association-ap-south-1a" {
  subnet_id      = aws_subnet.zomato-subnet-ap-south-1a.id
  route_table_id = aws_route_table.zomato-route-table-ap-south-1a.id
}


resource "aws_route_table_association" "zomato-route-table-association-ap-south-1b" {
  subnet_id      = aws_subnet.zomato-subnet-ap-south-1b.id
  route_table_id = aws_route_table.zomato-route-table-ap-south-1b.id
}


resource "aws_route_table_association" "zomato-route-table-association-ap-south-1bc" {
  subnet_id      = aws_subnet.zomato-subnet-ap-south-1c.id
  route_table_id = aws_route_table.zomato-route-table-ap-south-1c.id
}


resource "aws_key_pair" "zomato-key-pair" {
  key_name   = "zomato-key-pair"
  public_key = file("ktm.pub")
}

# zomato-security-group


resource "aws_security_group" "allow_tls" {
  name        = "zomato-security-group"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.zomato-vpc.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 tags = {
    Name = "zomato-security-group"
  }
}

#EC1

# EC2 ap-south-1a

resource "aws_instance" "zomato-ap-south-1a-server" {
  ami                    = "ami-0f19324397f53458f"
  instance_type          = "t3.micro"

  subnet_id              = aws_subnet.zomato-subnet-ap-south-1a.id

  key_name               = aws_key_pair.zomato-key-pair.key_name

  vpc_security_group_ids = [
    aws_security_group.allow_tls.id
  ]

  user_data = file("setup.sh")

  tags = {
    Name = "zomato-ap-south-1a-backend-server"
  }
}



#EC2 ap-south-1b


resource "aws_instance" "zomato-ap-south-1b-server" {
  ami                    = "ami-0f19324397f53458f"
  instance_type          = "t3.micro"

  subnet_id              = aws_subnet.zomato-subnet-ap-south-1b.id

  key_name               = aws_key_pair.zomato-key-pair.key_name

  vpc_security_group_ids = [
    aws_security_group.allow_tls.id
  ]

  user_data = file("setup.sh")

  tags = {
    Name = "zomato-ap-south-1b-backend-server"
  }
}

#ec2-ap-south-1c

resource "aws_instance" "zomato-ap-south-1c-server" {
  ami                    = "ami-0f19324397f53458f"
  instance_type          = "t3.micro"

  subnet_id              = aws_subnet.zomato-subnet-ap-south-1c.id

  key_name               = aws_key_pair.zomato-key-pair.key_name

  vpc_security_group_ids = [
    aws_security_group.allow_tls.id
  ]

  user_data = file("setup.sh")

  tags = {
    Name = "zomato-ap-south-1c-backend-server"
  }
}




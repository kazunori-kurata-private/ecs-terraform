resource "aws_subnet" "public_subnet_1c" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "ap-northeast-1c"
  cidr_block                                     = "10.0.2.0/24"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    Name = "Kurata_subnet_pub1c-01"
  }
  tags_all = {
    Name = "Kurata_subnet_pub1c-01"
  }
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_subnet" "private_subnet_1c" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "ap-northeast-1c"
  cidr_block                                     = "10.0.4.0/24"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    Name = "Kurata_subnet_pri1c-01"
  }
  tags_all = {
    Name = "Kurata_subnet_pri1c-01"
  }
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_subnet" "private_subnet_1a" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "ap-northeast-1a"
  cidr_block                                     = "10.0.3.0/24"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    Name = "Kurata_subnet_pri1a-01"
  }
  tags_all = {
    Name = "Kurata_subnet_pri1a-01"
  }
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_subnet" "public_subnet_1a" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "ap-northeast-1a"
  cidr_block                                     = "10.0.1.0/24"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    Name = "Kurata_subnet_pub1a-01"
  }
  tags_all = {
    Name = "Kurata_subnet_pub1a-01"
  }
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_security_group" "rds_sg" {
  description = "ecs-to-rds"
  ingress = [{
    cidr_blocks      = null
    description      = ""
    from_port        = 3306
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "tcp"
    security_groups  = [aws_security_group.ecs_sg.id]
    self             = false
    to_port          = 3306
  }]
  name   = "ecs-to-rds"
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_security_group" "ecs_sg" {
  description = "Created in ECS Console"
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 443
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 443
    }, {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 80
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 80
    }, {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "ecs-efs"
    from_port        = 2049
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 2049
  }]
  name   = "ecs-test-group"
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_vpc" "test_vpc" {
  assign_generated_ipv6_cidr_block     = false
  cidr_block                           = "10.0.0.0/16"
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  instance_tenancy                     = "default"
  tags = {
    Name = "Kurata_vpc_01"
  }
  tags_all = {
    Name = "Kurata_vpc_01"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    "Name" = "Kurata_rt_pub-01"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    "Name" = "Kurata_rt_pri-01"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    "Name" = "Kurata_igw"
  }
}

resource "aws_route_table_association" "public_subnet_1a_association" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_1c_association" {
  subnet_id      = aws_subnet.public_subnet_1c.id
  route_table_id = aws_route_table.public_rt.id
}

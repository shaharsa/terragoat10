resource "aws_instance" "web_host" {
  # ec2 have plain text secrets in user data
  ami           = "${var.ami}"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
  "${aws_security_group.web-node.id}"]
  subnet_id = "${aws_subnet.web_subnet.id}"
  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMAAA
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=us-west-2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF
  tags = {
    Name      = "${local.resource_prefix.value}-ec2"
    yor_trace = "52a1d269-a73f-45d8-bf60-b96138f2557b"
  }
}

resource "aws_instance" "web_host_2" {
  # ec2 have plain text secrets in user data
  ami           = "${var.ami}"
  instance_type = "t2.nano"

  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMAAA
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=us-west-2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF
  tags = {
    yor_trace = "d6de36b7-988b-46f9-956a-aaa17efcd3b3"
  }
}

resource "aws_instance" "web_host_3" {
  # ec2 have plain text secrets in user data
  ami           = "${var.ami}"
  instance_type = "t3.nano"

  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMAAA
export AWS_DEFAULT_REGION=us-west-2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF
  tags = {
    yor_trace = "6978512a-3525-48f4-bc8d-61295fdcb438"
  }
}

resource "aws_instance" "web_host_no_secret" {
  # ec2 have plain text secrets in user data
  ami           = "${var.ami}"
  instance_type = "t3.nano"

  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF
  tags = {
    yor_trace = "3b3e95ba-44a0-47fa-9191-0cb389ef9c56"
  }
}

resource "aws_instance" "web_host_no_user_data_1" {
  # ec2 have plain text secrets in user data
  ami           = "${var.ami}"
  instance_type = "t3.nano"
  tags = {
    yor_trace = "de8558e6-7db3-4630-97cb-983c3e5a16f7"
  }
}

resource "aws_instance" "web_host_no_user_data_2" {
  # ec2 have plain text secrets in user data
  ami           = "${var.ami}"
  instance_type = "t3.nano"
  tags = {
    yor_trace = "6e17eacd-3d4d-4ad4-b2fe-f97407254cef"
  }
}

resource "aws_instance" "web_host_no_user_data_3" {
  # ec2 have plain text secrets in user data
  ami           = "${var.ami}"
  instance_type = "t3.nano"
  tags = {
    yor_trace = "457574ef-d453-4344-bc64-10e75941c0f1"
  }
}

resource "aws_instance" "web_host_no_user_data_4" {
  # ec2 have plain text secrets in user data
  ami           = "${var.ami}"
  instance_type = "t3.nano"
  tags = {
    yor_trace = "0567a048-a6e0-4aae-9dc1-8f9adfd9622d"
  }
}

resource "aws_instance" "web_host_no_user_data_5" {
  # ec2 have plain text secrets in user data
  ami           = "${var.ami}"
  instance_type = "t3.nano"
  tags = {
    yor_trace = "9353b7eb-90de-4921-b587-c111c4052793"
  }
}

resource "aws_ebs_volume" "web_host_storage" {
  # unencrypted volume
  availability_zone = "${var.availability_zone}"
  #encrypted         = false  # Setting this causes the volume to be recreated on apply 
  size = 1
  tags = {
    Name      = "${local.resource_prefix.value}-ebs"
    yor_trace = "25faf6c9-1bae-4d7e-a426-a36f457e9bb0"
  }
}

resource "aws_ebs_snapshot" "example_snapshot" {
  # ebs snapshot without encryption
  volume_id   = "${aws_ebs_volume.web_host_storage.id}"
  description = "${local.resource_prefix.value}-ebs-snapshot"
  tags = {
    Name      = "${local.resource_prefix.value}-ebs-snapshot"
    yor_trace = "a2810b5f-a357-41ca-897d-5187db0c3458"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.web_host_storage.id}"
  instance_id = "${aws_instance.web_host.id}"
}

resource "aws_security_group" "web-node" {
  # security group is open to the world in SSH port
  name        = "${local.resource_prefix.value}-sg"
  description = "${local.resource_prefix.value} Security Group"
  vpc_id      = aws_vpc.web_vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  depends_on = [aws_vpc.web_vpc]
  tags = {
    yor_trace = "14cb7dec-2597-4c2e-a282-34d1036e8d15"
  }
}

resource "aws_vpc" "web_vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name      = "${local.resource_prefix.value}-vpc"
    yor_trace = "35a92c2a-9430-4718-aa9d-7a22f48466e3"
  }
}

resource "aws_subnet" "web_subnet" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name      = "${local.resource_prefix.value}-subnet"
    yor_trace = "8e00f6ab-f9a7-4229-8248-e95b07572e23"
  }
}

resource "aws_subnet" "web_subnet2" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "172.16.11.0/24"
  availability_zone       = var.availability_zone2
  map_public_ip_on_launch = true

  tags = {
    Name      = "${local.resource_prefix.value}-subnet2"
    yor_trace = "1deb29a6-f9da-4881-8983-29d2989d8a53"
  }
}


resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.web_vpc.id

  tags = {
    Name      = "${local.resource_prefix.value}-igw"
    yor_trace = "0f0cdb52-c9f5-4cc3-93ba-a7547c6421bc"
  }
}

resource "aws_route_table" "web_rtb" {
  vpc_id = aws_vpc.web_vpc.id

  tags = {
    Name      = "${local.resource_prefix.value}-rtb"
    yor_trace = "0804b3e8-0f98-4829-ab46-eabd660eaa49"
  }
}

resource "aws_route_table_association" "rtbassoc" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.web_rtb.id
}

resource "aws_route_table_association" "rtbassoc2" {
  subnet_id      = aws_subnet.web_subnet2.id
  route_table_id = aws_route_table.web_rtb.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.web_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web_igw.id

  timeouts {
    create = "5m"
  }
}


resource "aws_network_interface" "web-eni" {
  subnet_id   = aws_subnet.web_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name      = "${local.resource_prefix.value}-primary_network_interface"
    yor_trace = "9162f085-762c-43b1-a2f1-e743252ecd7f"
  }
}

# VPC Flow Logs to S3
resource "aws_flow_log" "vpcflowlogs" {
  log_destination      = aws_s3_bucket.flowbucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.web_vpc.id

  tags = {
    Name        = "${local.resource_prefix.value}-flowlogs"
    Environment = local.resource_prefix.value
    yor_trace   = "9f9a8db7-b4f6-4bf2-b967-401676ff62ac"
  }
}

resource "aws_s3_bucket" "flowbucket" {
  bucket        = "${local.resource_prefix.value}-flowlogs"
  force_destroy = true

  tags = {
    Name        = "${local.resource_prefix.value}-flowlogs"
    Environment = local.resource_prefix.value
    yor_trace   = "e2f1ba8b-1781-4719-9853-950ce4a059f0"
  }
}

output "ec2_public_dns" {
  description = "Web Host Public DNS name"
  value       = aws_instance.web_host.public_dns
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.web_vpc.id
}

output "public_subnet" {
  description = "The ID of the Public subnet"
  value       = aws_subnet.web_subnet.id
}

output "public_subnet2" {
  description = "The ID of the Public subnet"
  value       = aws_subnet.web_subnet2.id
}

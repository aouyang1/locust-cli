/*
  VPC
*/
resource "aws_vpc" "nginx-test" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "nginx-test"
    }
}

/*
  IGW
*/
resource "aws_internet_gateway" "nginx-test" {
    vpc_id = "${aws_vpc.nginx-test.id}"

    tags {
        Name = "nginx-test"
    }
}

/*
  Public Subnet in VPC
*/
resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.nginx-test.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "us-west-2a"

    tags {
        Name = "nginx-test-public"
    }
}

resource "aws_route_table" "nginx-test" {
    vpc_id = "${aws_vpc.nginx-test.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.nginx-test.id}"
    }

    tags {
        Name = "nginx-test"
    }
}

resource "aws_route_table_association" "nginx-test" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.nginx-test.id}"
}


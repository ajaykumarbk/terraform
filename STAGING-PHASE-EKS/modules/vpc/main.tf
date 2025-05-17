resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({ Name = "${var.name}-vpc" }, var.tags)
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge({ Name = "${var.name}-igw" }, var.tags)
}

# Public Subnets
resource "aws_subnet" "public" {
  for_each = { for i, cidr in var.public_subnet_cidrs : i => cidr }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = "${var.region}${lookup(var.az_suffixes, each.key)}"
  map_public_ip_on_launch = true

  tags = merge({ Name = "${var.name}-public-${each.key}" }, var.tags)
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = { for i, cidr in var.private_subnet_cidrs : i => cidr }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = "${var.region}${lookup(var.az_suffixes, each.key)}"

  tags = merge({ Name = "${var.name}-private-${each.key}" }, var.tags)
}

# Elastic IP for NAT
resource "aws_eip" "nat" {
  count  = length(var.private_subnet_cidrs)
  domain = "vpc"

  tags = merge({ Name = "${var.name}-eip-nat-${count.index}" }, var.tags)
}


# NAT Gateway
resource "aws_nat_gateway" "this" {
  for_each = aws_subnet.public

  allocation_id = aws_eip.nat[tonumber(each.key)].id
  subnet_id     = each.value.id

  tags = merge({ Name = "${var.name}-natgw-${each.key}" }, var.tags)

  depends_on = [aws_internet_gateway.this]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge({ Name = "${var.name}-public-rt" }, var.tags)
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private Route Tables and associations
resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.this.id
  tags   = merge({ Name = "${var.name}-private-rt-${each.key}" }, var.tags)
}

resource "aws_route" "private_nat" {
  for_each               = aws_route_table.private
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

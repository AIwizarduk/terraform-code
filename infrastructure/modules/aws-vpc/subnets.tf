data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
}

data "aws_caller_identity" "current" {
}

resource "aws_subnet" "public" {
  count                   = var.availability_zones[0] == "null" ? length(data.aws_availability_zones.available.names) : length(var.availability_zones)
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[0] == "null" ? data.aws_availability_zones.available.names[count.index] : var.availability_zones[count.index]
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  vpc_id                  = aws_vpc.app_vpc.id
  tags                    = merge({ Name = "${local.prefix}-${var.public_subnet_names[count.index]}" }, { Tier = "public" }, var.public_subnet_tags, local.common_tags)
}

resource "aws_subnet" "private" {
  count             = var.availability_zones[0] == "null" ? length(data.aws_availability_zones.available.names) : length(var.availability_zones)
  availability_zone = var.availability_zones[0] == "null" ? data.aws_availability_zones.available.names[count.index] : var.availability_zones[count.index]
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  vpc_id            = aws_vpc.app_vpc.id
  tags              = merge({ Name = "${local.prefix}-${var.private_subnet_names[count.index]}" }, { Tier = "private" }, var.private_subnet_tags, local.common_tags)
}

resource "aws_route_table" "public" {
  count  = var.availability_zones[0] == "null" ? length(data.aws_availability_zones.available.names) : length(var.availability_zones)
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = merge({ Name = "${local.prefix}-${var.public_subnet_names[count.index]}-routetable" }, local.common_tags)

}

resource "aws_route_table_association" "public" {
  count          = var.availability_zones[0] == "null" ? length(data.aws_availability_zones.available.names) : length(var.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table" "private" {
  count  = var.availability_zones[0] == "null" ? length(data.aws_availability_zones.available.names) : length(var.availability_zones)
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw[count.index].id
  }

  tags = merge({ Name = "${local.prefix}-${var.private_subnet_names[count.index]}-routetable" }, local.common_tags)
}

resource "aws_route_table_association" "private" {
  count          = var.availability_zones[0] == "null" ? length(data.aws_availability_zones.available.names) : length(var.availability_zones)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_eip" "nat" {
  count = var.availability_zones[0] == "null" ? length(data.aws_availability_zones.available.names) : length(var.availability_zones)
  vpc   = true
  tags  = merge({ Name = "${local.prefix}-${var.public_subnet_names[count.index]}-nat-eip" }, local.common_tags)
}

resource "aws_nat_gateway" "gw" {
  count         = var.availability_zones[0] == "null" ? length(data.aws_availability_zones.available.names) : length(var.availability_zones)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags          = merge({ Name = "${local.prefix}-${var.public_subnet_names[count.index]}-nat-gateway" }, local.common_tags)
}
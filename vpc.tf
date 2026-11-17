resource "aws_vpc" "main" {
  instance_tenancy     = "default"
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = merge(var.vpc-tags,
  local.common-tags)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.igw-tags,
    local.common-tags
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.public-sub-cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public-sub-cidr[count.index]
  availability_zone       = local.az-required[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    var.public-sub-tags,
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-public-${split("-", local.az-required[count.index])[2]}"
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.private-sub-cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-sub-cidr[count.index]
  availability_zone = local.az-required[count.index]

  tags = merge(
    var.private-sub-tags,
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-private-${split("-", local.az-required[count.index])[2]}"
    }
  )
}

resource "aws_subnet" "database" {
  count             = length(var.database-sub-cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database-sub-cidr[count.index]
  availability_zone = local.az-required[count.index]

  tags = merge(
    var.database-sub-tags,
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-databse-${split("-", local.az-required[count.index])[2]}"
    }
  )
}
resource "aws_db_subnet_group" "roboshop" {
  name       = local.common-name
  subnet_ids = aws_subnet.database[*].id

  tags = local.common-tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.public-route-tags,
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-public"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.private-route-tags,
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-private"
    }
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.public-route-tags,
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-database"
    }
  )
}

resource "aws_route_table_association" "public-association" {
  count          = length(var.public-sub-cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-association" {
  count          = length(var.private-sub-cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database-association" {
  count          = length(var.database-sub-cidr)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

resource "aws_eip" "main-nat" {
  #instance = aws_instance.web.id
  domain = "vpc"

  tags = merge(var.eip-tags,
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-nat"
    }
  )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main-nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.nat-gw-tags, local.common-tags, {
    Name = "${var.project}-${var.environment}-nat-gw"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.main.id
}

resource "aws_route" "database_route" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.main.id
}
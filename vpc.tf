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
  count                   = lengthA(var.public-sub-cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public-sub-cidr[count.index]
  availability_zone       = local.az-required[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    var.public-sub-tags,
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-public-${spilt("-", local.az-required[count.index])[2]}"
    }
  )
}

resource "aws_subnet" "private" {
  count             = lengthA(var.private-sub-cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-sub-cidr[count.index]
  availability_zone = local.az-required[count.index]

  tags = merge(
    var.private-sub-tags,
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-private-${spilt("-", local.az-required[count.index])[2]}"
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
      Name = "${var.project}-${var.environment}-databse-${spilt("-", local.az-required[count.index])[2]}"
    }
  )
}
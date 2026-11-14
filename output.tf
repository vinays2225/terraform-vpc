output "vpc-id"{
    value=aws_vpc.main.id
}

output "igw-id" {
  value=aws_internet_gateway.igw.id
}

output "subnet-public-id"{
    value=aws_subnet.public.id
}

output "subnet-private-id"{
    value=aws_subnet.private.id
}

output "subnet-database-id"{
    value=aws_subnet.database.id
}

output "all-az" {
  value = data.aws_availability_zones.main.names
}
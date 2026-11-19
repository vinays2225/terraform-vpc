output "vpc_id" {
  value = aws_vpc.main.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "subnet_public_id" {
  
  value = aws_subnet.public[*].id
}

output "subnet_private_id" {
  value = aws_subnet.private[*].id
}

output "subnet_database_id" {
  value = aws_subnet.database[*].id
}

output "all_az" {
  value = data.aws_availability_zones.main.names
}

output "route_table_public" {
  value = aws_route_table.public.id
}

output "route_table_private" {
  value = aws_route_table.private.id
}


output "route_table_databse" {
  value = aws_route_table.database.id
}

output "eip" {
  value = aws_eip.main-nat.id
}

output "nat_gw" {
  value = aws_nat_gateway.main.id
}
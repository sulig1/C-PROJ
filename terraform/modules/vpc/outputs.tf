output "vpc_id" {
    description = "vpc id"
    value = aws_vpc.vpc.id
}


output "public_subnet_id" {
    value = aws_subnet.public-subnet.id
}


output "public2_subnet_id" {
    value = aws_subnet.public-subnet2.id
}


output "alb_sg" {
  value = aws_security_group.alb_sg.id
}


output "private_subnet1" {
    value = aws_subnet.private-subnet.id
}


output "private_subnet2" {
    value = aws_subnet.private-subnet2.id
}


output "ecs_sg" {
    value = aws_security_group.ecs_sg.id
}
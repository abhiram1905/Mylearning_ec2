output "aws_subnet" {
  description = "The ID of the subnet"
  value       = aws_subnet.docker_subnet.id
}

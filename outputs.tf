output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "website_url" {
  description = "Website URL"
  value       = "http://${aws_instance.web_server.public_ip}"
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web_server.id
}

output "vpc_id" {
  description = "ID of the project VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

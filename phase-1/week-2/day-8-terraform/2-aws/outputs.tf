output "public_ip" {
  description = "Elastic IP of the web instance"
  value       = aws_eip.web.public_ip
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "url" {
  description = "HTTP URL"
  value       = "http://${aws_eip.web.public_ip}"
}

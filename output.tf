output "vpc_cidr_block" {
  value = aws_vpc.myvpc.cidr_block
}

output "public_subnet_cidr_blocks" {
  value = [for x in aws_subnet.public_subnet : x.cidr_block]
}

output "private_subnet_cidr_blocks" {
  value = [for x in aws_subnet.private_subnet : x.cidr_block]
}

output "ec2_public_ip" {
  value = [for x in aws_instance.ec2_instance : x.public_ip]
}

output "ec2_private_ip" {
  value = [for x in aws_instance.ec2_instance : x.private_ip]
}
/*
output "ssh_key" {
  sensitive = "true"
  description = "ssh pem key contents"
  value       = [for x in tls_private_key.ssh_private_key : x.private_key_pem]
}
*/

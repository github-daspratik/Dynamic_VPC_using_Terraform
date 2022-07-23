# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

#Create SSH Private Key
resource "tls_private_key" "ssh_private_key" {
  count      = var.public_subnet_count
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Save Private Key as PEM file
resource "local_file" "pem-key" {
  count      = var.public_subnet_count
  content = tls_private_key.ssh_private_key[count.index].private_key_pem
  filename = "MyAWSKey${count.index+1}.pem"
  file_permission = "0400"
}

# Create SSH RSA Key Pair (creating SSH Public Key)
resource "aws_key_pair" "ssh_key_pair" {
  count      = var.public_subnet_count
  key_name = "MyAWSKey${count.index+1}"
  public_key = tls_private_key.ssh_private_key[count.index].public_key_openssh
}

# Create ec2 server instance
resource "aws_instance" "ec2_instance" {
  count                       = var.public_subnet_count
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = var.instance-type
  //key_name                    = var.PUBLIC_KEY
  key_name = aws_key_pair.ssh_key_pair[count.index].key_name
  user_data                   = file("user-data.sh")
  disable_api_termination     = "false"
  associate_public_ip_address = "true"
  source_dest_check           = "true"
  availability_zone           = data.aws_availability_zones.az.names[count.index]
  subnet_id                   = element(aws_subnet.public_subnet.*.id, count.index)
  vpc_security_group_ids      = [aws_security_group.public_sg.id]

  tags = {
    Name        = "test-server-${count.index + 1}"
    Environment = var.environment
  }

  # Instance Root Volume
  root_block_device {
    volume_size           = var.root_vol_size
    volume_type           = var.root_vol_type
    delete_on_termination = "true"
  }
}
resource "null_resource" "remote_connect" {
  count = var.public_subnet_count
  connection {
    type        = "ssh"
    host        = aws_instance.ec2_instance[count.index].public_ip
    user        = var.USERNAME
    private_key = tls_private_key.ssh_private_key[count.index].private_key_pem
    //private_key = file(var.PRIVATE_KEY)
  }

  provisioner "local-exec" {
    //command = "chmod 400 ${var.PRIVATE_KEY}"
    command = "chmod 400 ${local_file.pem-key[count.index].filename}"
  }
}




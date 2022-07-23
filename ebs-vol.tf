# Create two EBS volumes and attach it to the EC2 instances we created earlier
resource "aws_ebs_volume" "my-ebs" {
  count             = var.public_subnet_count
  availability_zone = data.aws_availability_zones.az.names[count.index]
  size              = var.data_vol_size
  type              = var.data_vol_type
}

resource "aws_volume_attachment" "my-ebs-attachment" {
  count       = var.public_subnet_count
  device_name = "/dev/xvdh"
  instance_id = aws_instance.ec2_instance.*.id[count.index]
  volume_id   = aws_ebs_volume.my-ebs.*.id[count.index]
}
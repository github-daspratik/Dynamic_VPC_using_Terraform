aws_profile          = "dva-c01"
aws_region           = "us-west-2"
vpc_network          = "10.200.240.0"
vpc_netmask          = "20"
vpc_name             = "MyDemoVPC"
public_subnet_count  = 4
private_subnet_count = 0
environment          = "Val"
instance-type        = "t2.micro"
root_vol_size        = 8
root_vol_type        = "gp3"
data_vol_size        = 10
data_vol_type        = "gp3"
//PUBLIC_KEY           = "terraform-cicd"
//PRIVATE_KEY          = "terraform-cicd.pem"
USERNAME             = "ec2-user"
sg_ports = {
  "22"  = ["0.0.0.0/0"]
  "80"  = ["0.0.0.0/0"]
  "443" = ["0.0.0.0/0"]
}
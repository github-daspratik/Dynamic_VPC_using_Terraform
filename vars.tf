variable "aws_region" { type = string }
variable "aws_profile" { type = string }
variable "vpc_network" { type = string }
variable "vpc_netmask" { type = string }
variable "vpc_name" { type = string }
variable "environment" { type = string }
variable "public_subnet_count" { type = number }
variable "private_subnet_count" { type = number }
variable "instance-type" { type = string }
variable "root_vol_size" { type = number }
variable "root_vol_type" { type = string }
variable "data_vol_size" { type = number }
variable "data_vol_type" { type = string }
//variable "PUBLIC_KEY" { type = string }
//variable "PRIVATE_KEY" { type = string }
variable "USERNAME" { type = string }
variable "sg_ports" {
  type = map(list(string))
}
//variable "USER_DATA" {default = "user-data.sh"}




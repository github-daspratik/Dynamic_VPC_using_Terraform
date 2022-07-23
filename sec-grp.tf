resource "aws_security_group" "public_sg" {
  name   = "public_sg"
  vpc_id = aws_vpc.myvpc.id

  dynamic "ingress" {
    for_each = var.sg_ports
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      cidr_blocks = ingress.value
      protocol    = "tcp"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#################AWS_LAUNCH_COMFIGURATION##################
resource "aws_launch_configuration" "this" {
  name = "launch_config"
  image_id      = "ami-04d29b6f966df1537"
  instance_type = "t2.micro"
  key_name = "terraform"
  user_data = data.template_file.user_data.rendered
  security_groups =[aws_security_group.ec2_sg.id]
  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data"{
  template = file("user_data.sh")
}
####################AWS_AUTO_SCALING_GROUP##############################
resource "aws_autoscaling_group" "this" {
  name = "auto_scaling"
  max_size                  = 3
  min_size                  = 1
  launch_configuration      = aws_launch_configuration.this.name
  vpc_zone_identifier       = [aws_subnet.VPC_Subnet_3.id, aws_subnet.VPC_Subnet_4.id]
}
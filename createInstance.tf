
resource "aws_instance" "instance" {
  ami           = var.ec2_ami
  instance_type = var.instance_type
  count 	= var.ec2_count 
  tags = {
    Name	="instance"
    Description = " An Instance to host app"
}

 key_name = "first-ec2" 
 user_data	= file("file.sh") 
 vpc_security_group_ids = [aws_security_group.instance-sg.id]
}
 
resource "aws_key_pair" "web" {
      key_name  = "first-ec2"
      public_key = file("/home/manavdeep/.ssh/id_rsa.pub")
  
}

resource "aws_security_group" "ssh-access" {
   name		="ssh-access"
   description 	="Allow access from the internet"
   ingress {
      from_port	=22
      to_port	=22
      protocol	="tcp"
      cidr_blocks = ["0.0.0.0/0"]	   
  }     

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "http-access" {
   name		="ssh-access"
   description 	="Allow access from the internet"
   ingress {
      from_port	=5000
      to_port	=5000
      protocol	="tcp"
      cidr_blocks = ["0.0.0.0/0"]	   
  }     

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "instance-sg" {
   name		="instance-sg"
   description 	="Allow access from the internet"
   ingress {
      from_port	=80
      to_port	=80
      protocol	="tcp"
      cidr_blocks = ["0.0.0.0/0"]	   
  }     

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "instance_id" {
  value = "${element(aws_instance.ec2instances.*.id, 1)}"
}


output "instance2_id" {
  value = "${element(aws_instance.ec2instances.*.id, 2)}"
}

/* ALB */





resource "aws_lb_target_group" "my-target-group" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "my-test-tg"
  port        = 5000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "vpc-0300bd7a"
}

resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment1" {
  target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
  target_id        = "${var.instance_id}"
  port             = 5000
}

resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment2" {
  target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
  target_id        = "${var.instance2_id}"
  port             = 5000
}

resource "aws_lb" "my-aws-alb" {
  name     = "my-test-alb"
  internal = false

  security_groups = [
    "${aws_security_group.instance-sg.id}","${aws_security_group.http-access.id}"
  ]

  subnets = [
    "subnet-bbe910f0",
    "subnet-8503edfc",
    "subnet-442c071e",
  ]



  tags = {
    Name = "my-test-alb"
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

resource "aws_lb_listener" "my-test-alb-listner" {
  load_balancer_arn = "${aws_lb.my-aws-alb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
  }
}


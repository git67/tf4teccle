# vpc
resource "aws_vpc" "dev" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = join("_", [var.namespace, "vpc"])
  }
}

# internet gw
resource "aws_internet_gateway" "dev" {
  vpc_id = aws_vpc.dev.id
  tags = {
    Name = join("_", [var.namespace, "igw"])
  }
}

#public subnet(s)
resource "aws_subnet" "dev" {
  vpc_id = aws_vpc.dev.id
  count  = length(var.subnet_cidrs)

  availability_zone = element(var.av_zones, count.index)

  cidr_block = element(var.subnet_cidrs, count.index)

  map_public_ip_on_launch = "true"
  tags = {
    Name    = join("_", [var.namespace, "subnet", count.index])
    av_zone = element(var.av_zones, count.index)
  }
}

# create routing table
resource "aws_route_table" "dev" {
  vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev.id
  }
  tags = {
    Name = join("_", [var.namespace, "dev_rtb"])
  }
}

# associate table to subnet(s)
resource "aws_route_table_association" "dev" {
  count          = length(var.subnet_cidrs)
  subnet_id      = element(aws_subnet.dev.*.id, count.index)
  route_table_id = aws_route_table.dev.id
}

# keypair to use by ec2-user
resource "aws_key_pair" "dev" {
  key_name   = join("_", [var.namespace, "ssh_keypair"])
  public_key = file(var.ssh_credentials["pub_key"])
}

# security group ec2
resource "aws_security_group" "dev" {
  name   = join("_", [var.namespace, "sg_ec2"])
  vpc_id = aws_vpc.dev.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = join("_", [var.namespace, "sg_ec2"])
  }
}

# ec2
resource "aws_instance" "dev" {
  ami           = var.ec2["instance_ami"]
  instance_type = var.ec2["instance_type"]

  count     = length(var.subnet_cidrs) * var.ec2["instance_count"]
  subnet_id = element(aws_subnet.dev[*].id, count.index)

  vpc_security_group_ids = [aws_security_group.dev.id]
  key_name               = aws_key_pair.dev.key_name

  ebs_block_device {
    device_name = var.ec2["ebs_device"]
    volume_type = var.ec2["ebs_vol_type"]
    volume_size = var.ec2["ebs_vol_size"]
  }

  tags = {
    Name = join("_", [var.namespace, "ec2", count.index, element(var.av_zones, count.index)])
  }
}

# elb
resource "aws_elb" "dev" {
  name            = join("2", [var.namespace, "elb"])
  subnets         = aws_subnet.dev.*.id
  security_groups = [aws_security_group.dev.id]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/index.html"
    interval            = 30
  }

  instances                   = aws_instance.dev[*].id
  cross_zone_load_balancing   = true
  idle_timeout                = 100
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = join("_", [var.namespace, "elb"])
  }
}


resource "aws_cloudwatch_metric_alarm" "cpuutilization" {
  count               = length(var.subnet_cidrs) * var.ec2["instance_count"]
  alarm_name          = "${element(split(",", join(",", aws_instance.dev.*.id)), count.index)}-status-check"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"
  alarm_description   = "This metric monitors ec2 cpu utilization"

  dimensions = {
    InstanceId = element(aws_instance.dev.*.id, count.index)
  }
}

resource "aws_cloudwatch_metric_alarm" "statuscheckfailed" {
  count               = length(var.subnet_cidrs) * var.ec2["instance_count"]
  alarm_name          = "${element(split(",", join(",", aws_instance.dev.*.id)), count.index)}-status-check"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "This metric monitors ec2 status check."

  dimensions = {
    InstanceId = element(aws_instance.dev.*.id, count.index)
  }
}

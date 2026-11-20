# Find the newest Amazon Linux 2023 image for each CPU architecture
data "aws_ami" "al2023" {
  for_each    = { x86 = "x86_64", arm = "arm64" }
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-*"]
  }

  filter {
    name   = "architecture"
    values = [each.value]
  }
}

resource "aws_iam_role" "node" {
  name = "${var.name}-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.name}-node-profile"
  role = aws_iam_role.node.name
}

locals {
  nodes = {
    arm = "t4g.micro"
    x86 = "t3.micro"
  }
}

resource "aws_instance" "node" {
  for_each               = local.nodes
  ami                    = data.aws_ami.al2023[each.key].id
  instance_type          = each.value
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.nodes.id]
  iam_instance_profile   = aws_iam_instance_profile.node.name

  metadata_options {
    http_tokens = "required" # IMDSv2 only
  }

  tags = {
    Name = "${var.name}-node-${each.key}"
    Role = "fleet-node"
  }
}

output "instance_ids" {
  value = { for k, v in aws_instance.node : k => v.id }
}

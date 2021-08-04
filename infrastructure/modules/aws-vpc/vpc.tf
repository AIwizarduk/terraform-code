resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr
  tags       = merge({ Name = "${local.prefix}-vpc" }, var.vpc_tags, local.common_tags)
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.app_vpc.id
  tags   = merge({ Name = "${local.prefix}-vpc-igw" }, local.common_tags)
}


resource "aws_flow_log" "tf-vpc-flow-logs" {
  iam_role_arn    = aws_iam_role.aws_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.app_vpc.id
  tags            = merge({ Name = "${local.prefix}-vpc-flow-logs" }, local.common_tags)
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name = "${local.prefix}-vpc-log-group"
  tags = merge({ Name = "${local.prefix}-vpc-log-group" }, local.common_tags)
}

resource "aws_iam_role" "aws_flow_logs" {
  name               = "${local.prefix}-flow-logs-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = merge({ Name = "${local.prefix}-flow-logs-role" }, local.common_tags)
}

resource "aws_iam_role_policy" "aws_flow_logs_policy" {
  name   = "${local.prefix}-flow-logs-policy"
  role   = aws_iam_role.aws_flow_logs.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

}

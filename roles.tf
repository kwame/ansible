resource "aws_iam_role" "ec2-cloudwatch-test-role" {
    name = "ec2-cloudwatch-test"
    description = ""
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2-cloudwatch-test-profile" {
    name = "ec2-cloudwatch-test-profile"
    role = "${aws_iam_role.ec2-cloudwatch-test-role.name}"
}

resource "aws_iam_role_policy" "oracle-S3-FullAccess" {
  name = "oracle-S3-Readonly"
  role = "${aws_iam_role.ec2-cloudwatch-test-role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "servers-cloudwatchLogs-policy" {
  name = "servers-cloudwatchLogs-policy"
  role = "${aws_iam_role.ec2-cloudwatch-test-role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "servers-localserverLogs-policy" {
  name = "servers-localserverLogs-policy"
  role = "${aws_iam_role.ec2-cloudwatch-test-role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
    ],
      "Resource": [
        "arn:aws:logs:*:*:*"
    ]
    }
  ]
}
EOF
}
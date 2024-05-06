terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.47.0"
    }
  }
}

# Create an AWS SNS topic
resource "aws_sns_topic" "sns_topic" {
  name = "example-topic"
}

# Subscribe an email endpoint to the SNS topic
resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  for_each = toset(var.SUBSCRIBERS)
  endpoint = each.value
}

# Create an EventBridge rule to trigger SNS notifications
resource "aws_cloudwatch_event_rule" "example_rule" {
  name                = "example-rule"
  description         = "Example EventBridge Rule"
  event_pattern       = <<PATTERN
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": [ "running",  "stopped"]
  }
}
PATTERN
}

# Create an EventBridge target to send events to SNS
resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.example_rule.name
  arn       = aws_sns_topic.sns_topic.arn
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.sns_topic.arn
  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": "${aws_sns_topic.sns_topic.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_cloudwatch_event_rule.example_rule.arn}"
        }
      }
    }
  ]
}
POLICY  
}
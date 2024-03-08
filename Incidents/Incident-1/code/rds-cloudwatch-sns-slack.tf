# Define provider configuration (AWS)
provider "aws" {
  region = "us-east-1" # Update with your desired region
}

# Create SNS topic for sending alerts to Slack
resource "aws_sns_topic" "slack_alerts_topic" {
  name = "rds_instance_alerts"
}

# Create a subscription to the SNS topic for Slack
resource "aws_sns_topic_subscription" "slack_subscription" {
  topic_arn = aws_sns_topic.slack_alerts_topic.arn
  protocol  = "lambda" # Update with the appropriate protocol for sending alerts to Slack
  endpoint  = "YOUR_SLACK_ENDPOINT" # Update with your Slack endpoint
}

# Create CloudWatch Alarm for RDS instance metrics
resource "aws_cloudwatch_metric_alarm" "rds_cpu_alarm" {
  alarm_name          = "rds_cpu_utilization_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80 # Update with your desired threshold value for CPU utilization
  alarm_description   = "Alarm triggered when CPU utilization exceeds 80%"
  alarm_actions       = [aws_sns_topic.slack_alerts_topic.arn]
  dimensions = {
    DBInstanceIdentifier = "YOUR_RDS_INSTANCE_IDENTIFIER" # Update with your RDS instance identifier
  }
}

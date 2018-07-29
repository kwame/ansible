## Topic definition for alerting.
# If multiple resources exist for each server group, count needs to be updated to the value of the var that defines the number of instances
resource "aws_sns_topic" "critical_alerts" {
  name = "${var.environment}-critical-alerts"
  provisioner "local-exec" {
    command = <<EOT
    for email in ${var.critical_alerts_notification}; do
       aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint $email; 
    done
    EOT
  }
}

resource "aws_sns_topic" "non_critical_alerts" {
  name = "${var.environment}-non-critical-alerts"
  provisioner "local-exec" {
    command = <<EOT
    for email in ${var.critical_alerts_notification}
    do
       aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint $email; 
    done
    EOT
  }
}

# 1- Alert for CPU Utilization
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_check" {
  count = 1
  alarm_name                = "${var.environment}.ec2-cloudwatch-test.${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}.cpu-utilization-check"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "5"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "80"
  alarm_description         = "This metric monitors the cpu utilization"
  actions_enabled           = true
  alarm_actions             = ["${aws_sns_topic.non_critical_alerts.arn}"]
  alarm_description         = "${var.environment}.ec2_cloudwatch_test id: ${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)} cpu utilization is high"
  ok_actions                = ["${aws_sns_topic.non_critical_alerts.arn}"]
  dimensions {InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}" }
}

# 2- Alert for Disk utilization  
resource "aws_cloudwatch_metric_alarm" "disk_space_utilization_ec2_cloudwatch_test" {
  count = 1
  alarm_name                = "${var.environment}.ec2_cloudwatch_test.${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}.disk-space-utilization-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "DiskSpaceUtilization"
  namespace                 = "System/Linux"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "80"
  alarm_description         = "This metric checks disk space utilization"
  actions_enabled           = true
  alarm_actions             = ["${aws_sns_topic.non_critical_alerts.arn}"]
  alarm_description         = "${var.environment}.ec2_cloudwatch_test id: ${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)} low disk space on instance"
  ok_actions                = ["${aws_sns_topic.non_critical_alerts.arn}"]
#  dimensions {InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}" }
  dimensions {
  InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}"
  Filesystem = "/dev/xvda1"
  MountPath = "/"
 }
}

# 3- Metric Alarm for StatusCheckFailed_System
resource "aws_cloudwatch_metric_alarm" "status_check_failed_system" {
  count = "1"
  alarm_name                = "${var.environment}.ec2_cloudwatch_test.${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}.status-check-failed-system"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed_System"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors StatusCheckFailed_System"
  actions_enabled           = true
  alarm_actions             = ["${aws_sns_topic.non_critical_alerts.arn}"]
  alarm_description         = "${var.environment}.ec2_cloudwatch_test id: ${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)} has check failed system"
  ok_actions                = ["${aws_sns_topic.non_critical_alerts.arn}"]
  dimensions {InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}" }
}

# 4- Metric Alarm for StatusCheckFailed_Instance
resource "aws_cloudwatch_metric_alarm" "status_check_failed_instance" {
  count = "1"
  alarm_name                = "${var.environment}.ec2_cloudwatch_test.${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}.status-check-failed-instance"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed_Instance"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors StatusCheckFailed_Instance"
  actions_enabled           = true
  alarm_actions             = ["${aws_sns_topic.non_critical_alerts.arn}"]
  alarm_description         = "${var.environment}.ec2_cloudwatch_test id: ${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)} has check failed instance"
  ok_actions                = ["${aws_sns_topic.non_critical_alerts.arn}"]
  dimensions {InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}" }
}

# 5- Metric alarm for MemoryUtilization 
resource "aws_cloudwatch_metric_alarm" "memory_utilization_ec2_cloudwatch_test" {
  count = "1"
  alarm_name                = "${var.environment}.ec2_cloudwatch_test.${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}.memory_utilization_ec2_cloudwatch_test"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "MemoryUtilization"
  namespace                 = "System/Linux"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "40"
  alarm_description         = "This metric monitors MemoryUtilization"
  actions_enabled           = true
  alarm_actions             = ["${aws_sns_topic.non_critical_alerts.arn}"]
  alarm_description         = "${var.environment}.ec2_cloudwatch_test id: ${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)} has high memory usage"
  ok_actions                = ["${aws_sns_topic.non_critical_alerts.arn}"]
  dimensions {InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}" }
}


# 6- Metric alarm for SwapUtilization 
resource "aws_cloudwatch_metric_alarm" "swap_utilization_ec2_cloudwatch_test" {
  count = "1"
  alarm_name                = "${var.environment}.ec2_cloudwatch_test.${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}.swap_utilization_ec2_cloudwatch_test"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "SwapUtilization"
  namespace                 = "System/Linux"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "40"
  alarm_description         = "This metric monitors SwapUtilization"
  actions_enabled           = true
  alarm_actions             = ["${aws_sns_topic.non_critical_alerts.arn}"]
  alarm_description         = "${var.environment}.ec2_cloudwatch_test id: ${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)} has high swap usage"
  ok_actions                = ["${aws_sns_topic.non_critical_alerts.arn}"]
  dimensions {InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}" }
}

# 7- Metric alarm for MemoryAvailable 
resource "aws_cloudwatch_metric_alarm" "memory_available_ec2_cloudwatch_test" {
  count = "1"
  alarm_name                = "${var.environment}.ec2_cloudwatch_test.${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}.memory_available_ec2_cloudwatch_test"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "MemoryAvailable"
  namespace                 = "System/Linux"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "400"
  alarm_description         = "This metric monitors MemoryAvailable"
  actions_enabled           = true
  alarm_actions             = ["${aws_sns_topic.non_critical_alerts.arn}"]
  alarm_description         = "${var.environment}.ec2_cloudwatch_test id: ${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)} has available memory"
  ok_actions                = ["${aws_sns_topic.non_critical_alerts.arn}"]
  dimensions {InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}" }
}


# 8- Metric alarm for MemoryUsed 
resource "aws_cloudwatch_metric_alarm" "memory_used_ec2_cloudwatch_test" {
  count = "1"
  alarm_name                = "${var.environment}.ec2_cloudwatch_test.${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}.memory_used_ec2_cloudwatch_test"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "MemoryUsed"
  namespace                 = "System/Linux"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "3500"
  alarm_description         = "This metric monitors MemoryUsed"
  actions_enabled           = true
  alarm_actions             = ["${aws_sns_topic.non_critical_alerts.arn}"]
  alarm_description         = "${var.environment}.ec2_cloudwatch_test id: ${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)} has used memory"
  ok_actions                = ["${aws_sns_topic.non_critical_alerts.arn}"]
  dimensions {InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}" }
} 

# 9- Metric alarm for SwapUsed 
resource "aws_cloudwatch_metric_alarm" "swap_used_ec2_cloudwatch_test" {
  count = "1"
  alarm_name                = "${var.environment}.ec2_cloudwatch_test.${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}.swap_used_ec2_cloudwatch_test"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "SwapUsed"
  namespace                 = "System/Linux"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "2500"
  alarm_description         = "This metric monitors SwapUsed"
  actions_enabled           = true
  alarm_actions             = ["${aws_sns_topic.non_critical_alerts.arn}"]
  alarm_description         = "${var.environment}.ec2_cloudwatch_test id: ${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)} has swap used"
  ok_actions                = ["${aws_sns_topic.non_critical_alerts.arn}"]
  dimensions {InstanceId = "${element(aws_instance.ec2_cloudwatch_test.*.id, count.index)}" }
} 

output "asg_name" {
  description = "The name of the autoscaling group"
  value       = "${element(concat(aws_autoscaling_group.homogenous.*.name,aws_autoscaling_group.heterogenous.*.name, list("")), 0)}"
}

output "lt_name" {
  description = "The name of the launch template"
  value       = "${aws_launch_template.launch_template.*.name}"
}

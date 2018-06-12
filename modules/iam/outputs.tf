output "ecs_instance_profile" {
  description = "aws_iam_role_autodiscovery_role exports the IAM role of the EC2 instance"
  value       = "${element(concat(aws_iam_instance_profile.ecs_cluster_ec2_instance_profile.*.arn, list("")), 0)}"
}

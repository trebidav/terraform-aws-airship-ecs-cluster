output "ecs_instance_profile" {
  description = "aws_iam_role_autodiscovery_role exports the IAM role of the EC2 instance"
  value       = "${aws_iam_instance_profile.ecs_cluster_ec2_instance_profile.name}"
}

# This is the load balancer scheduler role for an ecs service connected to an ELB
# Unfortunately AWS has not made it an actual service linked role, just a policy, hence the export
# for ECS Services to be used.
output "aws_iam_role_ecs_service" {
  description = "Aws_iam_role_ecs_service_name exports the IAM Role for ECS"
  value       = "${aws_iam_role.ecs_service.name}"
}

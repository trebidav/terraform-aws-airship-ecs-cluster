output "cluster_id" {
  description = "ecs_cluster_id is the export of the ECS cluster id"
  value       = "${module.cluster.cluster_id}"
}

output "ecs_cluster_name" {
  description = "ecs_cluster_name exports the name of the ECS cluster"
  value       = "${module.cluster.cluster_name}"
}

output "ecs_instance_profile" {
  description = "aws_iam_role_autodiscovery_role exports the IAM role of the EC2 instance"
  value       = "${module.iam.ecs_instance_profile}"
}

# This is the load balancer scheduler role for an ecs service connected to an ELB
# Unfortunately AWS has not made it an actual service linked role, just a policy, hence the export
# of the role for ECS Services to be used.
output "aws_iam_role_ecs_service" {
  description = "Aws_iam_role_ecs_service_name exports the IAM Role for ECS"
  value       = "${module.iam.aws_iam_role_ecs_service}"
}

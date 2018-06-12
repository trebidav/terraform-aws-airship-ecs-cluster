output "cluster_id" {
  description = "ecs_cluster_id is the export of the ECS cluster id"
  value       = "${element(concat(aws_ecs_cluster.this.*.id, list("")), 0)}"
}

output "ecs_cluster_name" {
  description = "ecs_cluster_name exports the name of the ECS cluster"
  value       = "${var.name}"
}

output "ecs_instance_profile" {
  description = "aws_iam_role_autodiscovery_role exports the IAM role of the EC2 instance"
  value       = "${module.iam.ecs_instance_profile}"
}

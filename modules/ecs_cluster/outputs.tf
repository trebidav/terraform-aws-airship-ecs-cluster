output "asg_name" {
  description = "The name of the autoscaling group"
  value       = "${aws_autoscaling_group.this.name}"
}

output "cluster_id" {
  description = "cluster_id is the export of the ECS cluster id"
  value       = "${aws_ecs_cluster.this.id}"
}

output "cluster_name" {
  description = "The name of the autoscaling group"
  value       = "${local.name}"
}

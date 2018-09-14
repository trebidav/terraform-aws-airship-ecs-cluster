output "asg_name" {
  description = "The name of the autoscaling group"

  # With autoscalinggroup_type being MIGRATION, we have TWO Autoscaling Groups next to each other. 
  # We output "" in case of MIGRATION

  value = "${local.autoscalinggroup_type == "MIGRATION" ? "" :
                      element(concat(aws_autoscaling_group.this.*.name, aws_cloudformation_stack.autoscaling_group.*.outputs["AsgName"] list("")), 0)}"
}

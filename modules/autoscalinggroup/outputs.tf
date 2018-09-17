# HT https://github.com/aknysh  
# for creating a conditional output of an aws_cloudformation_stack
locals {
  list       = "${coalescelist(aws_cloudformation_stack.autoscaling_group.*.outputs, list(map("AsgName", "")))}"
  map        = "${local.list[0]}"
  asgname_cf = "${lookup(local.map, "AsgName", "")}"
}

output "asg_name" {
  description = "The name of the autoscaling group"

  # With autoscalinggroup_type being MIGRATION, we have TWO Autoscaling Groups next to each other. 
  # We output "" in case of MIGRATION

  value = "${local.autoscalinggroup_type == "MIGRATION" ? "" :
                 (
                   local.autoscalinggroup_type == "LEGACY" ? "" : local.asgname_cf
                 )
           }"
}

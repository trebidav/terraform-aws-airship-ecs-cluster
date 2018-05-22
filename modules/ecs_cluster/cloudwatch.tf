/* "Cloudwatch loggroup for the ECS-Agent" */
resource "aws_cloudwatch_log_group" "ecs" {
  name = "${var.name}/ecs-agent"
}

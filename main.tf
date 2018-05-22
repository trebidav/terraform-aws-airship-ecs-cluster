module "iam" {
  source = "./modules/ecs_iam/"
  name   = "${var.name}"
}

module "cluster" {
  source                 = "./modules/ecs_cluster/"
  name                   = "${var.name}"
  cluster_properties     = "${var.cluster_properties}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  iam_instance_profile   = "${module.iam.ecs_instance_profile}"
  tags                   = "${var.tags}"
  subnet_ids             = ["${var.subnet_ids}"]
  environment            = "${var.environment}"
}

module "ecs_instance_scaling" {
  source                           = "./modules/ecs_instance_autoscaling/"
  ecs_instance_scaling_create      = "${var.ecs_instance_scaling_create}"
  asg_name                         = "${module.cluster.asg_name}"
  cluster_name                     = "${module.cluster.cluster_name}"
  ecs_instance_draining_lambda_arn = "${var.ecs_instance_draining_lambda_arn}"
  ecs_instance_scaling_properties  = ["${var.ecs_instance_scaling_properties}"]
}

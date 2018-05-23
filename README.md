README


## Usage without ECS Scaling

```hcl
module "ecs_web" { 
  source = "github.com/blinkist/airship-tf-ecs-cluster/"

  name            = "${terraform.workspace}-web"
  environment     = "${terraform.workspace}"

  vpc_id          = "${module.vpc.vpc_id}"
  subnet_ids      = ["${module.vpc.private_subnets}"]

  cluster_properties {
    create = true
    ec2_key_name = "${aws_key_pair.main.key_name}"
    ec2_instance_type = "t2.small"
    ec2_asg_min = "1"
    ec2_asg_max = "1"
    ec2_disk_size = "40"
    ec2_disk_type = "gp2"
  }
  
  ecs_instance_scaling_create = false

  vpc_security_group_ids = ["${module.ecs_instance_sg.this_security_group_id}","${module.admin_sg.this_security_group_id}"]

  tags= { 
	Environment = "${terraform.workspace}"
  }
}

## Usage without ECS Scaling and with EFS mounting

```hcl
module "ecs_web" { 
  source = "github.com/blinkist/airship-tf-ecs-cluster/"

  name            = "${terraform.workspace}-web"
  environment     = "${terraform.workspace}"

  vpc_id          = "${module.vpc.vpc_id}"
  subnet_ids      = ["${module.vpc.private_subnets}"]

  cluster_properties {
    create = true
    ec2_key_name = "${aws_key_pair.main.key_name}"
    ec2_instance_type = "t2.small"
    ec2_asg_min = "1"
    ec2_asg_max = "1"
    ec2_disk_size = "40"
    ec2_disk_type = "gp2"
    efs_enabled = true
    efs_id = "${module.efs.aws_efs_file_system_sharedfs_id}"
  }
  
  ecs_instance_scaling_create = false

  vpc_security_group_ids = ["${module.ecs_instance_sg.this_security_group_id}","${module.admin_sg.this_security_group_id}"]

  tags= { 
	Environment = "${terraform.workspace}"
  }
}


```

## Usage with ECS Instance Scaling

```hcl
# The ECS Draining module, which takes care of the Terminate lifecycle
module "ecs_draining" {
  source = "github.com/blinkist/airship-tf-ecs-draining"
  name = "web"
}

# Example of extra userdata, to be added to the instance inside the ASG
data "template_file" "extra_userdata" {
  template = "${file("${path.module}/extrauserdata.yml")}"

  vars {
    ssh_pub_key = "${var.some_ssh_key}"
  }
}

module "ecs_web" { 
  source = "github.com/blinkist/airship-tf-ecs-cluster/"

  name            = "${terraform.workspace}-web"
  environment     = "${terraform.workspace}"

  vpc_id          = "${module.vpc.vpc_id}"
  subnet_ids      = ["${module.vpc.private_subnets}"]
  
  cluster_properties {
    create = true
    ec2_key_name = "${aws_key_pair.main.key_name}"
    ec2_custom_userdata = "${data.template_file.extra_userdata.rendered}"
    ec2_instance_type = "t2.small"
    ec2_asg_min = "1"
    ec2_asg_max = "1"
    ec2_disk_size = "40"
    ec2_disk_type = "gp2"
  }

  ecs_instance_scaling_create = true
  ecs_instance_draining_lambda_arn = "${module.ecs_draining.lambda_function_arn}"

  datadog_api_key = "Datadog API KEY"
  datadog_enabled = true

  ecs_instance_scaling_properties = [
   { 
     type = "CPUReservation"
     direction = "up"
     evaluation_periods = 2
     observation_period = "300"
     statistic = "Average"
     threshold = "89"
     cooldown = "900"
     adjustment_type = "ChangeInCapacity"
     scaling_adjustment = "1"
   },
   { 
     type = "CPUReservation"
     direction = "down"
     evaluation_periods = 4
     observation_period = "300"
     statistic = "Average"
     threshold = "10"
     cooldown = "300"
     adjustment_type = "ChangeInCapacity"
     scaling_adjustment = "-1"
   },
   { 
     type = "MemoryReservation"
     direction = "up"
     evaluation_periods = 2
     observation_period = "300"
     statistic = "Average"
     threshold = "50"
     cooldown = "900"
     adjustment_type = "ChangeInCapacity"
     scaling_adjustment = "1"
   },
   { 
     type = "MemoryReservation"
     direction = "down"
     evaluation_periods = 4
     observation_period = "300"
     statistic = "Average"
     threshold = "10"
     cooldown = "300"
     adjustment_type = "ChangeInCapacity"
     scaling_adjustment = "-1"
   },
  ]

  vpc_security_group_ids = ["${module.ecs_instance_sg.this_security_group_id}","${module.admin_sg.this_security_group_id}"]

  tags= { 
	Environment = "${terraform.workspace}"
  }
}
```

## Outputs

TODO


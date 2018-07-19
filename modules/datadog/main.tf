/* "Datadog agent ECS TASK" */

data "aws_region" "_" {}

resource "aws_ecs_task_definition" "datadog_agent" {
  count        = "${var.create ? 1 : 0}"
  family       = "${var.name}-dd-agent-task"
  network_mode = "host"

  volume {
    name      = "docker_sock"
    host_path = "/var/run/docker.sock"
  }

  volume {
    name      = "proc"
    host_path = "/proc/"
  }

  volume {
    name      = "cgroup"
    host_path = "/cgroup/"
  }

  container_definitions = <<EOF
[
  {
    "environment": [
        {
            "name": "API_KEY",
            "value": "${var.datadog_api_key}"
        },
        {
          "name": "TAGS",
          "value": "environment:${var.environment},type:aws,region:${data.aws_region._.name},cluster:${var.name}"
        }

    ],
   "mountPoints": [
        {
          "readOnly": null,
          "containerPath": "/var/run/docker.sock",
          "sourceVolume": "docker_sock"
        },
        {
          "readOnly": true,
          "containerPath": "/host/sys/fs/cgroup",
          "sourceVolume": "cgroup"
        },
        {
          "readOnly": true,
          "containerPath": "/host/proc",
          "sourceVolume": "proc"
        }
      ],
    "name": "dd-agent",
    "image": "datadog/docker-dd-agent:latest",
    "cpu": 10,
    "memory": 256,
    "entryPoint": [],
    "command": [],
    "volumesFrom": [],
    "links": [],
    "essential": true
  }
]
EOF
}

resource "aws_ecs_service" "datadog" {
  count               = "${var.create ? 1 : 0}"
  name                = "dd-agent-task"
  cluster             = "${var.cluster_id}"
  task_definition     = "${aws_ecs_task_definition.datadog_agent.arn}"
  scheduling_strategy = "DAEMON"
}

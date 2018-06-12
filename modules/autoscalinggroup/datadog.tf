/* "Datadog agent ECS TASK" */

resource "aws_ecs_task_definition" "datadog_agent" {
  count        = "${(var.datadog_enabled && var.create ) ? 1 : 0}"
  family       = "${local.name}-dd-agent-task"
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

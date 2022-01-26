resource "aws_ecs_task_definition" "quest" {
  family = "quest"
  execution_role_arn = aws_iam_role.quest_execution_role.arn

  container_definitions = <<EOF
[
{
    "name": "quest",
    "environment": [
        {
            "name": "SECRET_WORD",
            "value": "${var.SECRET_WORD}"
        }
    ],
    "image": "150846135797.dkr.ecr.us-west-1.amazonaws.com/quest:latest",
    "portMappings": [
    {
        "containerPort": 3000
    }
    ],
    "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
        "awslogs-region": "us-east-1",
        "awslogs-group": "${aws_cloudwatch_log_group.quest.name}",
        "awslogs-stream-prefix": "ecs"
    }
    }
}
]
EOF

  cpu = 256
  memory = 512
  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"
}

resource "aws_ecs_cluster" "quest_app" {
  name = "quest-app"
}

resource "aws_ecs_service" "quest" {
  name = "quest"
  cluster = aws_ecs_cluster.quest_app.id
  task_definition = "${aws_ecs_task_definition.quest.arn}"
  launch_type = "FARGATE"
  network_configuration {
    assign_public_ip = false
    
    security_groups = [
        aws_security_group.egress_all.id,
        aws_security_group.ingress_api.id
    ]

    subnets = [
        aws_subnet.private_d.id,
        aws_subnet.private_e.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.quest.arn
    container_name = "quest"
    container_port = 3000
  }

  desired_count = 1
}
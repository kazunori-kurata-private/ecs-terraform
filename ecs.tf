resource "aws_service_discovery_http_namespace" "namespace_ecs" {
  name = "ecs-test"
}

resource "aws_ecs_cluster" "stateless" {
  name = "ecs-test"
  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.namespace_ecs.arn
  }
  setting {
    name  = "containerInsights"
    value = "enhanced"
  }
}

resource "aws_ecs_task_definition" "example" {
  container_definitions = jsonencode([{
    essential = true
    image     = "468415095331.dkr.ecr.ap-northeast-1.amazonaws.com/laravelecs:latest"
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group  = "true"
        awslogs-group         = "/ecs/fargate-test"
        awslogs-region        = "ap-northeast-1"
        awslogs-stream-prefix = "ecs"
        max-buffer-size       = "25m"
        mode                  = "non-blocking"
      }
    }
    memoryReservation = 131
    name              = "laravel"
    portMappings = [{
      appProtocol   = "http"
      containerPort = 80
      hostPort      = 80
      name          = "laravel-80-tcp"
      protocol      = "tcp"
    }]
  }])
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  family                   = "fargate-test"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.ecs_task_execution.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "imported" {
  availability_zone_rebalancing      = "ENABLED"
  cluster                            = aws_ecs_cluster.stateless.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 2
  enable_ecs_managed_tags            = true
  name                               = "alb-service-test"
  platform_version                   = "LATEST"
  propagate_tags                     = "NONE"
  scheduling_strategy                = "REPLICA"
  task_definition                    = "fargate-test:10"
  capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE"
    weight            = 1
  }
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  deployment_controller {
    type = "ECS"
  }
  load_balancer {
    container_name   = "laravel"
    container_port   = 80
    target_group_arn = aws_lb_target_group.app_front_end.arn
  }
  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1c.id]
  }
}

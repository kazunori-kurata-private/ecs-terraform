data "aws_iam_policy_document" "ecr_pullpush" {
  statement {
    actions = [
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:ecr:ap-northeast-1:468415095331:repository/laravelecs"
    ]
  }
  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecr_pullpush" {
  description = "ecr pull push"
  name        = "ecr-pullpush"
  path        = "/"
  policy      = data.aws_iam_policy_document.ecr_pullpush.json
}

# __generated__ by Terraform from "ecsInstanceRole"
resource "aws_iam_role" "ecs_instance" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2008-10-17"
  })
  description          = "Allows EC2 instances in an ECS cluster to access ECS."
  max_session_duration = 3600
  name                 = "ecsInstanceRole"
  path                 = "/"
}

resource "aws_iam_role" "ecs_autoscale" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "application-autoscaling.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
  description          = "Allows Auto Scaling to access and update ECS services."
  max_session_duration = 3600
  name                 = "ecsAutoScalingRole"
  path                 = "/"
}

resource "aws_iam_role" "ecs" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2008-10-17"
  })
  description          = "Allows ECS to create and manage AWS resources on your behalf."
  max_session_duration = 3600
  name                 = "ecsRole"
  path                 = "/"
}

resource "aws_iam_role" "ecs_task_execution" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
  description          = "Allows ECS tasks to call AWS services on your behalf."
  max_session_duration = 3600
  name                 = "ecsTaskExecutionRole"
  path                 = "/"
}

data "aws_iam_policy_document" "ecs_fargate_exec_inline" {
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecs_fargate_exec_inline" {
  name   = "ecsFargateExecRole"
  role   = aws_iam_role.ecs_task_execution.id
  policy = data.aws_iam_policy_document.ecs_fargate_exec_inline.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attach_ecr_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecr_pullpush.arn
}

data "aws_iam_policy" "ecs" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy" "ecs_instance" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_policy" "ecs_autoscale" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_role_attach_policy" {
  role       = aws_iam_role.ecs.name
  policy_arn = data.aws_iam_policy.ecs.arn
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attach_policy" {
  role       = aws_iam_role.ecs_instance.name
  policy_arn = data.aws_iam_policy.ecs_instance.arn
}

resource "aws_iam_role_policy_attachment" "ecs_autoscale_role_attach_policy" {
  role       = aws_iam_role.ecs_autoscale.name
  policy_arn = data.aws_iam_policy.ecs_autoscale.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attach_service_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = data.aws_iam_policy.ecs_task_execution.arn
}

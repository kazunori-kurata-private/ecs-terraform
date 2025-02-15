resource "aws_lb_listener" "front_end_https" {
  certificate_arn   = aws_acm_certificate.cert.arn
  load_balancer_arn = aws_lb.bar.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  default_action {
    target_group_arn = aws_lb_target_group.app_front_end.arn
    type             = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.app_front_end.arn
        weight = 1
      }
    }
  }
  mutual_authentication {
    ignore_client_certificate_expiry = false
    mode                             = "off"
  }
}

resource "aws_lb" "bar" {
  client_keep_alive                = 3600
  desync_mitigation_mode           = "defensive"
  enable_cross_zone_load_balancing = true
  enable_http2                     = true
  idle_timeout                     = 60
  internal                         = false
  ip_address_type                  = "ipv4"
  load_balancer_type               = "application"
  name                             = "ecs-alb"
  preserve_host_header             = false
  security_groups                  = [aws_security_group.ecs_sg.id]
  subnets                          = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1c.id]
  xff_header_processing_mode       = "append"
}

resource "aws_lb_target_group" "app_front_end" {
  deregistration_delay              = "300"
  ip_address_type                   = "ipv4"
  load_balancing_algorithm_type     = "round_robin"
  load_balancing_anomaly_mitigation = "off"
  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"
  name                              = "ecs-memo-lb-test"
  port                              = 80
  protocol                          = "HTTP"
  protocol_version                  = "HTTP1"
  target_type                       = "ip"
  vpc_id                            = aws_vpc.test_vpc.id
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/login"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  target_group_health {
    dns_failover {
      minimum_healthy_targets_count      = "1"
      minimum_healthy_targets_percentage = "off"
    }
    unhealthy_state_routing {
      minimum_healthy_targets_count      = 1
      minimum_healthy_targets_percentage = "off"
    }
  }
}

resource "aws_lb_listener" "front_end_http" {
  load_balancer_arn = aws_lb.bar.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.app_front_end.arn
    type             = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.app_front_end.arn
        weight = 1
      }
    }
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name = var.domain
}

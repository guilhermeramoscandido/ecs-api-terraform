data "aws_availability_zones" "available" {}

locals {
  tags = {
    Environment = "dev"
    Project     = "my-project"
  }

  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
    source    = "terraform-aws-modules/vpc/aws"
    version   = "~> 5.13.0"

    tags  = local.tags
    azs   = local.azs
    name  = var.vpc_name
    cidr  = var.vpc_cidr

    enable_nat_gateway = true
    one_nat_gateway_per_az = true

    private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
    public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]

}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"
  version   = "~> 2.3.1"

  repository_name = var.ecr_name

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = var.ecr_repository_max_image_count
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags  = local.tags
}

module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "~> 5.12.0"

  cluster_name = var.ecs_cluster_name
  

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = var.ecs_cluster_cloud_watch_group_name
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
        base   = 20
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  tags = local.tags
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "~> 5.11"

  name        = "${var.ecs_cluster_name}-svc"
  cluster_arn = module.ecs_cluster.arn

  cpu    = 1024
  memory = 4096

  # Enables ECS Exec
  enable_execute_command = true

  # Container definition(s)
  container_definitions = {

    (var.container_name) = {
      cpu       = var.cpu
      memory    = var.memory
      image     = var.container_image
      port_mappings = [
        {
          name          = var.container_image
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

      enable_cloudwatch_logging              = true
      create_cloudwatch_log_group            = true
      cloudwatch_log_group_name              = "/aws/ecs/${var.ecs_cluster_name}/${var.container_name}"
      cloudwatch_log_group_retention_in_days = 1

      log_configuration = {
        logDriver = "awslogs"
      }
    }
  }

  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups["ex_ecs"].arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  subnet_ids = module.vpc.private_subnets
  security_group_rules = {
    alb_ingress_3000 = {
      type                     = "ingress"
      from_port                = var.container_port
      to_port                  = var.container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.alb.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = local.tags
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = "alb-${var.ecs_cluster_name}"

  load_balancer_type = "application"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets


  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }

    all_https = {
            from_port   = 443
            to_port     = 443
            ip_protocol = "tcp"
            description = "HTTPS web traffic"
            cidr_ipv4   = "0.0.0.0/0"
    }
  }

  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  listeners = {
    ex_https = {
        port     = 443
        protocol = "HTTPS"
        ssl_policy                  = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
        certificate_arn             = var.acm_certificate_arn
        forward = {
            target_group_key = "ex_ecs"
        }
    }
     ex-http-https-redirect = {
            port     = 80
            protocol = "HTTP"
            redirect = {
                port        = "443"
                protocol    = "HTTPS"
                status_code = "HTTP_301"
            }
        }
  }

  target_groups = {
    ex_ecs = {
      backend_protocol                  = "HTTP"
      backend_port                      = var.container_port
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/healthcheck"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }

      create_attachment = false

    }
  }

  tags = local.tags
}

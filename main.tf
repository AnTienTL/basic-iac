provider "aws" {
  region = "eu-west-1"
}

locals {
  user_data = <<EOF
  #!/bin/bash
  sudo yum update -y 
  sudo yum upgrade -y
  sudo yum install telnet mysql -y
  sudo yum -y install httpd
  echo "Hello World" > /var/www/html/index.html
  service httpd start
  chkconfig httpd on
  EOF
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

data "aws_acm_certificate" "demo_cert" {
  domain   = "*.antientf.tk"
  statuses = ["ISSUED"]
}

module "vpc" {
  source = "./modules/vpc/"
  name   = "demo"

  cidr = "20.10.0.0/16"

  azs              = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets  = ["20.10.1.0/24", "20.10.2.0/24", "20.10.3.0/24"]
  public_subnets   = ["20.10.11.0/24", "20.10.12.0/24", "20.10.13.0/24"]
  database_subnets = ["20.10.21.0/24", "20.10.22.0/24", "20.10.23.0/24"]

  create_database_subnet_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true
}

module "security_group_for_ec2" {
  source  = "./modules/sg"

  name                = var.sg_name
  description         = var.sg_description
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = var.sg_ingress_cidr_blocks
  ingress_rules       = var.sg_ingress_rules
  egress_rules        = var.sg_egress_rules
}

module "acm" {
  source  = "./modules/acm"

  domain_name         = var.acm_domain_name
  validation_method   = var.acm_validation_method
  tags = {
    "name" = "demo tf"
  }
}

# module "security_group_for_rds" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "~> 3.0"

#   name        = "sgrds"
#   description = "Security group for example usage with rds instance"
#   vpc_id      = module.vpc.vpc_id

#   ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
#   ingress_rules       = ["mysql-tcp"]
#   egress_rules        = ["all-all"]
# }

module "key-pair" {
  source     = "./modules/key-pair/"

  key_name   = var.key_name
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# module "ec2" {
#   source = "./modules/ec2/"

#   instance_count = var.instance_count

#   name          = var.name
#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = var.instance_type
#   subnet_id     = module.vpc.public_subnets[0]
#   key_name = module.key-pair.this_key_pair_key_name
#   #  private_ips                 = ["172.31.32.5", "172.31.46.20"]
#   vpc_security_group_ids      = [module.security_group_for_ec2.this_security_group_id]
#   associate_public_ip_address = var.associate_public_ip_address

#   user_data = local.user_data

#   root_block_device = [
#     {
#       volume_type = "gp2"
#       volume_size = 10
#     },
#   ]

#   tags = {
#     "Env"      = "Private"
#     "Location" = "Secret"
#   }
# }

# module "rds" {
#   source                          = "./modules/rds/"

#   identifier                      = var.identifier
#   engine                          = var.rds_engine
#   engine_version                  = var.rds_engine_version
#   instance_class                  = var.rds_instance_class
#   allocated_storage               = var.rds_allocated_storage
#   storage_encrypted               = var.rds_storage_encrypted
#   name                            = var.rds_name
#   username                        = var.rds_username
#   password                        = var.rds_password
#   port                            = var.rds_port
#   vpc_security_group_ids          = [module.security_group_for_rds.this_security_group_id]

#   maintenance_window              = var.rds_maintenance_window
#   backup_window                   = var.rds_backup_window

#   multi_az                        = var.rds_multi_az
#   backup_retention_period         = var.rds_backup_retention_period # disable backups to create DB faster 

#   tags = {
#     Owner                         = var.tags_owner
#     Environment                   = var.tags_environment
#   }

#   subnet_ids                      = module.vpc.private_subnets # DB subnet group
#   family                          = var.rds_family # DB parameter group
#   major_engine_version            = var.rds_major_engine_version # DB option group
#   final_snapshot_identifier       = var.rds_final_snapshot_identifier # Snapshot name upon DB deletion
#   deletion_protection             = var.rds_deletion_protection  # Database Deletion Protection
#   enabled_cloudwatch_logs_exports = var.rds_enabled_cloudwatch_logs_exports
# }

module "asg" {
  source = "./modules/asg/"

  name = var.asg_name

  lc_name = var.asg_lc_name

  image_id        = data.aws_ami.amazon_linux.id
  instance_type   = var.instance_type
  key_name        = module.key-pair.this_key_pair_key_name
  user_data       = local.user_data
  security_groups = [module.security_group_for_ec2.this_security_group_id]

  # Auto scaling group
  vpc_zone_identifier = module.vpc.public_subnets
  health_check_type   = var.asg_health_check_type
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  force_delete        = var.asg_force_delete
  target_group_arns   = module.alb.target_group_arns

  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "megasecret"
      propagate_at_launch = true
    },
  ]
}

module "alb" {
  source = "./modules/alb/"

  name                  = var.alb_name
  vpc_id                = module.vpc.vpc_id
  security_groups       = [module.security_group_for_ec2.this_security_group_id]
  subnets               = module.vpc.public_subnets

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.demo_cert.arn
      target_group_index = 0
    }
  ]
  target_groups         = var.alb_target_groups
  https_listener_rules  = var.alb_https_listener_rules

  tags = {
    Project = "demo"
  }

  lb_tags = {
    MyLoadBalancer = "demolb"
  }
}

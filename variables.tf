variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

##################################################################
###########  EC2                                       ###########  
##################################################################


variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 3
}

variable "name" {
  description = "Name to be used on all resources as prefix"
  type        = string
  default     = "demo"
}


variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}


variable "associate_public_ip_address" {
  description = "If true, the EC2 instance will have associated public IP address"
  type        = bool
  default     = true
}


##################################################################
###########  RDS                                       ###########  
##################################################################

variable "identifier" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
  default     = "demo"
}

variable "rds_engine" {
  description = "The database engine to use"
  type        = string
  default     = "mysql"
}


variable "rds_engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "5.7.19"
}

variable "rds_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t2.micro"
}

variable "rds_allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
  default     = 5
}

variable "rds_storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = false
}


variable "rds_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = "demodb"
}


variable "rds_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "user"
}

variable "rds_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  sensitive   = true
  default     = "YourPwdShouldBeLongAndSecure!"
}

variable "rds_port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default     = 3306
}

variable "rds_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = true
}

variable "rds_backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 0
}

variable "rds_family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "mysql5.7"
}

variable "rds_major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = "5.7"
}

variable "rds_final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this DB instance is deleted."
  type        = string
  default     = "demodb"
}

variable "rds_deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  type        = bool
  default     = false
}

variable "rds_maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "rds_backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = "03:00-06:00"
}

variable "rds_enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)."
  type        = list(string)
  default     = ["audit", "general"]
}

variable "tags_owner" {
  description = "The name's tag of owner rds"
  type        = string
  default     = "user"
}

variable "tags_environment" {
  description = "The name's tag of environment rds"
  type        = string
  default     = "dev"
}

##################################################################
###########  ALB                                       ###########  
##################################################################


variable "target_groups" {
  description = "demmo tg"
  type        = any
  default     =  [
    {
      name_prefix          = "h1"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = "InstanceTargetGroupTag"
      }
    },
    {
      name_prefix          = "h1"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = "InstanceTargetGroupTag"
      }
    }
  ]
}

variable "alb_name" {
  description = "The resource name and Name tag of the load balancer."
  type        = string
  default     = "demo"
}

variable "alb_http_tcp_listeners" {
  description = "A list of maps describing the HTTP listeners or TCP ports for this ALB. Required key/values: port, protocol. Optional key/values: target_group_index (defaults to http_tcp_listeners[count.index])"
  type        = any
  default     = [
    {
      port               = 80
      protocol           = "HTTP"
      action_type = "redirect"  # Forward action is default, either when defined or undefined
      target_group_index = 0
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]
}

variable "alb_target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  type        = any
  default     = [
    {
      name_prefix          = "demo"
      backend_port         = 80
      backend_protocol     = "HTTP"
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 6
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 4
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = "InstanceTargetGroupTag"
      }
    }
  ]
}

variable "alb_https_listener_rules" {
  description = "A list of maps describing the Listener Rules for this ALB. Required key/values: actions, conditions. Optional key/values: priority, https_listener_index (default to https_listeners[count.index])"
  type        = any
  default     = [
    {
      https_listener_index = 0
      priority             = 5000
      actions = [{
        type        = "redirect"
        status_code = "HTTP_302"
        host        = "www.antientf.tk"
        path        = "/*"
        query       = ""
        protocol    = "HTTPS"
      }]
      conditions = [{
        http_headers = [{
          http_header_name = "x-Gimme-Fixed-Response"
          values           = ["yes", "please", "right now"]
        }]
      }]
    },
  ]


}



##################################################################
###########  ASG                                       ###########  
##################################################################


variable "asg_name" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = "example-with-elb"
}

variable "asg_lc_name" {
  description = "Creates a unique name for launch configuration beginning with the specified prefix"
  type        = string
  default     = ""
}

variable "asg_instance_type" {
  description = "The size of instance to launch"
  type        = string
  default     = "t2.micro"
}

variable "asg_health_check_type" {
  description = "Controls how health checking is done. Values are - EC2 and ELB"
  type        = string
  default     = "EC2"
}

variable "asg_min_size" {
  description = "The minimum size of the auto scale group"
  type        = string
  default     = 2
}

variable "asg_max_size" {
  description = "The maximum size of the auto scale group"
  type        = string
  default     = 4
}

variable "asg_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  type        = string
  default     = 2
}

variable "asg_force_delete" {
  description = "Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
  type        = bool
  default     = true
}



##################################################################
###########  KEY                                       ###########  
##################################################################


variable "key_name" {
  description = "The name for the key pair."
  type        = string
  default     = "mykeypair"
}


##################################################################
###########  ACM                                       ###########  
##################################################################

variable "acm_domain_name" {
  description = "A domain name for which the certificate should be issued"
  type        = string
  default     = "*.antientf.tk"
}

variable "acm_validation_method" {
  description = "Which method to use for validation. DNS or EMAIL are valid, NONE can be used for certificates that were imported into ACM and then into Terraform."
  type        = string
  default     = "DNS"
}
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





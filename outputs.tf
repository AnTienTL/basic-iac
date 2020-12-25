# output "public_ip" {
#   description = "List of public IP addresses assigned to the instances, if applicable"
#   value       = module.ec2.public_ip
# }


# output "this_db_instance_endpoint" {
#   description = "The connection endpoint"
#   value       = module.rds.this_db_instance_endpoint
# }

output "this_acm_certificate_domain_validation_options" {
  description = "The ARN of the certificate"
  value       = module.acm.this_acm_certificate_domain_validation_options
}

# output "this_acm_certificate_arn" {
#   description = "The ARN of the certificate"
#   value       = data.aws_acm_certificate.demo_cert.arn
# }


# output "this_lb_id" {
#   description = "The ID and ARN of the load balancer we created."
#   value       = module.alb.this_lb_id
# }

# output "this_lb_arn" {
#   description = "The ID and ARN of the load balancer we created."
#   value       = module.alb.this_lb_arn
# }

output "this_lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.this_lb_dns_name
}

# output "this_lb_arn_suffix" {
#   description = "ARN suffix of our load balancer - can be used with CloudWatch."
#   value       = module.alb.this_lb_arn_suffix
# }

# output "this_lb_zone_id" {
#   description = "The zone_id of the load balancer to assist with creating DNS records."
#   value       = module.alb.this_lb_zone_id
# }

# output "http_tcp_listener_arns" {
#   description = "The ARN of the TCP and HTTP load balancer listeners created."
#   value       =  module.alb.http_tcp_listener_arns
# }

# output "http_tcp_listener_ids" {
#   description = "The IDs of the TCP and HTTP load balancer listeners created."
#   value       = module.alb.http_tcp_listener_ids
# }

# output "https_listener_arns" {
#   description = "The ARNs of the HTTPS load balancer listeners created."
#   value       = module.alb.https_listener_arns
# }

# output "https_listener_ids" {
#   description = "The IDs of the load balancer listeners created."
#   value       = module.alb.https_listener_ids
# }

# output "target_group_arns" {
#   description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
#   value       = module.alb.target_group_arns
# }

# output "target_group_arn_suffixes" {
#   description = "ARN suffixes of our target groups - can be used with CloudWatch."
#   value       = module.alb.target_group_arn_suffixes
# }

# output "target_group_names" {
#   description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
#   value       = module.alb.target_group_names
# }

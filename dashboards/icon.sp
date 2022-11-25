locals {
  aws_acm_certificate_icon               = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/acm_certificate_light.svg"))
  aws_backup_plan_icon                   = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/backup_plan_light.svg"))
  aws_backup_vault_icon                  = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/backup_vault_light.svg"))
  aws_cloudformation_stack_icon          = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/cloudformation_stack_light.svg"))
  aws_cloudfront_distribution_icon       = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/cloudfront_distribution_light.svg"))
  aws_dynamodb_table_icon                = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/dynamodb_table_light.svg"))
  aws_ebs_snapshot_icon                  = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ebs_snapshot_light.svg"))
  aws_ebs_volume_icon                    = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ebs_volume_light.svg"))
  aws_ec2_ami_icon                       = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ec2_ami_light.svg"))
  aws_ec2_application_load_balancer_icon = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ec2_application_load_balancer_light.svg"))
  aws_ec2_classic_load_balancer_icon     = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ec2_classic_load_balancer_light.svg"))
  aws_ec2_gateway_load_balancer_icon     = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ec2_gateway_load_balancer_light.svg"))
  aws_ec2_instance_icon                  = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ec2_instance_light.svg"))
  aws_ec2_network_interface_icon         = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ec2_network_interface_light.svg"))
  aws_ec2_network_load_balancer_icon     = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ec2_network_load_balancer_light.svg"))
  aws_ec2_transit_gateway_icon           = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ec2_transit_gateway.svg"))
  aws_ecr_image_icon                     = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ecr_image.svg"))
  aws_ecr_repository_icon                = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ecr_repository.svg"))
  aws_ecs_service_icon                   = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ecs_service_light.svg"))
  aws_ecs_task_definition_icon           = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ecs_task_definition.svg"))
  aws_ecs_task_icon                      = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/ecs_task_light.svg"))
  aws_elasticache_cluster_icon           = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/elasticache_cluster_light.svg"))
  aws_emr_cluster_icon                   = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/emr_cluster_light.svg"))
  aws_eventbridge_bus_icon               = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/eventbridge_bus_light.svg"))
  aws_eventbridge_rule_icon              = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/eventbridge_rule_light.svg"))
  aws_fsx_file_system_icon               = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/fsx_file_system.svg"))
  aws_glacier_vault_icon                 = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/glacier_vault_light.svg"))
  aws_iam_role_icon                      = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/iam_role_light.svg"))
  aws_iam_user_icon                      = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/iam_user_light.svg"))
  aws_lambda_function_icon               = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/lambda_function_light.svg"))
  aws_rds_db_cluster_icon                = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/rds_db_cluster_light.svg"))
  aws_rds_db_instance_icon               = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/rds_db_instance_light.svg"))
  aws_s3_access_point_icon               = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/s3_access_point_light.svg"))
  aws_s3_bucket_icon                     = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/s3_bucket_light.svg"))
  aws_sns_topic_icon                     = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/sns_topic_light.svg"))
  aws_sqs_queue_icon                     = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/sqs_queue_light.svg"))
  aws_vpc_eip_icon                       = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/vpc_eip.svg"))
  aws_vpc_endpoint_icon                  = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/vpc_endpoint_light.svg"))
  aws_vpc_flow_log_icon                  = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/vpc_flow_logs_light.svg"))
  aws_vpc_internet_gateway_icon          = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/vpc_internet_gateway_light.svg"))
  aws_vpc_nat_gateway_icon               = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/vpc_nat_gateway_light.svg"))
  aws_vpc_network_acl_icon               = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/vpc_network_acl_light.svg"))
  aws_vpc_peering_connection_icon        = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/vpc_peering_connection.svg"))
  aws_vpc_route_table_icon               = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/vpc_router_light.svg"))
  aws_vpc_vpn_gateway_icon               = format("%s,%s", "data:image/svg+xml;base64", filebase64("./icons/vpc_vpn_gateway_light.svg"))
}
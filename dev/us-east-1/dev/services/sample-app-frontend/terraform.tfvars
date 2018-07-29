terragrunt = {
  terraform {
    source = "git::ssh://git@github.com/gruntwork-io/infrastructure-modules.git//services/ecs-service-with-alb?ref=v0.0.1"
  }

  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies = {
    paths = ["../../vpc", "../ecs-cluster", "../../data-stores/mysql", "../../data-stores/redis", "../../networking/alb-public", "../../../_global/sns-topics", "../../../../us-east-1/_global/sns-topics", "../../../_global/kms-master-key"]
  }
}

service_name = "api-service"
image        = "956021745338.dkr.ecr.us-east-1.amazonaws.com/jim-testing"
version      = "latest"

desired_number_of_tasks = 3
cpu                     = 1024
memory                  = 2048
container_port          = 5000

is_internal_alb             = false
enable_route53_health_check = true
health_check_path           = "/"
health_check_protocol       = "HTTP"
alb_target_group_protocol   = "HTTP" 

alb_listener_rule_configs = [
  {
    port     = 80,
    path     = "/sample-app-frontend*",
    priority = 1000
  },
  {
    port     = 443,
    path     = "/sample-app-frontend*",
    priority = 1000
  },
  {
    port     = 80,
    path     = "/example*",
    priority = 1005
  },
  {
    port     = 443,
    path     = "/example*",
    priority = 1005
  },
]

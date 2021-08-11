############################################################################
# Common tfvars
############################################################################
region              = "eu-west-2"
app_name            = "talentegra"
tf_state_bucket     = "vishnubucket11"
tf_state_bucket_key = "vishnubucket11"
tr_environment_type = "DEVELOPMENT"
tr_resource_owner   = "ismail@digitalq.co.in"

############################################################################
# Autoscaling tfvars
############################################################################
autoscaling_min_size         = 1
autoscaling_max_size         = 6
autoscaling_desired_capacity = 3
health_check_grace_period    = 300
aws_instance_type            = "t2.micro"
image_id                     = "ami-0d26eb3972b7f8c96"
update_default_version       = true

############################################################################
# Load Blancer tfvars
############################################################################
deregistration_delay = 300
domain_name          = "your_domain_here"
target_protocol      = "HTTP"
target_port          = 80

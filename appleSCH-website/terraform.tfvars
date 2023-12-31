# enter names of variable values here.
# note! no space after variable name like so below.
# The syntax below will create my terraform vpc module with the values specified below.
region                      = "eu-west-2"
profile                     = "otillia-aws"
project_name                = "appleSCH-website"
vpc_cidr                    = "10.0.0.0/16"
public_subnet_az1_cidr      = "10.0.0.0/24"
public_subnet_az2_cidr      = "10.0.1.0/24"
private_app_subnet_az1_cidr = "10.0.2.0/24"
private_app_subnet_az2_cidr = "10.0.3.0/24"
private_db_subnet_az1_cidr  = "10.0.4.0/24"
private_db_subnet_az2_cidr  = "10.0.5.0/24"
domain_name                 = "otilliakawuma.com"
alternative_name            = "*.otilliakawuma.com"

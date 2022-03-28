##############################################################################
# Variables File
#
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

variable "prefix" {
  description = "This prefix will be included in the name of most resources."
}
variable "environment" {
  description = "Specifies the environment type. e.g. dev, stg, prd."
}

variable "keypair" {
  description = "Specifies the EC2 keypair"
}

variable "region" {
  description = "The region where the resources are created."
  default     = "ap-southeast-1"
}

variable "iam_role_name" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "AmazonSSMRoleForInstancesQuickSetup"
}

variable "instance_type" {
  description = "Specifies the AWS instance type."
  default     = "t2.micro"
}


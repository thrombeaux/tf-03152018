// same as the example code
variable "cluster_name" {
  description = "The name to use for all the cluster resoureces"
}

// same as the example code
variable "db_remote_state_bucket" {
  description = "The name of the s3 bucket for the db's remote state"
}

// same as the example code
variable "db_remote_state_key" {
  description = "The path for the db's remote state in s3"
}

/*
variable "db_password" {
  default = "The password for the database"
}
*/

// same as the example code
variable "server_port" {
  default = "8080"
}

// same as the example code
variable "instance_type" {
  description = "The type of EC2 instance to run, (e.g. t2.micro)"
}

// same as the example code
variable "min_size" {
  description = "The minimum number of Ec2 instaces to run in the ASG"
}

// same as the example code
variable "max_size" {
  description = "The maximum of ec2 instances to run in the ASG"
}

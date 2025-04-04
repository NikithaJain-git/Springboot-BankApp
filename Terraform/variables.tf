variable "aws_region" {
  default = "eu-west-1" # Change to your desired region
}

variable "instance_type" {
  default = "t2.large"
}

variable "ami_id" {
  default = "ami-0df368112825f8d8f" # Use a valid AMI for your region
}
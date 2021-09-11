variable "AWS_ACCESS_KEY" {
    type = string
    default = "AKIA4NUAXDHOXQJRIUNE"
}

variable "AWS_SECRET_KEY" {
	type = string
        default = "QlI77janPZcyilOwJz9nSbGmcDxgzvs3K/wQvDRA"


}

variable "AWS_REGION" {
default = "eu-west-1"
}

variable "ec2_count" {
  type = number
  default = "2"
}

variable "ec2_ami" {
  default = "ami-0a8e758f5e873d1c1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_id" {}

variable "instance2_id" {}
variable "ami-abhi" {
  type        = string
  description = "AMI ID for the EC2 instance"
  default     = "ami-007855ac798b5175e"

}



variable "type" {
  type        = string
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
  sensitive   = true
}


variable "tags" {
  type = object({
    name = string
    env  = string
  })
  description = "Tags for the EC2 instance"
  default = {
    name = "My Virtual Machine"
    env  = "Dev"
  }
}


# variable "subnet_id" {
#  type        = string
#  description = "Subnet ID for network interface"
#  default     = "subnet-02142405494a6665f"
# }

# variable vpc_id {}



variable "project" {
    type = string                     # The type of the variable, in this case a string
    default = "eks-analytics"                 # Default value for the variable
}

variable "region" {
    type = string
    default = "eu-west-1"
}
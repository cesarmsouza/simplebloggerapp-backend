variable "region" { type = string, default = "us-east-1" }
variable "cluster_name" { type = string, default = "sblog-eks" }
variable "node_desired" { type = number, default = 2 }
variable "node_instance_type" { type = string, default = "t3.medium" }

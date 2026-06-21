variable "cluster_name" {
  type    = string
  default = "final-project-cluster"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Сюди ми передамо private_subnet_ids з модуля VPC"
}
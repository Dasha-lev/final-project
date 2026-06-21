variable "env_name" {
  type        = string
  description = "Назва середовища (dev, stage, prod)"
}

variable "use_aurora" {
  type        = bool
  default     = false
  description = "Якщо true — створюється Aurora Cluster, якщо false — звичайний RDS"
}

# Налаштування двигуна БД (Мають збігатися з вимогами Aurora або RDS у main.tf)
variable "engine" {
  type        = string
  default     = "postgres"
  description = "Двигун БД (postgres, mysql, aurora-postgresql, aurora-mysql)"
}

variable "engine_version" {
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
}

# Сховище (потрібно для звичайного RDS)
variable "allocated_storage" {
  type    = number
  default = 20
}

variable "max_allocated_storage" {
  type    = number
  default = 100
}

# Креденшели
variable "db_name" {
  type    = string
  default = "mydb"
}

variable "db_username" {
  type    = string
  default = "dbuser"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Пароль до бази даних"
}

# Мережеві змінні
variable "vpc_id" {
  type        = string
  description = "ID вашої VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Список приватних підмереж для бази даних"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "CIDR блоки, яким дозволено доступ до БД"
}

variable "db_port" {
  type    = number
  default = 5432
}

# Сім'ї параметрів (Parameter group families)
variable "db_parameter_group_family" {
  type    = string
  default = "postgres15"
}

variable "aurora_parameter_group_family" {
  type    = string
  default = "aurora-postgresql15"
}

variable "multi_az" {
  type    = bool
  default = false
}
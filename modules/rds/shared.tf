# 1. Група підмереж (потрібна і для RDS, і для Aurora)
resource "aws_db_subnet_group" "this" {
  name       = "${var.env_name}-${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.env_name}-${var.db_name}-subnet-group"
  }
}

# 2. Security Group для доступу до бази даних
resource "aws_security_group" "db_sg" {
  name        = "${var.env_name}-${var.db_name}-sg"
  description = "Security group for database access"
  vpc_id      = var.vpc_id

  # Дозволяємо вхідний трафік на порт бази даних з певної CIDR або SG (наприклад, з EKS)
  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    cidr_blocks     = var.allowed_cidr_blocks
  }

  # Вихідний трафік дозволено куди завгодно (стандарт)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_name}-${var.db_name}-sg"
  }
}

# 3. Parameter Group для звичайного RDS (створюється, тільки якщо use_aurora = false)
resource "aws_db_parameter_group" "rds_pg" {
  count  = var.use_aurora ? 0 : 1
  name   = "${var.env_name}-${var.db_name}-rds-pg"
  family = var.db_parameter_group_family

  parameter {
    name  = "max_connections"
    value = "100"
  }

  parameter {
    name  = "log_statement"
    value = "all"
  }

  tags = {
    Name = "${var.env_name}-${var.db_name}-rds-pg"
  }
}

# 4. Parameter Group для Aurora Cluster (створюється, тільки якщо use_aurora = true)
resource "aws_rds_cluster_parameter_group" "aurora_pg" {
  count  = var.use_aurora ? 1 : 0
  name   = "${var.env_name}-${var.db_name}-aurora-pg"
  family = var.aurora_parameter_group_family

  parameter {
    name  = "max_connections"
    value = "200"
  }

  parameter {
    name  = "log_statement"
    value = "all"
  }

  tags = {
    Name = "${var.env_name}-${var.db_name}-aurora-pg"
  }
}
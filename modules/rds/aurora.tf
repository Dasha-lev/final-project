# Сам Кластер (Storage & Control plane)
resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier = "${var.env_name}-${var.db_name}-aurora-cluster"
  engine             = var.engine
  engine_version     = var.engine_version
  database_name      = var.db_name
  master_username    = var.db_username
  master_password    = var.db_password

  # Мережа та налаштування
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.db_sg.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_pg[0].name

  skip_final_snapshot = true

  tags = {
    Name = "${var.env_name}-${var.db_name}-aurora-cluster"
  }
}

# Інстанс всередині кластера (Compute)
resource "aws_rds_cluster_instance" "this" {
  count = var.use_aurora ? 1 : 0

  identifier         = "${var.env_name}-${var.db_name}-aurora-instance"
  cluster_identifier = aws_rds_cluster.this[0].id
  engine             = aws_rds_cluster.this[0].engine
  engine_version     = aws_rds_cluster.this[0].engine_version
  instance_class     = var.instance_class
  
  db_subnet_group_name = aws_db_subnet_group.this.name

  tags = {
    Name = "${var.env_name}-${var.db_name}-aurora-node"
  }
}
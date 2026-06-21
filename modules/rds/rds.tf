resource "aws_db_instance" "this" {
  count = var.use_aurora ? 0 : 1

  identifier           = "${var.env_name}-${var.db_name}-rds"
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  # Креденшели
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Мережа та безпека
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  parameter_group_name   = aws_db_parameter_group.rds_pg[0].name # Беремо перший елемент з count

  # Надійність
  multi_az            = var.multi_az
  skip_final_snapshot = true

  tags = {
    Name = "${var.env_name}-${var.db_name}-rds-instance"
  }
}
output "db_endpoint" {
  description = "Адреса підключення до бази даних"
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].endpoint
}

output "db_security_group_id" {
  description = "ID створеної Security Group"
  value       = aws_security_group.db_sg.id
}
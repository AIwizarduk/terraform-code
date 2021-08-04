output "database_endpoint" {
  description = "Provide the database endpoint"
  value       = "jdbc:postgresql://${aws_db_instance.rds-instance.address}:${aws_db_instance.rds-instance.port}/${aws_db_instance.rds-instance.name}"
}
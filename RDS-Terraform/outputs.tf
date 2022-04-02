output "id" {
  value       = aws_db_instance.postgresql.id
  description = "Id da instância do banco de dados"
}

output "database_security_group_id" {
  value       = aws_security_group.postgresql.id
  description = "Grupo de segurança do banco de dados"
}

output "hosted_zone_id" {
  value       = aws_db_instance.postgresql.hosted_zone_id
  description = "ID da zona para o DNS gerado automaticamente fornecido no endpoint"
}

output "hostname" {
  value       = aws_db_instance.postgresql.address
  description = "Nome do DNS público da instância do banco de dados"
}

output "port" {
  value       = aws_db_instance.postgresql.port
  description = "Porta da instância do banco de dados"
}

output "endpoint" {
  value       = aws_db_instance.postgresql.endpoint
  description = "Nome do DNS público "
}

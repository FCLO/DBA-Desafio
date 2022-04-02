variable "project" {
  default     = "Unknown"
  type        = string
  description = "Nome do projeto a ser armazenado"
}

variable "environment" {
  default     = "Unknown"
  type        = string
  description = "Nome do ambiente o qual a VPC está segmentando"
}

variable "allocated_storage" {
  default     = 20
  type        = number
  description = "Armazenamento alocado para a instância do banco"
}

variable "engine_version" {
  default     = "12.9"
  type        = string
  description = "Versão do banco de dados"
}

variable "instance_type" {
  default     = "db.t2.micro"
  type        = string
  description = "Tipo de instância do banco de dados"
}

variable "storage_type" {
  default     = "gp2"
  type        = string
  description = "Tipo de armazenamento subjacente para o banco de dados"
}

variable "iops" {
  default     = 0
  type        = number
  description = "Quantidade de IOPS provisionadas"
}

variable "vpc_id" {
  type        = string
  description = "ID of VPC para hospedar o banco de dados"
}

variable "database_identifier" {
  type        = string
  description = "Nome da Instância do RDS"
}

variable "snapshot_identifier" {
  default     = ""
  type        = string
  description = "Nome da instância se houver para o qual o banco de dados deve ser criado"
}

variable "database_name" {
  type        = string
  description = "Nome do banco de dados"
}

variable "database_username" {
  type        = string
  description = "Nome do usuário"
}

variable "database_password" {
  type        = string
  description = "Senha de acesso ao banco de dados"
}

variable "database_port" {
  default     = 5432
  type        = number
  description = "Porta a qual o banco de dados aceitará as conexões"
}

variable "backup_retention_period" {
  default     = 30
  type        = number
  description = "Dias para manter o backup do banco de dados"
}

variable "backup_window" {
  # 12:00AM-12:30AM ET
  default     = "02:00-02:30"
  type        = string
  description = "Janela de tempo a resevar para realizar o backup do banco de dados(30min)"
}

variable "maintenance_window" {
  # SUN 12:30AM-01:30AM ET
  default     = "sun:03:30-sun:04:30"
  type        = string
  description = "Janela de tempo reservada para a manutenção (60 min)"
}

variable "auto_minor_version_upgrade" {
  default     = false
  type        = bool
  description = "Atualizações a serem realizadas durante as janelas de manutenção"
}
/*
variable "final_snapshot_identifier" {
  default     = "terraform-aws-postgresql-rds-snapshot"
  type        = string
  description = "Identificador final de snapshop setado como false"
}

variable "skip_final_snapshot" {
  default     = false
  type        = bool
  description = "Habilitar ou não a criação de um snapshot ao encerrar um banco de dados"
}*/

variable "copy_tags_to_snapshot" {
  default     = false
  type        = bool
  description = "Ativar ou desativar a cópia das tags de instância para o snapshot final"
}

variable "multi_availability_zone" {
  default     = true
  type        = bool
  description = "Habilitação de outras zonas de disponibilidade"
}

variable "storage_encrypted" {
  default     = false
  type        = bool
  description = "Habilitar criptografia de armazenamento"
}

variable "monitoring_interval" {
  default     = 0
  type        = number
  description = "Intervalo, em segundos, entre os pontos em que as métricas de monitoramento são coletadas"
}

variable "deletion_protection" {
  default     = false
  type        = bool
  description = "Habilitar a proteção do banco de dados contra exclusão"
}
/*
variable "cloudwatch_logs_exports" {
  default     = ["postgresql", "upgrade"]
  type        = list(any)
  description = "Lista de logs para publicar no CloudWatch "
}*/

/*variable "subnet_group" {
  type        = string
  description = "Grupo de sub-rede do banco de dados"
}*/

variable "parameter_group" {
  default     = "default.postgres12"
  type        = string
  description = "Grupo de parâmetros do banco de dados"
}
/*
variable "alarm_cpu_threshold" {
default     = 75
 type        = number
 description = "Limite de alarme da CPU em porcentagem"
}

variable "alarm_disk_queue_threshold" {
default     = 10
type        = number
 description = "Limite de alarme da fila de disco"
}
variable "alarm_free_disk_threshold" {
 7GB
 default     = 7000000000
type        = number
 description = "Limite de alarme de disco livre em bytes"
}

variable "alarm_free_memory_threshold" {
 256MB
 default     = 256000000
type        = number
 description = "Limite de alarme de memória livre em bytes"
}

variable "alarm_cpu_credit_balance_threshold" {
 default     = 30
type        = number
 description = "Limite de saldo de crédito de CPU (somente para tipos de instância db.t*)
"
}

variable "alarm_actions" {
 type        = list
 description = "
Lista de ARNs a serem notificados via CloudWatch quando o alarme entrar no estado ALARM"
}

variable "ok_actions" {
 type        = list
description = "Lista de ARNs a serem notificados via CloudWatch quando o alarme entrar no estado OK"
}

variable "insufficient_data_actions" {
 type        = list
 description = "
Lista de ARNs a serem notificados via CloudWatch quando o alarme entrar no estado INSUFFICIENT_DATA"
}
*/
/*variable "tags" {
  default     = {}
  type        = map(string)
  description = "Tags extras para anexar aos recursos do RDS"
}*/

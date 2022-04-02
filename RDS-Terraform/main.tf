provider "aws" {
  region     = "sa-east-1"
  access_key = "AKIAZYGQ2EFVPXE5VJCP"
  secret_key = "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"
}

# Criando um server

/*resource "aws_instance" "server1" {
ami           = "ami-090006f29ecb2d79a"
instance_type = "t2.micro"
tags = {
  name = "stn.isntance"
 }
}

resource "aws_vpc" "vpc1" {
cidr_block = "10.0.0.0/16"
tags = {
  name = "dev"

 }
}*/

/*
resource "aws_vpc" "vpc2" {
cidr_block = "10.1.0.0/16"
tags = {
  name = "dev"

 }
}
resource "aws_subnet" "principal" {
vpc_id     = aws_vpc.vpc1.id
cidr_block = "10.0.1.0/24"

tags = {
  Name = "dev-subnet"
 }
}
resource "aws_subnet" "principal2" {
vpc_id     = aws_vpc.vpc2.id
cidr_block = "10.1.1.0/24"

tags = {
  Name = "dev2-subnet"
 }
}
resource "aws_vpc" "dev-vpc" { 
 cidr_block = "10.0.0.0/16"
tags = {
 name = "dev"
}
}
# Criando um gateway
resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.dev-vpc.id

}

resource "aws_route_table" "dev-rote-table" {
 vpc_id = aws_vpc.dev-vpc.id

route {
 cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.gw.id
}

route {
 ipv6_cidr_block        = "::/0"
 egress_only_gateway_id = aws_internet_gateway.gw.id
}

tags = {
 Name = "dev"
}
}
resource "aws_subnet" "subnet-1" {
 vpc_id            = aws_vpc.dev-vpc.id
cidr_block        = "10.0.1.0/24"
availability_zone = "sa-east-1a"
tags = {
  name = "dev-subnet"
}
}

resource "aws_route_table_association" "a" {
 subnet_id      = aws_subnet.subnet-1.id
route_table_id = aws_route_table.dev-rote-table.id
}
*/
/*
# Criando um grupo de segurança
resource "aws_security_group" "security" {
 name        = "security"
description = "Tráfego da rede"
vpc_id      = aws_vpc.dev-vpc.id

ingress {
 description = "HTTPS"
from_port   = 443
to_port     = 443
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]
ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
}

ingress {
 description = "HTTP"
from_port   = 80
to_port     = 80
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]
ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
}

ingress {
 description = "SSH"
 from_port   = 22
to_port     = 22
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]
ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
}

egress {
 from_port   = 0
 to_port     = 0
 protocol    = "-1"
 cidr_blocks = ["0.0.0.0/0"]
#ipv6_cidr_blocks = ["::/0"]
}

tags = {
 Name = "allow_web"
}
}

resource "aws_network_interface" "server-web" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]


}
resource "aws_eip" "one" {
  vpc                       = true
 network_interface         = aws_network_interface.server-web.id
 associate_with_private_ip = "10.0.1.50"
depends_on                = [aws_internet_gateway.gw]

}

resource "aws_instance" "web-server-instance" {
 ami               = "ami-090006f29ecb2d79a"
instance_type     = "t2.micro"
availability_zone = "sa-east-1a"
key_name          = "acc-key"


network_interface {
 device_index         = 0
network_interface_id = aws_network_interface.server-web.id
}
user_data = <<-EOF
         #!/bin/bash
        sudo apt update -y
       sudo apt install apache -y
      sudo systemctl start  apache2
     sudo basj -c 'echo very  fist web server > /var/www/html/index.html'
    EOF

tags = {
Name = "web-server"
}
}


*/

/*
    Recursos IAM
*/

data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "enhanced_monitoring" {
  name               = "rds${var.environment}EnhancedMonitoringRole"
  assume_role_policy = data.aws_iam_policy_document.enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  role       = aws_iam_role.enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

/*
   Recursos do grupo de segurança
*/


resource "aws_security_group" "postgresql" {
  vpc_id = var.vpc_id
}
/*tags = merge(
    {
      Name        = "sgDatabaseServer",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}*/

/*
  Recursos do RDS 
*/
resource "aws_db_instance" "postgresql" {
  allocated_storage          = var.allocated_storage
  engine                     = "postgres"
  engine_version             = var.engine_version
  identifier                 = var.database_identifier
  snapshot_identifier        = var.snapshot_identifier
  instance_class             = var.instance_type
  storage_type               = var.storage_type
  iops                       = var.iops
  name                       = var.database_name
  password                   = var.database_password
  username                   = var.database_username
  backup_retention_period    = var.backup_retention_period
  backup_window              = var.backup_window
  maintenance_window         = var.maintenance_window
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  #final_snapshot_identifier       = var.final_snapshot_identifier
  skip_final_snapshot    = var.skip_final_snapshot
  copy_tags_to_snapshot  = var.copy_tags_to_snapshot
  multi_az               = var.multi_availability_zone
  port                   = var.database_port
  vpc_security_group_ids = [aws_security_group.postgresql.id]
  #db_subnet_group_name            = var.subnet_group
  parameter_group_name = var.parameter_group
  storage_encrypted    = var.storage_encrypted
  monitoring_interval  = var.monitoring_interval
  monitoring_role_arn  = var.monitoring_interval > 0 ? aws_iam_role.enhanced_monitoring.arn : ""
  deletion_protection  = var.deletion_protection
  #enabled_cloudwatch_logs_exports = var.cloudwatch_logs_exports
}
/*tags = merge(
    {
      Name        = "DatabaseServer",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}*/

/*
   Recursos do cloudwatch
*/
/*resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  alarm_name          = "alarm${var.environment}DatabaseServerCPUUtilization-${var.database_identifier}"
  alarm_description   = "Database server CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.alarm_cpu_threshold

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.postgresql.id
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
}

resource "aws_cloudwatch_metric_alarm" "database_disk_queue" {
  alarm_name          = "alarm${var.environment}DatabaseServerDiskQueueDepth-${var.database_identifier}"
  alarm_description   = "Database server disk queue depth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_disk_queue_threshold

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.postgresql.id
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
}

resource "aws_cloudwatch_metric_alarm" "database_disk_free" {
  alarm_name          = "alarm${var.environment}DatabaseServerFreeStorageSpace-${var.database_identifier}"
  alarm_description   = "Database server free storage space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_free_disk_threshold

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.postgresql.id
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
}

resource "aws_cloudwatch_metric_alarm" "database_memory_free" {
  alarm_name          = "alarm${var.environment}DatabaseServerFreeableMemory-${var.database_identifier}"
  alarm_description   = "Database server freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_free_memory_threshold

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.postgresql.id
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
}

resource "aws_cloudwatch_metric_alarm" "database_cpu_credits" {
 count = substr(var.instance_type, 0, 3) == "db.t" ? 1 : 0

alarm_name          = "alarm${var.environment}DatabaseCPUCreditBalance-${var.database_identifier}"
alarm_description   = "Database CPU credit balance"
comparison_operator = "LessThanThreshold"
evaluation_periods  = "1"
metric_name         = "CPUCreditBalance"
namespace           = "AWS/RDS"
period              = "60"
statistic           = "Average"
threshold           = var.alarm_cpu_credit_balance_threshold

 dimensions = {
   DBInstanceIdentifier = aws_db_instance.postgresql.id
  }

alarm_actions             = var.alarm_actions
ok_actions                = var.ok_actions
insufficient_data_actions = var.insufficient_data_actions
}

*/


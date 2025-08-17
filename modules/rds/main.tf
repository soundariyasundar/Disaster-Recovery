terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_db_subnet_group" "db" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "db" {
  identifier             = "${var.name}-rds"
  engine                 = "mysql"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = var.vpc_security_group_ids
  multi_az               = var.multi_az
  storage_encrypted      = true
  skip_final_snapshot    = false
  final_snapshot_identifier = "rds-db-snap"
  publicly_accessible    = false
  tags = { Name = "${var.name}-rds" }
  backup_retention_period = 30
  monitoring_interval = 60
  monitoring_role_arn = var.monitoring_role_arn
}

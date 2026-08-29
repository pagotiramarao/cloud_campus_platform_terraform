resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-cloudcampus-db-subnet-group"
  subnet_ids = var.private_data_subnet_ids

  tags = {
    Name        = "${var.environment}-cloudcampus-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "this" {
  identifier = "${var.environment}-cloudcampus-postgres"

  engine         = "postgres"
  engine_version = "16"

  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"

  db_name  = var.db_name
  username = var.username

  # RDS generates and manages the master password
  # in AWS Secrets Manager.
  manage_master_user_password = true

  port = 5432

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.security_group_id]

  publicly_accessible = false

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name        = "${var.environment}-cloudcampus-postgres"
    Environment = var.environment
  }
}

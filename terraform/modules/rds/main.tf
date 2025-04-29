resource "aws_security_group" "rds_sg" {
  name        = "task-ce-rds-sg"
  description = "Allow RDS access"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow PostgreSQL"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [
      var.backend_sg_id,
      var.eks_node_sg_id,
      var.bastion_sg_id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_password" "db_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}

resource "aws_secretsmanager_secret" "db_credentials" {
  description             = "Database credentials stored"
  name                    = "db_credentials7"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "sumdbuser"
    password = random_password.db_password.result
    dbname   = "sumdb"
  })
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "task-ce-db-subnet-group"
  description = "RDS subnet group for sumdb"
  subnet_ids  = var.private_subnet_ids

  tags = {
    Name        = "task-ce-db-subnet-group"
    Environment = "dev"
  }
}

resource "aws_kms_key" "rds_kms_key" {
  description = "KMS key for encrypting RDS storage for task-ce project"
  deletion_window_in_days = 10
  enable_key_rotation = true
}

resource "aws_kms_alias" "rds_kms_alias" {
  name = "alias/task-ce-rds-kms"
  target_key_id = aws_kms_key.rds_kms_key.id
}

# IAM role for Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring_role" {
  name = "task-ce-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the necessary policy for Enhanced Monitoring to the IAM role
resource "aws_iam_policy_attachment" "rds_monitoring_policy_attachment" {
  name       = "rds-monitoring-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  roles      = [aws_iam_role.rds_monitoring_role.name]
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.11.0"

  identifier = "sumdb-instance"

  engine            = "postgres"
  engine_version    = "15"
  family            = "postgres15"
  instance_class    = var.rds_instance_class
  allocated_storage = 20

  # Fetch DB credentials from AWS Secrets Manager
  db_name  = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string).dbname
  username = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string).username
  password = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string).password

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  subnet_ids             = var.private_subnet_ids
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  publicly_accessible = false
  storage_encrypted = true
  kms_key_id = aws_kms_key.rds_kms_key.arn
  skip_final_snapshot = true
  backup_retention_period = 1
  manage_master_user_password = false

  # Enable Enhanced Monitoring
  monitoring_interval       = 60  # Monitoring interval in seconds (60 seconds)
  monitoring_role_arn       = aws_iam_role.rds_monitoring_role.arn  # The role ARN for monitoring

  tags = {
    Terraform   = "true"
    Name        = "ce-task-rds-sumdb"
    Environment = "dev"
  }
}

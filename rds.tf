resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1c.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage                     = 20
  allow_major_version_upgrade           = true
  apply_immediately                     = true
  auto_minor_version_upgrade            = false
  availability_zone                     = "ap-northeast-1c"
  backup_retention_period               = 0
  backup_target                         = "region"
  ca_cert_identifier                    = "rds-ca-rsa2048-g1"
  copy_tags_to_snapshot                 = true
  customer_owned_ip_enabled             = false
  db_name                               = "simplememo"
  db_subnet_group_name                  = aws_db_subnet_group.default.name
  dedicated_log_volume                  = false
  delete_automated_backups              = true
  deletion_protection                   = false
  engine                                = "mariadb"
  engine_version                        = "10.4.34"
  iam_database_authentication_enabled   = false
  identifier                            = "rds-ecs"
  instance_class                        = "db.t4g.micro"
  iops                                  = 0
  kms_key_id                            = "arn:aws:kms:ap-northeast-1:468415095331:key/cd0ce88f-c29c-43c0-8b47-7e8214c5e317"
  license_model                         = "general-public-license"
  max_allocated_storage                 = 0
  monitoring_interval                   = 0
  multi_az                              = false
  network_type                          = "IPV4"
  password                              = var.db_password
  performance_insights_enabled          = false
  performance_insights_retention_period = 0
  port                                  = 3306
  publicly_accessible                   = false
  skip_final_snapshot                   = true
  storage_encrypted                     = true
  storage_throughput                    = 0
  storage_type                          = "gp2"
  username                              = "admin"
  vpc_security_group_ids                = [aws_security_group.rds_sg.id]
}

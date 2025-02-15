resource "aws_ecr_repository" "service" {
  image_tag_mutability = "MUTABLE"
  name                 = "laravelecs"
  encryption_configuration {
    encryption_type = "AES256"
  }
  image_scanning_configuration {
    scan_on_push = true
  }
}

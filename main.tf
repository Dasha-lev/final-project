provider "aws" {
  region = "eu-central-1"
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "daria-levchuk-tf-state-2026" 
  table_name  = "terraform-locks"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_name           = "lesson-8-9-vpc"
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = "lesson-8-9-ecr"
  scan_on_push    = true
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = "lesson-8-9-eks-cluster"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids
}

module "jenkins" {
  source       = "./modules/jenkins"
  cluster_name = module.eks.cluster_name
}

module "argo_cd" {
  source       = "./modules/argo_cd"
  cluster_name = module.eks.cluster_name
}

# =================================================================
# Модуль Бази Даних (RDS / Aurora)
# =================================================================
module "rds" {
  source     = "./modules/rds"
  env_name   = "dev"
  
  # Головний прапорець із завдання:
  # true  -> створить кластер Aurora
  # false -> створить звичайну одиночну базу RDS
  use_aurora = false 

  # Конфігурація двигуна
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.micro"

  # Зв'язок із мережею VPC
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids # Тепер назва точна! ✅
  allowed_cidr_blocks = ["10.0.0.0/16"]

  # Креденшели для підключення
  db_name     = "djangodb"
  db_username = "dbadmin"
  db_password = "MySuperSecurePassword2026"
}
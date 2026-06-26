# output "s3_bucket_name" {
#  value = module.s3_backend.s3_bucket_id
#}

#output "dynamodb_table_name" {
#  value = module.s3_backend.dynamodb_table_name
#}

#output "vpc_id" {
#  value = module.vpc.vpc_id
#}

#output "ecr_repository_url" {
#  value = module.ecr.repository_url
#}

output "cluster_id" {
  description = "The ID/name of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS Kubernetes API"
  value       = module.eks.cluster_endpoint
}
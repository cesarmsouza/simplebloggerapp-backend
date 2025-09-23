output "cluster_name" { value = module.eks.cluster_name }
output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}"
}
output "ingress_nginx_lb_hostname" {
  value = try(helm_release.ingress_nginx.status[0].notes, "Check AWS console for LB hostname")
  description = "Use o hostname do LB do serviço ingress-nginx-controller"
}

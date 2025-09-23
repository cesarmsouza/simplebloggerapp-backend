module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.8"

  name = "sblog-vpc"
  cidr = "10.50.0.0/16"

  azs             = ["us-east-1a","us-east-1b"]
  private_subnets = ["10.50.1.0/24","10.50.2.0/24"]
  public_subnets  = ["10.50.11.0/24","10.50.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.12"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  eks_managed_node_groups = {
    ng1 = {
      name                          = "ng1"
      instance_types                = [var.node_instance_type]
      desired_size                  = var.node_desired
      min_size                      = 1
      max_size                      = 4
      iam_role_name                 = "sblog-ng1-role" # curto para evitar erro de comprimento
    }
  }
}

# Ingress NGINX (via Helm)
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  namespace  = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.11.2"

  create_namespace = true

  # Para AWS: usar Service type=LoadBalancer
  values = [yamlencode({
    controller = {
      service = {
        type = "LoadBalancer"
        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb" # NLB é estável
        }
      }
    }
  })]
}

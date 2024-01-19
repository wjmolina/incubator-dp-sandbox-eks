terraform {
  backend "s3" {
    bucket = "wmolina-terraform"
    key    = "wmolina-sandbox-eks.tfstate"
  }
}

module "eks-module" {
  source = "git::https://github.com/wjmolina/terraform-eks.git?ref=945822c"

  default_tags = {
    user        = "wmolina"
    service     = "eks"
    description = "learning eks"
  }

  vpc_name           = "wmolina-sandbox-eks-vpc"
  cluster_name       = "wmolina-sandbox-eks"
  availability_zones = ["us-west-2a", "us-west-2b"]
  cidr               = "11.0.0.0/16"
  private_subnets    = ["11.0.0.0/24", "11.0.1.0/24"]
  public_subnets     = ["11.0.2.0/24", "11.0.3.0/24"]

  default_security_group_ingress = [
    {
      from_port       = 30000
      to_port         = 32767
      protocol        = "tcp"
      cidr_blocks     = "0.0.0.0/0"
      security_groups = [module.eks-module.default_security_group_id]
    }
  ]

  eks_managed_node_groups = {
    default = {
      min_size       = 1
      max_size       = 1
      desired_size   = 1
      instance_types = ["t2.small"]
    }
  }
}

terraform {
  backend "s3" {
    bucket = "wmolina-terraform"
    key    = "wmolina-eks/terraform.tfstate"
  }
}

module "eks-module" {
  source = "git::https://github.com/wjmolina/eks-module.git?ref=8d6bb9b"

  default_tags = {
    user        = "wmolina"
    service     = "eks"
    description = "learning eks"
  }

  vpc_name           = "wmolina-vpc"
  cluster_name       = "wmolina-eks"
  availability_zones = ["us-west-2a", "us-west-2b"]
  cidr               = "11.0.0.0/16"
  private_subnets    = ["11.0.0.0/24", "11.0.1.0/24"]
  public_subnets     = ["11.0.2.0/24", "11.0.3.0/24"]

  eks_managed_node_groups = {
    default = {
      min_size       = 1
      max_size       = 1
      desired_size   = 1
      instance_types = ["t2.nano"]
    }
  }
}

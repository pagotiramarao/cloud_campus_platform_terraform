locals {

  common_tags = {
    Project     = "cloud-campus-digital-platform"
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  public_subnets = {
    public-a = {
      az            = var.availability_zones[0]
      subnet_number = 1
    }
    public-b = {
      az            = var.availability_zones[1]
      subnet_number = 2
    }
  }

  private_app_subnets = {
    app-a = {
      az            = var.availability_zones[0]
      subnet_number = 11
    }
    app-b = {
      az            = var.availability_zones[1]
      subnet_number = 12
    }
  }

  private_data_subnets = {
    data-a = {
      az            = var.availability_zones[0]
      subnet_number = 21
    }
    data-b = {
      az            = var.availability_zones[1]
      subnet_number = 22
    }
  }

}
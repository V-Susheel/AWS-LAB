terraform {
  backend "s3" {
    bucket       = "sv-tfstate-25677"
    key          = "lab7/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}

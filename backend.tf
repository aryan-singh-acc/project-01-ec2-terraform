terraform {
  backend "s3" {
    bucket       = "aryan-w-singh-project-18-capstone"
    key          = "project-18/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}

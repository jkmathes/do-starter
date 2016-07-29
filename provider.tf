variable "do_api_key" {}
variable "public_key" {}
variable "private_key" {}
variable "deploy_public_key" {}
variable "deploy_private_key" {}
variable "deploy_passwd" {}

provider "digitalocean" {
  token = "${var.do_api_key}"
}

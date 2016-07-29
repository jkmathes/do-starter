output "ip" {
  value = "${digitalocean_droplet.test.public_ip}"
}

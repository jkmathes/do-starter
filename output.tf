output "ip" {
  value = "${digitalocean_droplet.test.ipv4_address}"
}

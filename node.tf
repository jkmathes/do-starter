resource "digitalocean_ssh_key" "default" {
  name = "TF SSH Key"
  public_key = "${file("${var.public_key}")}"
}

resource "digitalocean_droplet" "test" {
  image = "ubuntu-14-04-x64"
  name = "test"
  region = "nyc1"
  size = "512mb"
  private_networking = true
  ssh_keys = [
    "${digitalocean_ssh_key.default.fingerprint}"
  ]
  connection {
    user = "root"
    type = "ssh"
    key_file = "${var.private_key}"
    timeout = "2m"
  }
  provisioner "remote-exec" {
    inline = [

      # Update software
      "apt-get update",
      "apt-get -y upgrade",

      # Add 'deploy' user
      "useradd deploy",
      "mkdir /home/deploy",
      "mkdir /home/deploy/.ssh",
      "chmod 700 /home/deploy/.ssh",
      "usermod -s /bin/bash deploy",
      "echo \"${file("${var.deploy_public_key}")}\" > /home/deploy/.ssh/authorized_keys",
      "chmod 400 /home/deploy/.ssh/authorized_keys",
      "chown deploy:deploy /home/deploy -R",
      "echo 'deploy:${var.deploy_passwd}' | chpasswd",
      "usermod -aG sudo deploy"
    ]
  }
}

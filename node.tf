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
      "usermod -aG sudo deploy",

      # Comment out existing PermitRootLogin and add a 'no'
      "sed -i /PermitRootLogin/s/^/#/ /etc/ssh/sshd_config",
      "echo \"PermitRootLogin no\" >> /etc/ssh/sshd_config",

      # Comment out existing PasswordAuthentication and add a 'no'
      "sed -i /PasswordAuthentication/s/^/#/ /etc/ssh/sshd_config",
      "echo \"PasswordAuthentication no\" >> /etc/ssh/sshd_config",

      # Comment out existing AllowUsers and add the deploy user
      "sed -i /AllowUsers/s/^/#/ /etc/ssh/sshd_config",
      "echo \"AllowUsers deploy@${var.external_ip}\" >> /etc/ssh/sshd_config",

      # Comment out AddressFamily config
      "sed -i /AddressFamily/s/^/#/ /etc/ssh/sshd_config",
      "echo \"AddressFamily inet\" >> /etc/ssh/sshd_config",

      # Enable IPv6 in UFW
      "sed -i /IPV6/s/^/#/ /etc/default/ufw",
      "echo \"IPV6=yes\" >> /etc/default/ufw",

      # Modify firewall settings further
      "ufw allow from ${var.external_ip} to any port 22",
      "ufw allow 80",
      "ufw allow 443",
      "ufw disable",
      "ufw --force enable",

      # Add automated security updates
      "apt-get install -y unattended-upgrades",
      "echo \"${file("periodic.gold")}\" > /etc/apt/apt.conf.d/10periodic",
      "echo \"${file("unattended.gold")}\" > /etc/apt/apt.conf.d/50unattended-upgrades",

      "apt-get install -y fail2ban",

      # Restart the ssh service and close it out
      "service ssh restart"
    ]
  }
}

# 1. On dit à Terraform qu'on utilise Scaleway
terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
    }
    local = {
      source = "hashicorp/local" # Pour générer le fichier Ansible
    }
  }
}

# 2. Configuration du fournisseur (les clés seront lues depuis ton terminal)
provider "scaleway" {
  zone   = "fr-par-1" # Paris
  region = "fr-par"
}

# 3. On réserve une IP Publique
resource "scaleway_instance_ip" "cloud1_ip" {}

# 4. On crée le Serveur !
resource "scaleway_instance_server" "cloud1_server" {
  name  = "cloud1-prod"
  type  = "DEV1-S"
  image = "ubuntu_focal"
  ip_id = scaleway_instance_ip.cloud1_ip.id
}

# 5. On génère l'inventaire pour Ansible (Gère le Local ET la Prod)
resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory.ini"
  
  content = <<EOT
[local]
127.0.0.1 ansible_connection=local env=local

[prod]
${scaleway_instance_ip.cloud1_ip.address} ansible_user=root env=prod
EOT
}
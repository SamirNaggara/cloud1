# Cloud-1

Déploiement d'un WordPress en production sur Scaleway, entièrement automatisé : l'infrastructure est créée par Terraform, la machine est configurée par Ansible, et l'application tourne en conteneurs Docker derrière nginx en TLS. Projet du master architecte des systèmes d'information à 42, spécialité réseaux et sécurité.

Aucune étape manuelle : `terraform apply` crée le serveur, `ansible-playbook` installe tout le reste.

## Architecture

```text
terraform/   création du serveur et du réseau sur Scaleway
ansible/
  roles/setup      durcissement de base de la machine
  roles/docker     installation de Docker
  roles/wordpress  déploiement de WordPress, MariaDB, phpMyAdmin
  roles/ssl        certificats TLS
docker-compose.yaml  nginx, WordPress, base de données
nginx/               configuration du reverse proxy
```

## Les secrets ne sont pas dans le dépôt

Les identifiants (clés Scaleway, mots de passe base et admin) vivent dans des fichiers ignorés par git : les variables d'environnement `SCW_*` pour Terraform, et `ansible/secrets.yml` pour Ansible. Ce dépôt ne contient que la structure et des exemples.

## Déployer

```bash
export SCW_ACCESS_KEY=... SCW_SECRET_KEY=... SCW_DEFAULT_PROJECT_ID=...

cd terraform && terraform init && terraform apply -auto-approve
cd ../ansible && ansible-playbook -i inventory.ini playbook.yml -e "@secrets.yml" --limit prod
```

`terraform destroy` détruit toute l'infrastructure.

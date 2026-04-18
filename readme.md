Déploiement Cloud-1

Clef Scaleway

    export SCW_ACCESS_KEY="VOTRE_ACCESS_KEY"
    export SCW_SECRET_KEY="VOTRE_SECRET_KEY"
    export SCW_DEFAULT_PROJECT_ID="VOTRE_PROJECT_ID"

Fichier : ansible/secrets.yml (PROD)

    	db_name: "wordpress"
    	db_user: "utilisateur_wp"
    	db_password: "MON_MOT_DE_PASSE_DB"
    	db_root_password: "MON_MOT_DE_PASSE_ROOT"
    	main_domain: "cloud2.codeyourlife.fr"

    	wp_title: "Mon Super site"
    	wp_admin_user: "cloud_admin"
    	wp_admin_password: "MON_MOT_DE_PASSE_ADMIN"
    	wp_admin_email: "admin@codeyourlife.fr"

Fichier : ansible/secrets-local.yml (LOCAL)

    	db_name: "wordpress"
    	db_user: "utilisateur_wp"
    	db_password: "MON_MOT_DE_PASSE_DB_LOCAL"
    	db_root_password: "MON_MOT_DE_PASSE_ROOT_LOCAL"
    	main_domain: "cloud.local"

    	wp_title: "Mon Super site local"
    	wp_admin_user: "cloud_admin"
    	wp_admin_password: "MON_MOT_DE_PASSE_ADMIN_LOCAL"
    	wp_admin_email: "admin@codeyourlife.fr"

3.  Création de l'infrastructure (Terraform)

        	cd terraform
        	terraform init
        	terraform apply -auto-approve

4.  Configuration DNS (PROD)

        	cloud2.codeyourlife.fr ➔ [NOUVELLE_IP]
        	pma.cloud2.codeyourlife.fr ➔ [NOUVELLE_IP]


        	sudo vim /etc/hosts
        	[NOUVELLE_IP] cloud2.codeyourlife.fr pma.cloud2.codeyourlife.fr

5.  Déploiement (Ansible)

        	cd ../ansible
        	ansible-playbook -i inventory.ini playbook.yml -e "@secrets.yml" --limit prod

Pour le LOCAL :

    		cd ../ansible
    		ansible-playbook -i inventory.ini playbook.yml -e "@secrets-local.yml" --limit local -k

6.  Destruction de l'environnement

        	cd ../terraform
        	terraform destroy -auto-approve

🛠️ Commandes utiles de débug

Si la meme IP a deja été donné
ssh-keygen -R <L_ADRESSE_IP>

Consulter les logs des conteneurs sur le serveur :

cd /opt/cloud1
docker compose logs nginx
docker compose logs wordpress

#!/bin/zsh

# Pull down changes from origin GitHub repo to GCP VM
if gcloud compute ssh "postgresql-1-vm" --zone "us-west1-a" --command "cd hubmap; git pull"; then : nothing; fi

# Securely copy remaining source data to VM using gcloud tools
if gcloud compute scp --recurse ~/Documents/work/HuBMAP/dev/data-portal/db/data "postgresql-1-vm:~/hubmap/db" --zone "us-west1-a"; then : nothing; fi

# Not copying the config file with environment-specific and sensitive information (copy manually instead)

# Rebuild database from scratch on VM
if gcloud compute ssh "postgresql-1-vm" --zone "us-west1-a" --command "cd hubmap/db/scripts; ./build-database.sh"; then : nothing; fi

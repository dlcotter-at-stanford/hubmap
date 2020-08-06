#!/bin/zsh

# Debugging options
set VERBOSE
set XTRACE

# Pull down changes from origin GitHub repo to GCP VM
if gcloud compute ssh "postgresql-1-vm" --zone "us-west1-a" --command "cd biolab; git pull"; then : nothing; fi

# Securely copy remaining source data to VM using gcloud tools
if gcloud compute scp --recurse ~/Documents/work/HuBMAP/dev/data-portal/db/data "postgresql-1-vm:~/biolab/db" --zone "us-west1-a"; then : nothing; fi

# Not copying the config file with environment-specific and sensitive information (copy manually instead)

# Rebuild database from scratch on VM
if gcloud compute ssh "postgresql-1-vm" --zone "us-west1-a"\
   --command "cd biolab;\
              source config.sh;\
              cd db/scripts;\
              APP_PS=$(ps aux | grep -E 'python app\.py$' | tr -s ' ' | cut -d' ' -f2);\
              if [ $APP_PS > 0 ]; then kill $APP_PS 2>/dev/null; fi;\
              ./build-database.sh;\
              cd ../../web;\
              ./run-app.sh";
then : nothing;
fi

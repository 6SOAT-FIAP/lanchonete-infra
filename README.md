terraform init

terraform plan -var 'registry_password=<YOUR_DOCKER_HUB_PASSWORD>'

terraform apply -var 'registry_password=<YOUR_DOCKER_HUB_PASSWORD>' -auto-approve

kubectl get all -n lanchonete-api-ns




------------------------------------------


terraform init -upgrade

terraform plan -out terraform.plan

terraform apply terraform.plan

terraform destroy terraform.plan
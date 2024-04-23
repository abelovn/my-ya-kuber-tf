Simple implementation of preparing three virtual machines in the Yandex cloud via terraform 

And configuring and provisioning a Kubernetes cluster via Ansible roles

This example is a test case without security groups and NFS server



## Pre-requirements

To run this project, you will need to prepare your yandex cloud, 


and then set environment variables:
```
export TF_VAR_yc_token=$(yc iam create-token)
export TF_VAR_yc_cloud_id=$(yc config get cloud-id)
export TF_VAR_yc_folder_id=$(yc config get folder-id)
```
in this case the terraform.tfvars file is not needed


Also be sure that there is a private/public key mapping at the path ~/.ssh/id_rsa,
else do it via 
```
ssh-keygen
```



## Deployment

To deploy this project run

```bash
  git clone https://github.com/abelovn/my-ya-kuber-tf.git && cd  my-ya-kuber-tf/terraform/ && terraform init && terraform plan && terraform apply  -auto-approve 
```
after terraform deploy

go to the ansible directory and run the playbook: ansible-playbook setup.yaml

```
  ansible-playbook setup.yaml
```
###

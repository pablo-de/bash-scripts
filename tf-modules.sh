#!/bin/bash

#This script download the latest version of terraform modules from github and push to gitlab repository.

#Variables.
TF_DIR_TPM="/home/$USER/Practicas/bash/tf/github-repo"
TF_MODULES_DIR="/home/$USER/Practicas/bash/tf/modules"

TF_S3_REPO="https://github.com/terraform-aws-modules/terraform-aws-s3-bucket"
TF_APIGATEWAY_REPO="https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2"
TF_ECR_REPO="https://github.com/terraform-aws-modules/terraform-aws-ecr"
TF_SECURITYGROUP_REPO="https://github.com/terraform-aws-modules/terraform-aws-security-group"
TF_EC2_REPO="https://github.com/terraform-aws-modules/terraform-aws-ec2-instance"
TF_EKS_REPO="https://github.com/terraform-aws-modules/terraform-aws-eks"
TF_RDS_REPO="https://github.com/terraform-aws-modules/terraform-aws-rds"
TF_VPC_REPO="https://github.com/terraform-aws-modules/terraform-aws-vpc"

#Check if the directories exists if not create it.
if [ ! -d "$TF_MODULES_DIR" ]; then
    mkdir -p "$TF_MODULES_DIR"
fi

if [ ! -d "$TF_DIR_TPM" ]; then
    mkdir -p "$TF_DIR_TPM"
fi

#Function to check if is the directory exist and check if the last version of the module is downloaded. If not, download and copy the new version.
function tf_check_dir {
    if [ -d $1 ]; then
        cd $1
        git pull
        #If git pull copy the new modules to the modules directory.
        if [ $? -eq 0 ]; then
            cp -r $TF_DIR_TPM/$1 $TF_MODULES_DIR
            #Move to the new directory.
            cd $TF_MODULES_DIR/$1
            #Remove files except .tf files.
            find . -type f ! -name '*.tf' -delete
            #Remove directories.
            find . -type d ! -name '.' -exec rm -rf {} +
            cd $TF_DIR_TPM
        fi
    else
        git clone $2

        #Copy the directories to the modules directory.
        cp -r $TF_DIR_TPM/$1 $TF_MODULES_DIR
        #Move to the new directory.
        cd $TF_MODULES_DIR/$1
        #Remove files except .tf files.
        find . -type f ! -name '*.tf' -delete
        #Remove directories.
        find . -type d ! -name '.' -exec rm -rf {} +

        #Push to gitlab repository.
        # cd $TF_MODULES_DIR
        # git add .
        # git commit -m "Add $1 module"
        # git push

        cd $TF_DIR_TPM
    fi

}

#Call the function for each module.
cd $TF_DIR_TPM
tf_check_dir "terraform-aws-s3-bucket" $TF_S3_REPO
tf_check_dir "terraform-aws-apigateway-v2" $TF_APIGATEWAY_REPO
tf_check_dir "terraform-aws-ecr" $TF_ECR_REPO
tf_check_dir "terraform-aws-security-group" $TF_SECURITYGROUP_REPO
tf_check_dir "terraform-aws-ec2-instance" $TF_EC2_REPO
tf_check_dir "terraform-aws-eks" $TF_EKS_REPO
tf_check_dir "terraform-aws-rds" $TF_RDS_REPO
tf_check_dir "terraform-aws-vpc" $TF_VPC_REPO

#!/usr/bin/env bash

set -e

current_directory="${PWD}"

if [[ -z "${TF_VAR_ENVIRONMENT}" ]]; then
    echo "TF_VAR_ENVIRONMENT environment variable is not set"
    exit 1
fi

exitStatus=0

cd $(dirname $0)/../"${TF_VAR_ENVIRONMENT}"

terraform init -backend-config="key=${STACK_NAME}/${TF_VAR_ENVIRONMENT}/terraform.tfstate"

if [ "$IS_PR_WORKFLOW" = true ] ; then
  terraform version

  terraform fmt

  terraform validate -no-color

  terraform plan -no-color --var-file="${TF_VAR_ENVIRONMENT}".tfvars
else
  terraform apply -auto-approve --var-file="${TF_VAR_ENVIRONMENT}".tfvars
fi

result=$?

cd "${current_directory}"

exit $result

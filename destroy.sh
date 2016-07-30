terraform destroy -var "do_api_key=${DO_API_KEY}" \
  -var "deploy_public_key=./deploy_rsa.pub" \
  -var "deploy_private_key=./deploy_rsa" \
  -var "public_key=./do_rsa.pub" \
  -var "private_key=./do_rsa" \
  -var "deploy_passwd=${DEPLOY_PASSWD}" \
  -var "external_ip=${EXTERNAL_IP}"

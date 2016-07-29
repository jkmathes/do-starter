if [ ! -f ./do_rsa ]; then
  echo "Creating DO key"
  ssh-keygen -b 2048 -t rsa -f ./do_rsa -q -N ""
else
  echo "DO key exists, skipping"
fi

if [ ! -f ./deploy_rsa ]; then
  echo "Creating deploy key"
  ssh-keygen -b 2048 -t rsa -f ./deploy_rsa -q -N ""
else
  echo "deploy key exists, skipping"
fi

openssl rand -base64 32 > ./deploy_passwd
export DEPLOY_PASSWD=`cat ./deploy_passwd`

terraform apply -var "do_api_key=${DO_API_KEY}" \
  -var "deploy_public_key=./deploy_rsa.pub" \
  -var "deploy_private_key=./deploy_rsa" \
  -var "public_key=./do_rsa.pub" \
  -var "private_key=./do_rsa" \
  -var "deploy_passwd=${DEPLOY_PASSWD}"

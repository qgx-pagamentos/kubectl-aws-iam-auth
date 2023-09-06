#!/bin/bash

set -v # show current command

mkdir $GITHUB_WORKSPACE/bin

[[ -n "${KUBE_VERSION}" ]] && KV=$KUBE_VERSION || KV=$(curl -L -s https://dl.k8s.io/release/stable.txt | cut -d'v' -f2)
[[ -n "${AWS_IAM_AUTH_VERSION}" ]] && AIAV=$AWS_IAM_AUTH_VERSION || AIAV="0.6.11" #Based on https://github.com/kubernetes-sigs/aws-iam-authenticator/tags

# kubectl
echo "Installing kubectl version: v${KV}"
curl -LO "https://dl.k8s.io/release/v${KV}/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/v${KV}/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
chmod +x kubectl

# aws-iam-authenticator
echo "Installing aws-iam-authenticator version: v${AIAV}"
curl -Lo aws-iam-authenticator_${AIAV}_linux_amd64 https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${AIAV}/aws-iam-authenticator_${AIAV}_linux_amd64
curl -Lo aws-iam-authenticator.txt https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${AIAV}/authenticator_${AIAV}_checksums.txt
echo -n "$(egrep "aws-iam-authenticator_${AIAV}_linux_amd64" aws-iam-authenticator.txt | cut -d' ' -f1)  aws-iam-authenticator_${AIAV}_linux_amd64" | sha256sum --check \
	&& mv aws-iam-authenticator_${AIAV}_linux_amd64 aws-iam-authenticator
chmod +x aws-iam-authenticator

# moving
mv kubectl /usr/local/bin/kubectl
mv aws-iam-authenticator $GITHUB_WORKSPACE/bin/aws-iam-authenticator

echo "$GITHUB_WORKSPACE/bin" >> $GITHUB_PATH

if [ ! -d "$HOME/.kube" ]; then
	mkdir -p $HOME/.kube
fi

echo "$BASE64_KUBE_CONFIG" | base64 -d > $HOME/.kube/config

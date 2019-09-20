#!/usr/bin/env bash

# Install Crossplane CLI
RELEASE=release-0.1 && curl -sL https://raw.githubusercontent.com/crossplaneio/crossplane-cli/"${RELEASE}"/bootstrap.sh | RELEASE=${RELEASE} bash

# Initialize the environment

# Install go
snap install --classic go

# Set up go
export GOPATH=$HOME/go
mkdir -p ${GOPATH}/src


# Install kubebuilder

os=$(go env GOOS)
arch=$(go env GOARCH)

# download kubebuilder and extract it to tmp
curl -sL https://go.kubebuilder.io/dl/2.0.0/${os}/${arch} | tar -xz -C /tmp/

# move to a long-term location and put it on your path
# (you'll need to set the KUBEBUILDER_ASSETS env var if you put it somewhere else)
sudo mv /tmp/kubebuilder_2.0.0_${os}_${arch} /usr/local/kubebuilder
export PATH=$PATH:/usr/local/kubebuilder/bin

# Initialize project

PROJECT_DIR=${GOPATH}/src/helloworld
mkdir -p ${PROJECT_DIR}
cd ${PROJECT_DIR}
git init

# Initialize project with kubebuilder
GO111MODULE=on kubebuilder init --domain helloworld.stacks.crossplane.io

# Set up Crossplane
# The reason this happens later in the script than what would normally happen is because
# when the environment first spins up, the kubernetes cluster is not ready yet. The steps
# before this take some time, so by the time we get to here, the cluster should be
# spun up and ready to install Crossplane.
#
# Finish setting up helm
helm init

# Install Crossplane
helm repo add crossplane-alpha https://charts.crossplane.io/alpha
helm install --name crossplane --namespace crossplane-system crossplane-alpha/crossplane

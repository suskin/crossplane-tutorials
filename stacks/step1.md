Before we can do the stuff we want to do, we need to install some
prerequisites.

If you see commands running in the terminal, that is an initialization
script which is taking care of some of the prerequisites for us. Once
it's done, we can finish setting up our environment.

## Install Crossplane

We'll need to install Crossplane before we're able to use it:

`helm repo add crossplane-alpha https://charts.crossplane.io/alpha`{{execute}}
`helm install --name crossplane --namespace crossplane-system crossplane-alpha/crossplane`{{execute}}

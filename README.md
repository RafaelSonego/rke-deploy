# rke-deploy

This repository has the following components:

1. Vagrant file that does provisioning of 3 VirtualBOx VMs for the RKE cluster.
Inline script will add sudo user account "admin" and authorized key to run the ansible playbook.

2. Ansible playbook for pre-requisites of RKE cluster.
Edit "inventoryi/dev/hosts.ini" for the target hosts, and run the following commandline to add the ssh-key for the playbook.
eval `ssh-agent -s` && ssh-add ~/.ssh/id_rsa (or whichever is your private key)  
ansible-playbook -i inventory/dev/hosts.ini provision.yml

3. terraform plan to provision the RKE cluster.
Edit "env-dev/variables.tf" with the IP addresses of the target hosts, and roles etc.
cd env-dev
terraform init
terraform plan -out=<your plan name>
terraform apply <your plan name>

On a successful deployment, rke cluster kubeconfig file (admin),client cert, client key, ca cert will be saved to env-dev/kubeconfig folder.

4. For installing Metallb, request a pool of IP address first and update under metallb/metallb-configmap.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f metallb/metallb-configmap.yaml

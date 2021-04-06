###############################################################################
# If you need kubeconfig.yml for using kubectl, please uncomment follows.
###############################################################################
resource "local_file" "kube_cluster_yaml" {
  filename = "kubeconfig/kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}
###############################################################################
# If you need ca_crt/client_cert/client_key, please uncomment follows.
###############################################################################
resource "local_file" "ca_crt" {
  filename = "kubeconfig/ca_cert"
  content  = rke_cluster.cluster.ca_crt
}

resource "local_file" "client_cert" {
  filename = "kubeconfig/client_cert"
  content  = rke_cluster.cluster.client_cert
}

resource "local_file" "client_key" {
  filename = "kubeconfig/client_key"
  content  = rke_cluster.cluster.client_key
}
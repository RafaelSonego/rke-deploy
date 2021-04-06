resource "rke_cluster" "cluster" {
  # Disable port check validation between nodes
  disable_port_check = false

  ###############################################
  # Kubernets nodes
  ###############################################
  nodes {
    address      = var.node1_address 
    user         = var.user 
    hostname_override = var.node1_hostname_override 
    internal_address  = var.node1_internal_address 
    role         = var.node1_role 
    ssh_key_path = var.ssh_key_path 
    port         = 22
  }

  nodes {
    address      = var.node2_address 
    user         = var.user 
    hostname_override = var.node2_hostname_override 
    internal_address  = var.node2_internal_address 
    role         = var.node2_role 
    ssh_key_path = var.ssh_key_path 
    port         = 22
  }

  nodes {
    address      = var.node3_address 
    user         = var.user 
    hostname_override = var.node3_hostname_override 
    internal_address  = var.node3_internal_address 
    role         = var.node3_role 
    ssh_key_path = var.ssh_key_path 
    port         = 22
  }

  # If set to true, RKE will not fail when unsupported Docker version are found
  ignore_docker_version = false

  ################################################
  # SSH configuration
  ################################################
  # Cluster level SSH private key
  # Used if no ssh information is set for the node
  # ssh_key_path = "~/.ssh/id_rsa"

  # Enable use of SSH agent to use SSH private keys with passphrase
  # This requires the environment `SSH_AUTH_SOCK` configured pointing to your SSH agent which has the private key added
  ssh_agent_auth = false

  ################################################
  # Bastion/Jump host configuration
  ################################################
  #bastion_host {
  #  address      = "1.1.1.1"
  #  user         = "ubuntu"
  #  ssh_key_path = "~/.ssh/id_rsa"
  #  or
  #  ssh_key      = file("~/.ssh/id_rsa")
  #  port         = 2222
  #}

  ################################################
  # Private Registries
  ################################################
  # List of registry credentials, if you are using a Docker Hub registry,
  # you can omit the `url` or set it to `docker.io`
#  private_registries {
#    url      = "registry1.com"
#    user     = "Username"
#    password = "password1"
#  }
#  private_registries {
#    url      = "registry2.com"
#    user     = "Username"
#    password = "password1"
#  }

  ################################################
  # Cluster Name
  ################################################
  # Set the name of the Kubernetes cluster
  cluster_name = var.cluster_name

  ################################################
  # Versions
  ################################################
  # The kubernetes version used.
  # For now, this should match the version defined in rancher/kontainer-driver-metadata defaults map:
  #    https://github.com/rancher/kontainer-driver-metadata/blob/release-v2.5/rke/k8s_rke_system_images.go#L6
  #
  # In case the kubernetes_version and kubernetes image in system_images are defined,
  # the system_images configuration will take precedence over kubernetes_version.
  #
  # Allowed values: Any key defined at `loadK8sRKESystemImages()`
  # kubernetes_version = "v1.18.15-rancher1-1"
  kubernetes_version = var.kubernetes_version

  ################################################
  # System Images
  ################################################
  # System Image Tags are defaulted to a tag tied with specific kubernetes Versions
  # Default Tags:
  #    https://github.com/rancher/kontainer-driver-metadata/blob/release-v2.5/rke/k8s_rke_system_images.go)
  #
#  system_images {
#    kubernetes                  = "rancher/hyperkube:v1.10.3-rancher2"
#    etcd                        = "rancher/coreos-etcd:v3.1.12"
#    alpine                      = "rancher/rke-tools:v0.1.9"
#    nginx_proxy                 = "rancher/rke-tools:v0.1.9"
#    cert_downloader             = "rancher/rke-tools:v0.1.9"
#    kubernetes_services_sidecar = "rancher/rke-tools:v0.1.9"
#    kube_dns                    = "rancher/k8s-dns-kube-dns-amd64:1.14.8"
#    dnsmasq                     = "rancher/k8s-dns-dnsmasq-nanny-amd64:1.14.8"
#    kube_dns_sidecar            = "rancher/k8s-dns-sidecar-amd64:1.14.8"
#    kube_dns_autoscaler         = "rancher/cluster-proportional-autoscaler-amd64:1.0.0"
#    pod_infra_container         = "rancher/pause-amd64:3.1"
#  }

  ###############################################
  # Kubernetes services
  ###############################################
  services {
    etcd {
      # if external etcd used
      #path      = "/etcdcluster"
      #ca_cert   = file("ca_cert")
      #cert      = file("cert")
      #key       = file("key")

      # for etcd snapshots
      backup_config {
        interval_hours = 12
        retention = 6
      #  # s3 specific parameters
      #  #s3_backup_config {
      #  #  access_key = "access-key"
      #  #  secret_key = "secret_key"
      #  #  bucket_name = "bucket-name"
      #  #  region = "region"
      #  #  endpoint = "s3.amazonaws.com"
        }
    }
    kube_api {
      # IP range for any services created on Kubernetes
      # This must match the service_cluster_ip_range in kube-controller
      service_cluster_ip_range = "10.43.0.0/16"

      # Expose a different port range for NodePort services
      service_node_port_range = "30000-32767"

      pod_security_policy = var.pod_security_policy

      # Add additional arguments to the kubernetes API server
      # This WILL OVERRIDE any existing defaults
      extra_args = {
        audit-log-path            = "-"
        delete-collection-workers = 3
        v                         = 4
      }
    }
    kube_controller {
      # CIDR pool used to assign IP addresses to pods in the cluster
      cluster_cidr = "10.42.0.0/16"

      # IP range for any services created on Kubernetes
      # This must match the service_cluster_ip_range in kube-api
      service_cluster_ip_range = "10.43.0.0/16"
    }
    scheduler {
    }

    kubelet {
      # Base domain for the cluster
      cluster_domain = "cluster.local"

      # IP address for the DNS service endpoint
      cluster_dns_server = "10.43.0.10"

      # Fail if swap is on
      fail_swap_on = false

      # Optionally define additional volume binds to a service
      extra_binds = [
        "/usr/libexec/kubernetes/kubelet-plugins:/usr/libexec/kubernetes/kubelet-plugins",
      ]
    }
    kubeproxy {
    }
  }
  ################################################
  # Authentication
  ################################################
  # Currently, only authentication strategy supported is x509.
  # You can optionally create additional SANs (hostnames or IPs) to add to the API server PKI certificate.
  # This is useful if you want to use a load balancer for the control plane servers.
  authentication {
    strategy = "x509"
    sans = var.authentication_sans 
  }

  ################################################
  # Authorization
  ################################################
  # Kubernetes authorization mode
  #   - Use `mode: "rbac"` to enable RBAC
  #   - Use `mode: "none"` to disable authorization
  authorization {
    mode = "rbac"
  }

  ################################################
  # Cloud Provider
  ################################################
  # If you want to set a Kubernetes cloud provider, you specify the name and configuration
#  cloud_provider {
#    name = "aws"
#  }

  # Add-ons are deployed using kubernetes jobs. RKE will give up on trying to get the job status after this timeout in seconds..
  addon_job_timeout = 30

  #########################################################
  # Network(CNI) - supported: flannel/calico/canal/weave
  #########################################################
  # There are several network plug-ins that work, but we default to canal
  network {
    plugin = var.network_plugin
  }

  ################################################
  # Ingress
  ################################################
  # Currently only nginx ingress provider is supported.
  # To disable ingress controller, set `provider: none`
  ingress {
    provider = var.ingress
  }

  ################################################
  # Addons
  ################################################
  # all addon manifests MUST specify a namespace
#  addons = <<EOL
#---
#apiVersion: v1
#kind: Deployment
#metadata:
#  name: pipeline-deploy-228
#  namespace: default
#spec:
#  selector:
#    matchLabels:
#      app: pipeline-app-228
#  replicas: 1
#  template:
#    metadata:
#      labels:
#        app: pipeline-app-228
#    spec:
#      containers:
#      - name: pipelines-javascript-k8s-228
#        image: ezlee/pipelines-javascript-k8s:228
#        ports:
#        - containerPort: 80
#---
#apiVersion: v1
#kind: Service
#metadata:
#  name: pipeline-service
#spec:
#  selector:
#    app: pipeline-app-228
#  ports:
#    - port: 8080
#      targetPort: 8080
#  type: LoadBalancer
#EOL


#    addons_include = [
#      "https://raw.githubusercontent.com/rook/rook/master/cluster/examples/kubernetes/rook-operator.yaml",
#      "https://raw.githubusercontent.com/rook/rook/master/cluster/examples/kubernetes/rook-cluster.yaml",
#      "/path/to/manifest",
#    ]

}

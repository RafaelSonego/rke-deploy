

variable "kubernetes_version" { default = "v1.19.8-rancher1-1" }
variable "pod_security_policy" { default = "false" }
variable "ingress" { default = "nginx" }
variable "network_plugin" { default = "flannel" }

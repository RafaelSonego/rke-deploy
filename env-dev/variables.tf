variable "cluster_name" { default= "rketf8" }
variable "user" { default= "rke" }
variable "ssh_key_path" { default= "~/.ssh/id_rsa" }

variable "node1_address" { default = "192.168.31.15"}
variable "node1_role" { default= ["controlplane", "etcd"] }
variable "node1_internal_address" { default= "192.168.31.15" }
variable "node1_hostname_override" { default= "rke-master-1" }

variable "node2_address" { default = "192.168.31.16"}
variable "node2_role" { default= ["worker"] }
variable "node2_internal_address" { default= "192.168.31.16" }
variable "node2_hostname_override" { default= "rke-worker-1" }

variable "node3_address" { default = "192.168.31.17"}
variable "node3_role" { default= ["worker"] }
variable "node3_internal_address" { default= "192.168.31.17" }
variable "node3_hostname_override" { default= "rke-worker-2" }

variable "authentication_sans" { default = ["api.rke.my-azure.online", "192.168.31.15", "192.168.31.245"] }

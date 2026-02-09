variable "project_id" {
  description = "GCP project ID"
  type        = string
  default = "burner-kulsharm2-01"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "vpc_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.10.0.0/24"
}
variable "vm_names" {
  type    = map(string)
  default = {
    vm1 = "cks-master"
    vm2 = "cks-worker"
  }
}
variable "vm_startup_commands" {
  type = map(string)
  default = {
    vm1 = <<-EOT
      #!/bin/bash
      echo "This runs only on cks-master" > /opt/vm1.log
      echo "kubeadm token create --print-join-command" >> /opt/vm1.log
      bash <(curl -s https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/latest/install_master.sh)
      echo `kubeadm token create --print-join-command` >> /opt/vm1.log
      source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
      echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.
      source ~/.bashrc
      alias k=kubectl
      complete -F __start_kubectl k
    EOT
    vm2 = <<-EOT
      #!/bin/bash
      echo "This runs only on cks-worker" > /opt/vm2.log
      bash <(curl -s https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/latest/install_worker.sh)
      source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
      echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.
      source ~/.bashrc
      alias k=kubectl
      complete -F __start_kubectl k
    EOT
  }
}
variable "vm_desired_status" {
  description = "RUNNING or TERMINATED"
  type        = string
  default     = "RUNNING"
}

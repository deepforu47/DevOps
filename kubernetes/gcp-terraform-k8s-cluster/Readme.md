# GCP Kubernetes Cluster Setup Guide

This guide walks you through authenticating with GCP, provisioning infrastructure with Terraform, and initializing your Kubernetes cluster.

# Usage

## 1. Install Prerequisites
   - [Terraform](https://www.terraform.io/downloads.html) (v1.0+ recommended)
   - Google Cloud SDK (for authentication and deployment)
   - Ensure your GCP project and billing are enabled

## 2. Configure Variables
   - Edit `variables.tf` to set your `project_id`, `region`, `zone`, and VM names as needed.

## 3. Authenticate with Google Cloud

   Before running Terraform, authenticate your CLI session:

    ```bash
    gcloud auth login
    ```

   This opens a browser for authentication. Ensure you select the correct GCP account.

## 4. Initialize and Deploy
       ```sh
       terraform init
       terraform plan
       terraform apply
       ```
## 5. Wait for Startup Scripts to Complete

After Terraform completes, wait a few minutes for VM startup scripts to finish.  
You can check if startup scripts are still running with:

    ```bash
    ps -ef | grep bash
    ```

Wait until no relevant startup script processes remain.

---

## 6. Retrieve kubeadm Join Command from Master (cks-master)

SSH into the master VM (replace `<MASTER_VM_IP>` as needed):

    ```bash
    gcloud compute ssh cks-master --zone <ZONE>
    ```

Check the log for the kubeadm join command:

    ```bash
    cat /opt/vm1.log
    ```

Alternatively, generate a fresh join command (on cks-master):

    ```bash
    sudo kubeadm token create --print-join-command
    ```

Example output:

    ```bash
    kubeadm join 10.10.0.2:6443 --token xxxxxxxx --discovery-token-ca-cert-hash sha256:xxxxxxxx
    ```

---

## 7. Join Worker Node to Cluster

SSH into the worker VM (replace `<WORKER_VM_IP>` as needed):

    ```bash
    gcloud compute ssh cks-worker --zone <ZONE>
    ```

Run the join command as root (replace with your actual join command):

    ```bash
    sudo <paste-your-kubeadm-join-command-here>
    ```

---

## 6. Verify Cluster Node Status

Back on the master node, check the status of all nodes:

    ```bash
    kubectl get nodes
    ```

Expected output: Should be able to see 2 nodes
 
### K8S cluster installation has been using using Killer.sh Installation Scripts

The VM startup scripts (see `vm_startup_commands` in [variables.tf](variables.tf)) use killer.sh’s public installation scripts to automate Kubernetes setup:

- **Master Node:**  
  Downloads and runs [install_master.sh](https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/latest/install_master.sh)  
  - Initializes the Kubernetes control plane
  - Generates a join token for worker nodes
  - Sets up kubectl bash completion and aliases

- **Worker Node:**  
  Downloads and runs [install_worker.sh](https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/latest/install_worker.sh)  
  - Joins the worker to the cluster using the master’s token
  - Sets up kubectl bash completion and aliases

### Dependencies

- **Network Access:** Required to fetch scripts from GitHub and install packages.
- **Bash & Curl:** Both must be available on the VM images.
- **Kubernetes Tools:** The scripts install or expect `kubeadm`, `kubectl`, and dependencies.  
- **Permissions:** Startup scripts must run as root (default for GCP VM metadata startup scripts).

### Manual Usage

You can run these scripts manually for troubleshooting:
    ```sh
    curl -s https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/latest/install_master.sh | bash
    curl -s https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/latest/install_worker.sh | bash
    ```

## Security & Best Practices

- Do not hard-code secrets; use environment variables or secret managers.
- Validate all user and variable inputs.
- Review remote scripts before use in production environments.

## Troubleshooting

- Check VM logs for startup script errors (`/var/log/syslog` or `/var/log/messages`).
- Ensure network/firewall rules allow required traffic (especially for Kubernetes ports).

---

*This is only for learning purpose.*
output "vm_internal_ips" {
  description = "Internal IPs of the CKS VMs"
  value = {
    for name, vm in google_compute_instance.cks_vm :
    name => vm.network_interface[0].network_ip
  }
}

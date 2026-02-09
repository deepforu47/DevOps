# -----------------------------
# VPC
# -----------------------------
resource "google_compute_network" "cks_vpc" {
  name                    = "cks-vpc"
  auto_create_subnetworks = false
}

# -----------------------------
# Subnet
# -----------------------------
resource "google_compute_subnetwork" "cks_subnet" {
  name          = "cks-subnet"
  region        = var.region
  network       = google_compute_network.cks_vpc.id
  ip_cidr_range = var.vpc_cidr

  private_ip_google_access = true
}

# -----------------------------
# Compute Engine VM
# -----------------------------
resource "google_compute_instance" "cks_vm" {
  for_each     = var.vm_names
  name         = each.value
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = ["cks"]
  desired_status = var.vm_desired_status
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2404-lts-amd64"
      size  = 50
      type  = "pd-balanced"
    }
  }

  network_interface {
    network    = google_compute_network.cks_vpc.id
    subnetwork = google_compute_subnetwork.cks_subnet.id
    # No access_config → no public IP
  }

  metadata = {
    enable-oslogin = "TRUE"
  }
  metadata_startup_script = var.vm_startup_commands[each.key]

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_compute_router" "cks_router" {
  name    = "cks-cloud-router"
  network = google_compute_network.cks_vpc.id
  region  = var.region
}

resource "google_compute_router_nat" "cks_nat" {
  name   = "cks-cloud-nat"
  router = google_compute_router.cks_router.name
  region = var.region

  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.cks_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  enable_endpoint_independent_mapping = true
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-ssh-from-iap"
  network = google_compute_network.cks_vpc.name
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] # IAP SSH CIDR
}

resource "google_compute_firewall" "internal" {
  name    = "cks-internal"
  network = google_compute_network.cks_vpc.name
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]  # all TCP ports internally
  }

  allow {
    protocol = "icmp"       # optional, for ping
  }

  source_ranges = ["10.10.0.0/24"]  # your subnet CIDR
  target_tags   = ["cks"]           # only apply to your VMs
}

resource "google_compute_firewall" "nodeports_iap" {
  name    = "cks-nodeports-iap"
  network = google_compute_network.cks_vpc.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["30000-40000"]
  }

  source_ranges = ["35.235.240.0/20"]  # IAP
  target_tags   = ["cks"]              # only k8s nodes
}

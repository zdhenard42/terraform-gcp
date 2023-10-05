resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}

resource "google_compute_instance" "default1" {
  name         = "virtual-machine-from-terraform"
  machine_type = "e2-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "debian-10-buster-v20231004"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

    metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y && echo '<!doctype html><html><body><h1>Jacob is super cool!!!</h1></body></html>' | sudo tee /var/www/html/index.html"

    // Apply the firewall rule to allow external IPs to access this instance
    tags = ["http-server","icmp"]
}
resource "google_compute_instance" "default2" {
  name         = "virtual-machine-from-terraform2"
  machine_type = "e2-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "debian-10-buster-v20231004"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

    metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y && echo '<!doctype html><html><body><h1>Jacob is cool!!!</h1></body></html>' | sudo tee /var/www/html/index.html"

    // Apply the firewall rule to allow external IPs to access this instance
    tags = ["http-server","icmp"]
}

resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http-terraform"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "deny-icmp" {
  name    = "default-deny-icmp-terraform"
  network = google_compute_network.vpc_network.self_link
  priority = 2000

  deny {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["icmp"]
}

resource "google_compute_firewall" "allow-icmp" {
  name    = "default-allowme-icmp-terraform"
  network = google_compute_network.vpc_network.self_link
  priority = 1000

  allow {
    protocol = "icmp"
  }

  source_ranges = ["97.81.168.114"]
  target_tags   = ["icmp"]
}





output "ip" {
  value = "${google_compute_instance.default1.network_interface.0.access_config.0.nat_ip},${google_compute_instance.default2.network_interface.0.access_config.0.nat_ip}"
}
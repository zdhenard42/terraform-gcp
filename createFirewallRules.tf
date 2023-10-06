resource "google_compute_firewall" "deny-all"{
  name    = "default-deny-all-terraform"
  network = google_compute_network.vpc_network.self_link
  priority = 2000

  deny {
    protocol = "all"
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["default-rules"]
}

resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http-terraform"
  network = google_compute_network.vpc_network.self_link
  priority = 1000

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["default-rules"]
}


resource "google_compute_firewall" "allow-icmp" {
  name    = "default-allowme-icmp-terraform"
  network = google_compute_network.vpc_network.self_link
  priority = 1000

  allow {
    protocol = "icmp"
  }

  source_ranges = ["97.81.168.114"]
  target_tags   = ["default-rules"]
}



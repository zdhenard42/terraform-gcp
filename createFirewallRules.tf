resource "google_compute_firewall" "deny-all"{
  name    = "default-deny-all-terraform"
  network = google_compute_network.vpc_network.self_link
  priority = 2000

  deny {
    protocol = "all"
  }

  // deny all traffic from all ports and all sources
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

  // Allow traffic from everywhere to instances over http
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["default-rules"]
}


resource "google_compute_firewall" "allow-zack" {
  name    = "default-allowzack-all-terraform"
  network = google_compute_network.vpc_network.self_link
  priority = 1000

  allow {
    protocol = "all"
  }

  source_ranges = [var.zackIP]
  target_tags   = ["default-rules"]
}


resource "google_compute_firewall" "allow-mal" {
  name    = "default-allowmal-all-terraform"
  network = google_compute_network.vpc_network.self_link
  priority = 1000

  allow {
    protocol = "all"
  }

  source_ranges = [var.malIP]
  target_tags   = ["default-rules"]
}




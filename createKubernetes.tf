resource "google_container_cluster" "primary" {
  name     = "my-cluster"
  location = "us-central1-a"
  deletion_protection = false

  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  network = google_compute_network.vpc_network.self_link
  
}


resource "google_container_node_pool" "primary" {
  name       = "my-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name

  node_count = 3

  node_config {
    preemptible  = false
    machine_type = "n1-standard-1"
    tags         = ["gke-node"]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

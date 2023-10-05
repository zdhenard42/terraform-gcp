# Specify the provider (GCP, AWS, Azure)
provider "google" {
credentials = "${file("credentials.json")}"
project = "terraform-practice-401121"
region = "us-east1"
}
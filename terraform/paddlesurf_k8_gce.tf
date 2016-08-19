// Configure the Google Cloud provider
// set $GOOGLE_CREDENTIALS env variable with your API credentials
provider "google" {
  project     = "paddlesurf-140814"
  region      = "europe-west1"
}

// europe-west1-d has Haswell processors, we're not gonna need it anyway...
resource "google_container_cluster" "primary" {
  name = "paddlesurf"
  zone = "europe-west1-d"
  initial_node_count = 3

  master_auth {
    username = "paddleuser"
    password = "changeme please!"
  }

}


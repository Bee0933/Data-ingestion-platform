# Create a new SSH key
resource "digitalocean_ssh_key" "default" {
  name       = "SFTP Platform SSH key"
  public_key = var.ssh_key
}

# Source Server droplet in the Frankfut region
resource "digitalocean_droplet" "src-server-0" {
  image  = "ubuntu-24-04-x64"
  name   = "src-server-0"
  region = "fra1"
  size   = "s-2vcpu-4gb"

  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  tags     = ["source:${var.project-tag}"]
}

# # Airbyte Server droplet in the Frankfut region
# resource "digitalocean_droplet" "airbyte-server-0" {
#   image  = "ubuntu-24-04-x64"
#   name   = "airbyte-server-0"
#   region = "fra1"
#   size   = "s-2vcpu-4gb"

#   ssh_keys = [digitalocean_ssh_key.default.fingerprint]
#   tags = ["airflow:${var.project-tag}"]
# }

# # Storage Server droplet in the Frankfut region
# resource "digitalocean_droplet" "storage-server-0" {
#   image  = "ubuntu-24-04-x64"
#   name   = "storage-server-0"
#   region = "fra1"
#   size   = "s-2vcpu-4gb"

#   ssh_keys = [digitalocean_ssh_key.default.fingerprint]
#   tags = ["storage:${var.project-tag}"]
# }

# # DuckDB Server droplet in the Frankfut region
# resource "digitalocean_droplet" "duckdb-server-0" {
#   image  = "ubuntu-24-04-x64"
#   name   = "duckdb-server-0"
#   region = "fra1"
#   size   = "s-1vcpu-1gb"

#   ssh_keys = [digitalocean_ssh_key.default.fingerprint]
#   tags = ["duckdb:${var.project-tag}"]
# }
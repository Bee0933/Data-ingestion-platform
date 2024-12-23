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
resource "digitalocean_droplet" "airbyte-server-0" {
  image  = "ubuntu-24-04-x64"
  name   = "airbyte-server-0"
  region = "fra1"
  size   = "s-4vcpu-8gb"

  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  tags     = ["airbyte:${var.project-tag}"]
}

# # Storage Server droplet in the Frankfut region
resource "digitalocean_droplet" "storage-server-0" {
  image  = "ubuntu-24-04-x64"
  name   = "storage-server-0"
  region = "fra1"
  size   = "s-2vcpu-4gb"

  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  tags     = ["storage:${var.project-tag}"]
}

# # DuckDB Server droplet in the Frankfut region
resource "digitalocean_droplet" "duckdb-server-0" {
  image  = "ubuntu-24-04-x64"
  name   = "duckdb-server-0"
  region = "fra1"
  size   = "s-1vcpu-1gb"

  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  tags     = ["duckdb:${var.project-tag}"]
}

# # Monitoring Server droplet in the Frankfut region
resource "digitalocean_droplet" "monitor-server-0" {
  image  = "ubuntu-24-04-x64"
  name   = "monitor-server-0"
  region = "fra1"
  size   = "s-2vcpu-4gb"

  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  tags     = ["monitor:${var.project-tag}"]
}

# DO domain for platform
resource "digitalocean_domain" "dataops_domain" {
  name = var.domain_name
}

# Add an A record to the domain for sftp drop off zone
resource "digitalocean_record" "sftp_record" {
  domain = digitalocean_domain.dataops_domain.id
  type   = "A"
  name   = "sftp"
  value  = digitalocean_droplet.src-server-0.ipv4_address
}

# Add an A record to the domain for postgres DWH
resource "digitalocean_record" "postgres_record" {
  domain = digitalocean_domain.dataops_domain.id
  type   = "A"
  name   = "postgres"
  value  = digitalocean_droplet.src-server-0.ipv4_address
}

# Add an A record to the domain for Airbyte
resource "digitalocean_record" "airbyte_record" {
  domain = digitalocean_domain.dataops_domain.id
  type   = "A"
  name   = "airbyte"
  value  = digitalocean_droplet.airbyte-server-0.ipv4_address
}

# Add an A record to the domain for Minio Datalake Storage
resource "digitalocean_record" "minio_record" {
  domain = digitalocean_domain.dataops_domain.id
  type   = "A"
  name   = "storage"
  value  = digitalocean_droplet.storage-server-0.ipv4_address
}

# Add an A record to the domain for Duckdb Query service
resource "digitalocean_record" "duckdb_record" {
  domain = digitalocean_domain.dataops_domain.id
  type   = "A"
  name   = "query"
  value  = digitalocean_droplet.duckdb-server-0.ipv4_address
}

# Add an A record to the domain for prometheus
resource "digitalocean_record" "prometheus_record" {
  domain = digitalocean_domain.dataops_domain.id
  type   = "A"
  name   = "prometheus"
  value  = digitalocean_droplet.monitor-server-0.ipv4_address
}

# Add an A record to the domain for loki
resource "digitalocean_record" "loki_record" {
  domain = digitalocean_domain.dataops_domain.id
  type   = "A"
  name   = "prometheus"
  value  = digitalocean_droplet.monitor-server-0.ipv4_address
}

# Add an A record to the domain for grafana
resource "digitalocean_record" "grafana_record" {
  domain = digitalocean_domain.dataops_domain.id
  type   = "A"
  name   = "grafana"
  value  = digitalocean_droplet.monitor-server-0.ipv4_address
}

# Add an A record to the domain for Alertmanager
resource "digitalocean_record" "alertmanager_record" {
  domain = digitalocean_domain.dataops_domain.id
  type   = "A"
  name   = "alertmanager"
  value  = digitalocean_droplet.monitor-server-0.ipv4_address
}

# Add an A record to the domain for Node Exporter0
resource "digitalocean_record" "expoeter_0_record" {
  domain = digitalocean_domain.dataops_domain.id
  type   = "A"
  name   = "exporter0"
  value  = digitalocean_droplet.src-server-0.ipv4_address
}

# Add an A record to the domain for Node Exporter1
resource "digitalocean_record" "expoeter_1_record" {
  domain = digitalocean_domain.dataops_domain.id
  type   = "A"
  name   = "exporter1"
  value  = digitalocean_droplet.airbyte-server-0.ipv4_address
}

# Add an A record to the domain for Node Exporter2
resource "digitalocean_record" "expoeter_2_record" {
  domain = digitalocean_domain.dataops_domain.id
  type   = "A"
  name   = "exporter2"
  value  = digitalocean_droplet.storage-server-0.ipv4_address
}

# Add an A record to the domain for Node Exporter3
resource "digitalocean_record" "expoeter_3_record" {
  domain = digitalocean_domain.dataops_domain.id
  type   = "A"
  name   = "exporter3"
  value  = digitalocean_droplet.duckdb-server-0.ipv4_address
}

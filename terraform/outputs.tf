output "src_server" {
  description = "Details of the source server droplet"
  value = {
    name = digitalocean_droplet.src-server-0.name
    ip   = digitalocean_droplet.src-server-0.ipv4_address
    tags = digitalocean_droplet.src-server-0.tags
  }
}

output "airbyte_server" {
  description = "Details of the Airbyte server droplet"
  value = {
    name = digitalocean_droplet.airbyte-server-0.name
    ip   = digitalocean_droplet.airbyte-server-0.ipv4_address
    tags = digitalocean_droplet.airbyte-server-0.tags
  }
}

output "storage_server" {
  description = "Details of the storage server droplet"
  value = {
    name = digitalocean_droplet.storage-server-0.name
    ip   = digitalocean_droplet.storage-server-0.ipv4_address
    tags = digitalocean_droplet.storage-server-0.tags
  }
}

output "duckdb_server" {
  description = "Details of the DuckDB server droplet"
  value = {
    name = digitalocean_droplet.duckdb-server-0.name
    ip   = digitalocean_droplet.duckdb-server-0.ipv4_address
    tags = digitalocean_droplet.duckdb-server-0.tags
  }
}

output "monitor_server" {
  description = "Details of the monitoring server droplet"
  value = {
    name = digitalocean_droplet.monitor-server-0.name
    ip   = digitalocean_droplet.monitor-server-0.ipv4_address
    tags = digitalocean_droplet.monitor-server-0.tags
  }
}

output "all_droplet_ips" {
  description = "A list of all droplet IPs"
  value = [
    digitalocean_droplet.src-server-0.ipv4_address,
    digitalocean_droplet.airbyte-server-0.ipv4_address,
    digitalocean_droplet.storage-server-0.ipv4_address,
    digitalocean_droplet.duckdb-server-0.ipv4_address,
    digitalocean_droplet.monitor-server-0.ipv4_address,
  ]
}

variable "do_token" {
  type        = string
  description = "Digital Ocean API Token"
  sensitive   = true
}

variable "ssh_key" {
  type        = string
  description = "SSH keys for SFTP platform servers"
  sensitive   = true
}

variable "project-tag" {
  type        = string
  default     = "sftp-platform"
  description = "Unique project Tag"
}

variable domain_name {
  type        = string
  default     = "bestnyah.xyz"
  description = "domain name for platfrom"
}

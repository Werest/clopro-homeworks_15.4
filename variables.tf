variable "zone" {
  description = "Default zone"
  type        = string
  default     = "ru-central1-a"
}

variable "zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

variable "cloud_id" {
  description = "Cloud ID"
  type        = string
  default = "b1g5lq99m43jv5mpei89"
}

variable "folder_id" {
  description = "Folder ID"
  type        = string
  default = "b1g88k8r3li6sb89l14s"
}

variable "mysql_password" {
  description = "MySQL password"
  type        = string
  sensitive   = true
}
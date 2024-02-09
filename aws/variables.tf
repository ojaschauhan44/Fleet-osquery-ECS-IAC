locals {
  name = "fleetdm"
}

variable "prefix" {
  default = "abc-testfleet"
}

variable "domain_fleetdm" {
  default = "fleet.yourdomain.co"
}

variable "osquery_results_s3_bucket" {
  default = "chronicle-logs-abc"
}

variable "osquery_status_s3_bucket" {
  default = "chronicle-logs-abc"
}

variable "vulnerabilities_path" {
  default = "/home/fleet"
}

variable "fleet_backend_cpu" {
  default = 4096
  type    = number
}

variable "fleet_backend_mem" {
  default = 12288
  type    = number
}

variable "async_host_processing" {
  default = "false"
}

variable "profile" {
  default = "Administrator"
}
output "profile" {
  value = var.profile
}


variable "logging_debug" {
  default = "false"
}

variable "logging_json" {
  default = "true"
}

variable "database_user" {
  description = "database user fleet will authenticate and query with"
  default     = "fleet"
}

variable "database_name" {
  description = "the name of the database fleet will create/use"
  default     = "fleet"
}

variable "fleet_image" {
  description = "the name of the container image to run"
  default     = "fleetdm/fleet:v4.44.0"
}

variable "software_inventory" {
  description = "enable/disable software inventory (default is enabled)"
  default     = "1"
}

variable "vuln_db_path" {
  description = "the path to save the vuln database"
  default     = "/home/fleet"
}

variable "cpu_migrate" {
  description = "cpu units for migration task"
  default     = 4096
  type        = number
}

variable "mem_migrate" {
  description = "memory limit for migration task in MB"
  default     = 8192
  type        = number
}

variable "fleet_max_capacity" {
  description = "maximum number of fleet containers to run"
  default     = 5
}

variable "fleet_min_capacity" {
  description = "minimum number of fleet containers to run"
  default     = 1
}

variable "memory_tracking_target_value" {
  description = "target memory utilization for target tracking policy (default 80%)"
  default     = 80
}

variable "cpu_tracking_target_value" {
  description = "target cpu utilization for target tracking policy (default 60%)"
  default     = 60
}

variable "fleet_license" {
  description = "Fleet Premium license key"
  default     = ""
}

variable "cloudwatch_log_retention" {
  description = "number of days to keep logs around for fleet services"
  default     = 1
}

variable "rds_backup_retention_period" {
  description = "number of days to keep snapshot backups"
  default     = 7
}

// labels / tags
variable "namespace" {
  default = "Security"
}

variable "name" {
  default = "test_o"
}

variable "stage" {
  default = ""
}

variable "delimiter" {
  default = "-"
}

variable "tags" {
  default = {}
}

variable "attributes" {
  default = []
}

// Networks
variable "vpc_cidr_block" {
  default = "10.233.0.0/16"

}

variable "availability_zones" {
  default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

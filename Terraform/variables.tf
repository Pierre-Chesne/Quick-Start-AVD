variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "rg_name" {
  type        = string
  default     = "rg-avd-resources"
  description = "Name of the Resource group in which to deploy service objects"
}

variable "vnet_range" {
  type        = list(string)
  default     = ["10.2.0.0/16"]
  description = "Address range for deployment VNet"
}

variable "subnet_range" {
  type        = list(string)
  default     = ["10.2.0.0/24"]
  description = "Address range for session host subnet"
}

variable "dns_servers" {
  type        = list(string)
  default     = ["10.0.0.4"]
  description = "Custom DNS configuration"
}

variable "ad_vnet" {
  type        = string
  default     = "vnet-ad"
  description = "Name of domain controller vnet"
}

variable "ad_rg" {
  type        = string
  default     = "Rg-AD"
  description = "Name of domain controller vnet"
}

variable "workspace" {
  type        = string
  description = "Name of the Azure Virtual Desktop workspace"
  default     = "AVD TF Workspace"
}

variable "hostpool" {
  type        = string
  description = "Name of the Azure Virtual Desktop host pool"
  default     = "AVD-TF-HP"
}

variable "rfc3339" {
  type        = string
  default     = "2022-05-27T20:00:00Z"
  description = "Registration token expiration"
}

variable "prefix" {
  type        = string
  default     = "avdtf"
  description = "Prefix of the name of the AVD machine(s)"
}

variable "rdsh_count" {
  description = "Number of AVD machines to deploy"
  default     = 2
}

variable "vm_size" {
  description = "Size of the machine to deploy"
  default     = "Standard_DS2_v2"
}

variable "local_admin_username" {
  type        = string
  default     = "pierrc"
  description = "local admin username"
}

variable "local_admin_password" {
  type        = string
  default     = "Password123$"
  description = "local admin password"
  sensitive   = true
}

variable "domain_name" {
  type        = string
  default     = "ma-pme.local"
  description = "Name of the domain to join"
}

variable "ou_path" {
  default = ""
}

variable "domain_user_upn" {
  type        = string
  default     = "pierrc" # do not include domain name as this is appended
  description = "Username for domain join (do not include domain name as this is appended)"
}

variable "domain_password" {
  type        = string
  default     = "Password123$"
  description = "Password of the user to authenticate with the domain"
  sensitive   = true
}

variable "avd_users" {
  description = "AVD users"
  default = [
    "pierre@acr-services.io",
    "paul@acr-services.io",
    "jacques@acr-services.io"
  ]
}

variable "aad_group_name" {
  type        = string
  default     = "AVD-Users"
  description = "Azure Active Directory Group for AVD users"
}

variable "rg_stor" {
  type        = string
  default     = "rg-avd-storage"
  description = "Name of the Resource group in which to deploy storage"
}

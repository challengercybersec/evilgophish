variable "client_secret" { default = "" }
variable "client_id" { default = "" }
variable "subscription_id" { default = "" }
variable "tenant_id" { default = "" }


#Definiendo mejor

variable "network-vnet-cidr" {
  type = string
  description = "The CIDR of the network VNET"
}
variable "network-subnet-cidr-gophish" {
  type = string
  description = "The CIDR for the network subnet with gophish"
}

variable "network-subnet-cidr-testing" {
  type = string
  description = "The CIDR for the network subnet for testing stuff"
}


variable "storage_account_name" {
  type = string
  description = "The storage account name"
}

variable "container_name" {
  type = string
  description = "the container namee"
}

variable "resource_group_name" {
  type = string
  description = "The rsg  name with everything"
}

variable "location" {
  type = string
  description = "The region for deployment"
}

variable "state_file_name" {
  type = string
  description = "The name of the tfstate file"
}

variable "access_key" {
  type = string
  description = "The name of the tfstate file"
}


#para el evilgophis

variable "op" { default = "none" }
variable "ttl" { default = "none" }
variable "cdn_profile_name" { default = "none" }
variable "cdn_endpoint_name_gophish"{ default = "none" }
variable "cdn_origin_host_gophish" { default = "none" }
variable "cdn_endpoint_name_evilginx1"{ default = "none" }
variable "cdn_origin_host_evilginx1" { default = "none" }
variable "cdn_endpoint_name_evilginx2"{ default = "none" }
variable "cdn_origin_host_evilginx2" { default = "none" }
variable "cdn_origin_hostheader_evilginx1" { default = "none" }
variable "cdn_origin_hostheader_evilginx2" { default = "none" }
variable "vnetname" {
  type = string
}
variable "vnetcidr" {
  type = list(string)
}
variable "subnetname" {
  type = string
}
variable "subnetcidr" {
  type = list(string)
}
variable "publicip" {
  type = string
}
variable "zonespip" {
  type = list(string)
}
variable "nsgname" {
  type = string
}
variable "nicname" {
  type = string
}
variable "vmname" {
  type = string
}
variable "zonesvm" {
  type = string
}
variable "filestoragename" {
  type = string
}
variable "fsname" {
  type = string
}

variable "roledefinition" {
  type = string
}
variable "principal_id" {
  type = string
}
variable "enable_role_assignment" {
  type = bool
  default = false
}
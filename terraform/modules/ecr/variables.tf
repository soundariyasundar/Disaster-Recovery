variable "replication_destinations" {
  description = "List of replication destinations with region and registry ID"
  type = list(object({
    region      = string
    registry_id = string
  }))
  default = []
}
variable "name" {
  
}
variable "image_tag_mutability" {
  
}
variable "scan_on_push" {
  
}
variable "tags" {
  
}
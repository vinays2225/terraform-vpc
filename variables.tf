#mandatory
variable "project" {
  type = string
}
#mandatory
variable "environment" {
  type = string
}

#optional
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

#optional
variable "vpc-tags" {
  type    = map(any)
  default = {}
}
#optional
variable "igw-tags" {
  type    = map(any)
  default = {}
}
#optional
variable "public-sub-cidr" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

#optional
variable "public-sub-tags" {
  type    = map(any)
  default = {}
}
#optional
variable "private-sub-cidr" {
  type    = list(any)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

#optional
variable "private-sub-tags" {
  type    = map(any)
  default = {}
}

#optional
variable "database-sub-cidr" {
  type    = list(any)
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

#optional
variable "database-sub-tags" {
  type    = map(any)
  default = {}
}

#optional
variable "public-route-tags" {
  type    = map(any)
  default = {}
}

#optional
variable "private-route-tags" {
  type    = map(any)
  default = {}
}

#optional
variable "database-route-tags" {
  type    = map(any)
  default = {}
}

#optional
variable "eip-tags" {
  type    = map(any)
  default = {}
}

#optional
variable "nat-gw-tags" {
  type    = map(any)
  default = {}
}

variable "peering-tags" {
  type=map
  default = {}
}

variable "is_peering_required" {
  type = bool
  default = false
}
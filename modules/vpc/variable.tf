variable region {}

variable vpc_name {
  default = "tf-handson"
}

variable root_block {
  default = "10.0.0.0/21"
}

variable public_block_a {
  default = "10.0.0.0/24"
}

variable public_block_c {
  default = "10.0.1.0/24"
}

variable private_block_a {
  default = "10.0.2.0/24"
}

variable private_block_c {
  default = "10.0.3.0/24"
}

variable private_block_d {
  default = "10.0.4.0/24"
}

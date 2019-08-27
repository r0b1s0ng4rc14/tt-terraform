variable "region" {
  default     = "us-east-1"
  description = "Main region"
}

variable "profile" {
  default = "seu_profile_no_credentials_aws"
}

variable "bucket" {
  default = "seu-bucket-test-xpto"
}

variable "tags" {
	type = "map"
}
variable "repo_names" {
  type = map(
    object(
      {
        name       = string,
        micro_repo = bool,
      }
    )
  )
}

variable "aws_access_key_id" {
  type = string
  sensitive = true
}

variable "aws_secret_key" {
  type = string
  sensitive = true
}

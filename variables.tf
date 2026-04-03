variable "repo_names" {
  type = map(
    object(
      {
        name         = string
        micro_repo   = bool
        ecr_workflow = bool
        services = list(object({
          name     = string
          ecr_repo = string
          context  = string
        }))
      }
    )
  )
}

variable "helm_services" {
  type = map(
    object(
      {
        name       = string
        chart_name = string
      }
    )
  )
}

variable "aws_envs" {
  type = list(string)
}

variable "aws_region" {
  type = string
}

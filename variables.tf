variable "repo_names" {
  type = map(
    object(
      {
        name       = string
        micro_repo = bool
        services = list(object({
          name     = string
          ecr_repo = string
          context  = string
        }))
      }
    )
  )
}

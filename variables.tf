variable "repo_names" {
  type = map(
    object(
      {
        name=string,
        micro_repo=boolean,
        }
    )
  )
}

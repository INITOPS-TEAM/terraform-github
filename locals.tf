locals {
  no_infra_repo = {
    for k, v in var.repo_names : k => v
      if v.ecr_workflow
    }

  docker_ecr_file_contents = {
    for file, repo in local.no_infra_repo : file =>
      length(repo.services) > 0
        ? templatefile("assets/docker_ecr.tfpl", { services = repo.services })
        : file("assets/docker_ecr.yml")
  }
}

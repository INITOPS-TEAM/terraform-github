locals {
  no_infra_repo = {
    for k, v in var.repo_names : k => v
    if v.ecr_workflow
  }

  docker_ecr_file_contents = {
    for file, repo in local.no_infra_repo : file =>
    length(repo.services) > 0
    ? templatefile("assets/docker_ecr_front.tfpl", { services = repo.services, aws_envs : var.aws_envs, aws_region : var.aws_region })
    : templatefile("assets/docker_ecr.tfpl", { aws_envs : var.aws_envs, aws_region : var.aws_region })
  }
}

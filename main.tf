resource "github_repository" "template" {

  name                   = "repo-template"
  visibility             = "private"
  delete_branch_on_merge = true
  is_template            = true

}

resource "github_repository" "initops_team" {
  for_each = var.repo_names

  name                   = each.value.micro_repo ? "buried-marks-${each.value.name}" : each.value.name
  description            = "Repositry managed by Terraform"
  visibility             = "public"
  delete_branch_on_merge = true

  template {
    owner                = "INITOPS-TEAM"
    repository           = github_repository.template.name
    include_all_branches = false
  }
}

resource "github_repository_file" "pr_template" {
  for_each = var.repo_names

  repository          = github_repository.initops_team[each.key].name
  file                = ".github/pull_request_template.md"
  content             = file(".github/pull_request_template.md")
  commit_message      = "Managed by Terraform"
  overwrite_on_create = true
}

resource "github_repository_file" "docker_ecr" {
  for_each = var.repo_names

  repository          = github_repository.initops_team[each.key].name
  file                = ".github/workflows/docker_ecr.yml"
  content             = length(each.value.services) > 0 ? templatefile(".github/workflows/docker_ecr.tfpl", {
    services_yml = yamlencode(each.value.services)
  }) : file(".github/workflows/docker_ecr.yml")
  commit_message      = "Managed by Terraform"
  overwrite_on_create = true
}

resource "github_branch_protection" "initops_team" {
  for_each = var.repo_names

  repository_id                   = github_repository.initops_team[each.key].node_id
  pattern                         = "main"
  enforce_admins                  = true
  require_conversation_resolution = true

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_last_push_approval      = true
    required_approving_review_count = 1
    # RUN SECOND TIME WITH COMMENTED LOWER LINE TO DELETE BYPASS PERMISSIONS FOR A USER PERSONALLY
    pull_request_bypassers          = [data.github_user.self.node_id]
  }
}

data "github_repositories" "buried-marks-repositories" {
  query = "org:INITOPS-TEAM buried-marks"
  include_repo_id = true
}

resource "github_actions_organization_secret" "aws_access_key_id" {
  secret_name      = "aws_access_key_id"
  visibility      = "selected"
  plaintext_value  = var.aws_access_key_id
}

resource "github_actions_organization_secret" "aws_secret_key" {
  secret_name      = "aws_secret_key"
  visibility      = "selected"
  plaintext_value  = var.aws_secret_key
}

resource "github_actions_organization_secret_repositories" "aws_secret_key" {
  secret_name             = github_actions_organization_secret.aws_secret_key.secret_name
  selected_repository_ids = data.github_repositories.buried-marks-repositories.repo_ids
}

resource "github_actions_organization_secret_repositories" "aws_access_key_id" {
  secret_name             = github_actions_organization_secret.aws_access_key_id.secret_name
  selected_repository_ids = data.github_repositories.buried-marks-repositories.repo_ids
}

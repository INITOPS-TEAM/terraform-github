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
  content             = file("assets/pull_request_template.md")
  commit_message      = "Managed by Terraform"
  overwrite_on_create = true
}

resource "github_repository_file" "docker_ecr" {
  for_each            = local.no_infra_repo
  repository          = github_repository.initops_team[each.key].name
  file                = ".github/workflows/docker_ecr.yml"
  content             = local.docker_ecr_file_contents[each.key]
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
    required_approving_review_count = 2
    # RUN SECOND TIME WITH COMMENTED LOWER LINE TO DELETE BYPASS PERMISSIONS FOR A USER PERSONALLY
    pull_request_bypassers = [data.github_user.self.node_id]
  }
}

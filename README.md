# Terraform Github

## What this repository is used for

- Repositories creation
- Branch protection
- `.github/pull_request_template.md` initialisation
- GitHub Action workflow files from `assets/` population

## Authentication

`export GITHUB_TOKEN` before `terrfaform apply` command.

- **Repositories:**
  - Administration - Read & write access
  - Contents - Read & write access
  - Metadata - Read & write access
- **Organizations:**
  - Administration - Read & write access

## Variables

Variables are stored in `terraform.tfvars.json` file.
You should change  `repo_names` according to your needs.

## Code Quality

### Automated Linting

GitHub Actions workflow runs on every pull request and push:

- **markdownlint**: Markdown formatting
- **Prettier**: Code formatting (JS, JSON, YAML, Markdown)
- **CSpell**: Spell checking
- **yamllint**: YAML syntax and style
- **tflint**: Terraform syntax and style
- **Gitleaks** - Secret scanning.
  To enable Gitleaks pre-commit hooks locally, install Gitleaks following [the official installation guide.](https://github.com/gitleaks/gitleaks#installing)

Most checks run as warnings. **npm-groovy-lint and tflint failures will block the merge** - fix syntax errors before merging.

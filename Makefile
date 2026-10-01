.PHONY: setup lint format typecheck test sql-lint tf-check dbt-parse check tf-up tf-pause

# 1. Environment & Dependencies (uv)
setup:
	uv sync --all-extras
	uv run pre-commit install

# 2. Python Quality Gates
lint:
	uv run ruff check .
	uv run ruff format --check .

format:
	uv run ruff check --fix .
	uv run ruff format .

typecheck:
	uv run mypy ingestion

test:
	uv run pytest -v

# 3. SQL & Infrastructure Validation
sql-lint:
	uv run sqlfluff lint dbt/models --dialect snowflake

tf-check:
	terraform -chdir=terraform fmt -check
	terraform -chdir=terraform validate

# 4. Universal Quality Gate (Executed by .ai/prompts/1-start.txt to 5-resume.txt)
check: lint typecheck test tf-check

# 5. FinOps Cost Control Shortcuts (AWS Always-On Compute Toggle)
tf-up:
	terraform -chdir=terraform apply -var="enable_always_on_compute=true"

tf-pause:
	terraform -chdir=terraform apply -var="enable_always_on_compute=false"

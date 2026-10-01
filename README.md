# 🤖 AI-Assisted Development Template

A universal, stack-agnostic template designed to eliminate "vibe coding" and enforce deterministic, high-quality output from autonomous AI agents (like Google Antigravity, OpenCode, Cursor, Claude Code, and other compatible tools).

This architecture treats the **File System as an API** paired with standardized **`Makefile` quality gates**, enabling a seamless cross-agent workflow where you can start a task with a fast model (e.g., Gemini Flash) and hand it off to a heavy-reasoning model (e.g., Gemini Pro, DeepSeek) at any moment without losing context.

### 🧠 Universal Autonomous Autopilot & Guidelines
This template includes an embedded `ai-workflow-guidelines.md` core file alongside universal compatibility bridge files (`.cursorrules`, `.windsurfrules`, `.github/copilot-instructions.md`, `AGENTS.md`, and `AI_INSTRUCTIONS.md`) to guarantee that any IDE or CLI harness seamlessly adopts the deterministic File System API workflow.

* **CLI Agents (Claude Code, Antigravity, Aider, OpenCode):** Automatically locate and route via `AGENTS.md` and `AI_INSTRUCTIONS.md` to load the workflow guidelines before executing tasks.
* **IDE Agents (Antigravity GUI, Cursor, Windsurf, VS Code / GitHub Copilot):** Automatically adapt to the deterministic File System API workflow via their native integration files (`AGENTS.md`, `.cursorrules`, `.windsurfrules`, and `.github/copilot-instructions.md`).

## ⚡ Core Philosophy

- **Zero Hallucination Context:** The AI relies entirely on local `.md` files (and active MCP servers) for state and architecture, not on transient chat history.
- **Continuous Cross-Agent Handoff:** Agents update the transition buffer (`.ai/handoff_state.md`) at the end of **every command execution** (`start`, `fix`, `ship`, `pause`, `resume`), allowing any other agent, model, or human to pick up immediately with zero state loss—even after unexpected session drops.
- **Deterministic Quality Gates (`Makefile` + Rules):** Engineering rules (SRP, idempotency, strict typing) live in `.ai/rules/`, while execution checks (`lint`, `typecheck`, `test`) are standardized via `make check` before any task is marked complete.
- **Branch Safety & PR Workflow:** Agents never commit directly to `main`. Every task runs inside a semantic feature branch and ships via Pull Request (`gh pr create`).
- **Stack Agnostic:** The template adapts cleanly to data engineering, backend, frontend, infrastructure (IaC), and AI/agentic projects.

## 📂 Architecture Overview

The brain of the system lives in the `.ai/` directory alongside a root `Makefile`:

```text
.
├── Makefile                    # Standardized quality gates (make setup, make check, make test)
└── .ai/
    ├── ai-workflow-guidelines.md # Canonical workflow rules and initialization protocol
    ├── todo.md                 # Short-term memory (Atomic sprint tasks & status)
    ├── context.md              # Long-term memory (Global architecture, ADRs & active stack)
    ├── handoff_state.md        # Continuous relay baton (Updated after every command - gitignored)
    ├── rules/                  # Modular Quality Gates (Injected on demand by stack)
    │   ├── 01-global.md
    │   ├── 02-python.md
    │   ├── 03-data.md
    │   ├── 04-ai-ops.md
    │   └── 05-frontend.md
    └── prompts/                # Orchestration triggers (CLI & IDE Chat)
        ├── 1-start.txt         # Create feature branch, execute task, validate & update state
        ├── 2-fix.txt           # Diagnose bug/trace, apply fix, validate & update state
        ├── 3-ship.txt          # Run make check, commit, push branch & open Pull Request
        ├── 4-pause.txt         # Explicit mid-task context dump (Check-out)
        └── 5-resume.txt        # Reload state from handoff_state.md (Check-in)
```

### AI Agent Integration Files

The template includes lightweight instruction entry points for different AI development environments:

- `.cursorrules` — Cursor
- `.windsurfrules` — Windsurf
- `AGENTS.md` — Agent-oriented coding tools (Antigravity, OpenCode, Claude Code)
- `AI_INSTRUCTIONS.md` — Generic AI instruction entry point
- `.github/copilot-instructions.md` — GitHub Copilot

These files intentionally contain only the minimum instructions required to bootstrap the workflow. The canonical workflow rules are defined in:

```text
.ai/ai-workflow-guidelines.md
```

When using the `zsh-ai-workflow` plugin, these integration files can be installed selectively with `ai-init`:

```bash
ai-init
ai-init --agent cursor
ai-init --agent windsurf
ai-init --agent agents
ai-init --agent generic
ai-init --agent copilot
ai-init --agent cursor --agent copilot
ai-init --all
```

### File Responsibilities

| File or directory | Responsibility |
|---|---|
| `Makefile` | Standardizes validation commands (`make check`, `make lint`, `make test`) across humans and agents |
| `.ai/todo.md` | Defines the current atomic tasks, priorities, and progress (`- [ ]` and `- [x]`) |
| `.ai/context.md` | Describes the project stack, architecture, conventions, and constraints |
| `.ai/handoff_state.md` | Continuously stores active branch, modified files, validation status, errors, and next steps after **every** command |
| `.ai/rules/` | Contains reusable quality and engineering rules loaded on demand |
| `.ai/prompts/` | Contains physical prompts used to start, fix, pause, resume, and ship work |

## 🚀 Getting Started

### 1. Create a repository from this template

Open the repository on GitHub and select **Use this template**:

[https://github.com/jhonatangs/ai-workflow-template](https://github.com/jhonatangs/ai-workflow-template)

Alternatively, clone it directly:

```bash
git clone https://github.com/jhonatangs/ai-workflow-template.git
cd ai-workflow-template
```

### 2. Define the project context

Edit `.ai/context.md` and describe the specific stack, architecture, conventions, and constraints of your project (e.g., `Snowflake + dbt + Airflow + Terraform`, `Vue.js + FastAPI`, `Python + PostgreSQL`).

### 3. Plan the work

Add the immediate sprint goals to `.ai/todo.md` using unchecked task items:

```markdown
- [ ] Define the initial project structure
- [ ] Configure the development environment
- [ ] Implement the first feature
- [ ] Add automated tests
```

## 🔄 The Tactical Loop (IDE Chat & Terminal CLI)

You can trigger the workflow either directly from your **IDE Agent Chat Panel** ( referencing the physical prompt files) or from the **Terminal CLI**.

### Option A: Operating via IDE Chat Panel (Antigravity / OpenCode / Cursor)

Instead of typing unstructured prompts in the IDE chat, reference the physical files in `.ai/prompts/`:

- **Start Task:** `Execute instructions in .ai/prompts/1-start.txt`
- **Fix Error:** `Execute instructions in .ai/prompts/2-fix.txt with error: <paste error or trace>`
- **Ship (Commit & PR):** `Execute instructions in .ai/prompts/3-ship.txt`
- **Pause Session:** `Execute instructions in .ai/prompts/4-pause.txt`
- **Resume Session:** `Execute instructions in .ai/prompts/5-resume.txt`

### Option B: Operating via Terminal CLI

#### 1. Start / Scaffolding (`1-start.txt`)
```bash
cat .ai/prompts/1-start.txt | antigravity
```
The agent reads `.ai/context.md`, `.ai/todo.md`, and `.ai/handoff_state.md`, ensures a semantic feature branch is active, implements the task, validates via `make check`, marks `- [x]` in `.ai/todo.md`, and updates `.ai/handoff_state.md`.

#### 2. Cross-Agent Handoff: Check-out (`4-pause.txt`)
If you need to stop mid-task or switch to a deeper reasoning model:
```bash
cat .ai/prompts/4-pause.txt | antigravity
```
Updates `.ai/handoff_state.md` with current branch, modified files, blockers, and exact next steps. *(Note: `handoff_state.md` is also automatically updated at the end of `1-start`, `2-fix`, `3-ship`, and `5-resume`).*

#### 3. Cross-Agent Handoff: Check-in (`5-resume.txt`)
Resume the task seamlessly with a different agent or model:
```bash
opencode --model deepseek-v4 --prompt-file .ai/prompts/5-resume.txt
```
The resuming agent reads `.ai/handoff_state.md` first, synchronizes with `.ai/context.md` and `.ai/todo.md`, and continues execution.

#### 4. Fix (`2-fix.txt`)
When a test fails or an issue is identified during review:
```bash
cat .ai/prompts/2-fix.txt | antigravity
```

#### 5. Ship & Pull Request (`3-ship.txt`)
Once changes are ready to be delivered:
```bash
cat .ai/prompts/3-ship.txt | antigravity
```
The ship workflow verifies branch safety (never pushing directly to `main`), runs `make check`, creates a Conventional Commit, pushes the feature branch, opens a Pull Request (`gh pr create --fill`), and logs the PR state in `.ai/handoff_state.md`.

## 🛠️ Customizing Granular Rules

The rules in `.ai/rules/` are modular and loaded on demand so agents only consume tokens relevant to the active layer. You can split or expand them for specialized stacks, for example:

```text
.ai/rules/
├── 01-global-git.md
├── 02-python-ingestion.md
├── 03-terraform-aws-finops.md
├── 04-snowflake-governance-lgpd.md
├── 05-dbt-quality-observability.md
├── 06-airflow-cosmos.md
└── 07-cortex-semantic-ai.md
```

## ⚙️ Terminal Integration (Zsh Router Plugin)

To execute orchestration prompts without manually piping files, install the official Zsh router plugin:

**[Zsh AI Workflow Plugin](https://github.com/jhonatangs/zsh-ai-workflow)**

```bash
ais <harness> <model> ["optional instruction"]
aif <harness> <model> ["optional error trace"]
aipause <harness> <model>
airesume <harness> <model>
aipr <harness> <model>
```

## 🔐 Recommended Git Configuration

Because `handoff_state.md` contains volatile session state, keep it in `.gitignore`:

```gitignore
.ai/handoff_state.md
```

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

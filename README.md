# 🤖 AI-Assisted Development Template

A universal, stack-agnostic template designed to eliminate "vibe coding" and enforce deterministic, high-quality output from autonomous AI agents (like Google Antigravity, OpenCode, Cursor, and other compatible tools.). 

This architecture treats the **File System as an API**, enabling a seamless cross-agent workflow where you can start a task with a fast model (e.g., Gemini Flash) and hand it off to a heavy-reasoning model (e.g., DeepSeek) without losing context.

### 🧠 Universal Autonomous Autopilot & Guidelines
This template includes an embedded `ai-workflow-guidelines.md` core file alongside universal compatibility bridge files (`.cursorrules`, `.windsurfrules`, `.github/copilot-instructions.md`, `AGENTS.md`, and `AI_INSTRUCTIONS.md`) to guarantee that any IDE or CLI harness seamlessly adopts the deterministic File System API workflow.

* **CLI Agents (Claude Code, Antigravity, Aider, OpenCode):** Automatically locate and route via `AGENTS.md` and `AI_INSTRUCTIONS.md` to load the workflow guidelines before executing tasks.
* **IDE Agents (Cursor, Windsurf, VS Code / GitHub Copilot):** Automatically adapt to the deterministic File System API workflow via their native integration files (`.cursorrules`, `.windsurfrules`, and `.github/copilot-instructions.md`).

## ⚡ Core Philosophy

- **Zero Hallucination Context:** The AI relies entirely on local `.md` files for state and architecture, not on its transient chat history.
- **Strict Quality Gates:** Engineering rules (SRP, idempotency, strict typing) are decoupled from prompts and injected dynamically based on the task.
- **Cross-Agent Handoff:** Agents dump their current state, errors, and next steps into a buffer file (`handoff_state.md`), allowing any other agent (or human) to pick up exactly where they left off.
- **Stack Agnostic:** The template can be adapted to frontend, backend, data engineering, automation, infrastructure, and other software projects.

## 📂 Architecture overview

The brain of the system lives in the `.ai/` directory:

```text
.ai/
├── todo.md             # Short-term memory (Sprint tasks & status)
├── context.md          # Long-term memory (Global architecture & active stack)
├── handoff_state.md    # The relay baton (Cross-agent transition buffer - gitignored)
├── rules/              # Quality Gates (Injected on demand)
│   ├── 01-global.md
│   ├── 02-python.md
│   ├── 03-data.md
│   ├── 04-ai-ops.md
│   └── 05-frontend.md
└── prompts/            # Terminal orchestration triggers
    ├── 1-start.txt     # Trigger autonomous scaffolding
    ├── 2-fix.txt       # Trigger bug fixes based on human review
    ├── 3-ship.txt      # Trigger conventional commits and PRs
    ├── 4-pause.txt     # Trigger context dump (Check-out)
    └── 5-resume.txt    # Trigger context load (Check-in)
```

### File responsibilities

| File or directory | Responsibility |
|---|---|
| `.ai/todo.md` | Defines the current tasks, priorities, and progress |
| `.ai/context.md` | Describes the project stack, architecture, conventions, and constraints |
| `.ai/handoff_state.md` | Stores the current agent state, known errors, decisions, and next steps |
| `.ai/rules/` | Contains reusable quality and engineering rules |
| `.ai/prompts/` | Contains prompts used to start, fix, pause, resume, and ship work |

The `handoff_state.md` file is normally generated or updated during the pause workflow. It should generally remain untracked because it represents temporary working state.

## 🚀 Getting Started

### 1. Create a repository from this template

Open the repository on GitHub and select **Use this template**:

<https://github.com/jhonatangs/ai-workflow-template>

Alternatively, clone it directly:

```bash
git clone https://github.com/jhonatangs/ai-workflow-template.git
cd ai-workflow-template
```

### 2. Define the project context

Edit `.ai/context.md` and describe the specific stack, architecture, conventions, and constraints of your project.

For example:

- Vue.js + FastAPI
- React + Node.js
- dbt + DuckDB + Airflow
- Python + PostgreSQL
- Terraform + Kubernetes

### 3. Plan the work

Add the immediate goals to `.ai/todo.md` using unchecked task items:

```markdown
- [ ] Define the initial project structure
- [ ] Configure the development environment
- [ ] Implement the first feature
- [ ] Add automated tests
```

### 4. Ensure your AI harness is installed

The commands in this README are examples for compatible terminal AI tools. Install and configure the harness you intend to use before executing them.

Depending on the tool, you may also need to configure authentication, model access, or a default project profile.

## 🔄 The Tactical Loop

Use the text files in `.ai/prompts/` as inputs for your terminal AI agents.
   
### 1. Scaffolding

Start the project using a compatible harness:

```bash
cat .ai/prompts/1-start.txt | antigravity
```

The agent should read `.ai/context.md` and `.ai/todo.md` before making changes.

### 2. Cross-Agent Handoff: Check-out

If the current model gets stuck or the task requires deeper reasoning, pause the current operation:

```bash
cat .ai/prompts/4-pause.txt | antigravity
```

The pause workflow should update `.ai/handoff_state.md` with information such as:

- Current task and progress
- Decisions already made
- Files changed
- Known errors or blockers
- Recommended next steps
- Commands that should be executed next

### 3. Cross-Agent Handoff: Check-in

Resume the task with a different agent or model:

```bash
opencode --model deepseek-v4 --prompt-file .ai/prompts/5-resume.txt
```

The resume workflow should read `.ai/handoff_state.md`, `.ai/context.md`, and `.ai/todo.md` before continuing.

> Model names and command-line options vary between tools and providers. Replace `deepseek-v4` and other example values with identifiers supported by your installed harness.

### 4. Fix

After manual review or when a specific issue is identified, use the fix prompt:

```bash
cat .ai/prompts/2-fix.txt | antigravity
```

### 5. Ship

Once the changes have been reviewed and approved, let the agent validate the work and prepare a commit:

```bash
cat .ai/prompts/3-ship.txt | antigravity
```

The ship workflow is intended to:

- Validate the current changes
- Run the relevant checks and tests
- Generate a Conventional Commit message
- Prepare a pull request when supported by the harness

Always review generated commits and pull requests before pushing or merging them.

## 🛠️ Customizing Rules

The rules in `.ai/rules/` are designed to be broadly reusable and focus on Software Engineering and Data Engineering best practices.

If your team requires specific linters, frameworks, architectural patterns, security requirements, or deployment conventions, update or add rule files.

Examples:

```text
.ai/rules/
├── 01-global.md
├── 02-python.md
├── 03-data.md
├── 04-ai-ops.md
├── 05-frontend.md
├── 06-security.md
└── 07-testing.md
```

The agents will use the updated rules on the next prompt execution.

## ⚙️ Terminal Integration

To execute orchestration prompts without manually piping files, install the official Zsh router plugin:

**[Zsh AI Workflow Plugin](https://github.com/jhonatangs/zsh-ai-workflow)**

The plugin provides strict, parameterized commands such as:

```bash
ais <harness> <model>
aif <harness> <model>
aipause <harness> <model>
airesume <harness> <model>
aipr <harness> <model>
```

These commands route tasks to the selected AI harness and model.

## 🔐 Recommended Git configuration

Because `handoff_state.md` contains temporary working state, consider adding it to `.gitignore`:

```gitignore
.ai/handoff_state.md
```

You may choose to track it instead if your team wants to preserve handoff history in version control.

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

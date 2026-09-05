# 🤖 AI-Assisted Development Template

A universal, stack-agnostic template designed to eliminate "vibe coding" and enforce deterministic, high-quality output from autonomous AI agents (like Google Antigravity, OpenCode, or Cursor). 

This architecture treats the **File System as an API**, enabling a seamless cross-agent workflow where you can start a task with a fast model (e.g., Gemini Flash) and hand it off to a heavy-reasoning model (e.g., DeepSeek) without losing context.

## ⚡ Core Philosophy

- **Zero Hallucination Context:** The AI relies entirely on local `.md` files for state and architecture, not on its transient chat history.
- **Strict Quality Gates:** Engineering rules (SRP, idempotency, strict typing) are decoupled from prompts and injected dynamically based on the task.
- **Cross-Agent Handoff:** Agents dump their current state, errors, and next steps into a buffer file (`handoff_state.md`), allowing any other agent (or human) to pick up exactly where they left off.

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

## 🚀 Getting Started

1. **Clone the Template:** Click the green **Use this template** button to start your new repository.
2. **Define the Context:** Edit `.ai/context.md` to define the specific stack of your new project (e.g., *Vue.js + FastAPI* or *dbt + DuckDB + Airflow*).
3. **Plan the Work:** Add your immediate goals to `.ai/todo.md` as unchecked boxes `[ ]`.

## 🔄 The Tactical Loop

Use the text files in `.ai/prompts/` as inputs for your terminal AI agents.

1. **Scaffolding (Start):**
   ```bash
   cat .ai/prompts/1-start.txt | antigravity
   ```
2. **Cross-Agent Handoff (Check-out):**
   If the current model gets stuck or the task requires deeper reasoning, pause it:
   ```bash
   cat .ai/prompts/4-pause.txt | antigravity
   ```
3. **Cross-Agent Handoff (Check-in):**
   Resume the task with a different agent/model (it will read `handoff_state.md`):
   ```bash
   opencode --model deepseek-v4 --prompt-file .ai/prompts/5-resume.txt
   ```
4. **Ship It:**
   Once manual review is approved, let the agent commit following *Conventional Commits*:
   ```bash
   cat .ai/prompts/3-ship.txt | antigravity
   ```

## 🛠️ Customizing Rules

The rules in `.ai/rules/` are designed to be stack-agnostic, focusing on Software Engineering and Data Engineering best practices. If your team requires specific linters or architectural patterns not covered, simply update the markdown files. The agents will adapt immediately on the next prompt execution.

## ⚙️ Terminal Integration

To execute orchestration prompts in the terminal without manually piping files (e.g., `cat .ai/prompts/1-start.txt | antigravity`), install the official Zsh router plugin:

🔗 **[Zsh AI Workflow Plugin](https://github.com/jhonatangs/zsh-ai-workflow)**

This plugin provides strict, parameterized commands (`ais`, `aipause`, `airesume`) to route tasks to your preferred harness and model seamlessly.

# SYSTEM CONTEXT: Deterministic AI-Assisted Development Workflow (v2.0)

## 1. Core Philosophy
You are operating within a strictly parameterized, deterministic AI-assisted development environment. We do not use "vibe coding" or unstructured chat loops. All code generation, validation, refactoring, and context handoffs are driven by the **File System acting as an API** paired with standardized **`Makefile` quality gates**.

## 2. CLI Execution Router & IDE Chat Triggers
The user orchestrates agents via the Zsh terminal router (`<command> <harness> <model>`)[cite: 2] or directly via IDE Chat Physical Prompts[cite: 1, 2]:
* `ais` / `Execute instructions in .ai/prompts/1-start.txt` -> Starts a new feature/task in a semantic feature branch[cite: 1, 2].
* `aif` / `Execute instructions in .ai/prompts/2-fix.txt with error: <trace>` -> Fixes bugs/errors and validates via `Makefile`[cite: 1, 2].
* `aipr` / `Execute instructions in .ai/prompts/3-ship.txt` -> Validates code (`make check`), commits, pushes branch, and opens a Pull Request[cite: 1, 2].
* `aipause` / `Execute instructions in .ai/prompts/4-pause.txt` -> Performs an explicit mid-task context dump before stopping[cite: 1, 2].
* `airesume` / `Execute instructions in .ai/prompts/5-resume.txt` -> Reloads context from `.ai/handoff_state.md` for a new agent/model[cite: 2].

## 3. Workspace Structure (.ai/ directory & Makefile)
Every project contains an `.ai/` directory initialized from the `ai-workflow-template` alongside a root `Makefile`. You must respect this structure:
* `.ai/context.md`: Long-term memory[cite: 2]. The absolute source of truth for the project's current state, architecture, and recent decisions[cite: 2].
* `.ai/todo.md`: Short-term memory[cite: 2]. The active checklist of pending (`- [ ]`) and completed (`- [x]`) tasks[cite: 2].
* `.ai/handoff_state.md`: The continuous relay baton (zignored)[cite: 2]. Stores the exact current branch, modified files, validation status, errors, and immediate next steps after EVERY command execution.
* `.ai/rules/`: Contains modular quality gates. You must validate all generated code against these rules.
* `.ai/prompts/`: Contains the instructional prompts used by the CLI or IDE Chat[cite: 1, 2].
* `Makefile`: Standardized interface for linting, type-checking, testing, and IaC validation (`make check`).

## 4. Your Responsibilities as the AI Agent
1. **Context First & MCP Inspection:** Before writing any code, always read `.ai/context.md`, `.ai/todo.md`, and `.ai/handoff_state.md` (if present). Query available MCP servers to inspect live schemas and docs.
2. **File System as API:** Do not output long snippets of code in the chat if you have tools to write directly to the file system. Apply the changes autonomously.
3. **Branch Safety & Makefile Gate:** Never commit or push directly to `main` or `master`. Always work on a semantic feature branch and run `make check` before considering any task complete.
4. **State Management (Continuous Handoff Sync):**
   - Upon completing a task, you MUST update `.ai/todo.md` to reflect progress.
   - If you introduce a new architectural decision or dependency, you MUST update `.ai/context.md`.
   - **CRITICAL:** Before ending your turn on ANY command (`1-start`, `2-fix`, `3-ship`, `4-pause`, `5-resume`), you MUST update `.ai/handoff_state.md` with the current branch, files touched, `make check` status, and next step so another agent can take over at any moment without data loss.
5. **Task Mutation Strict Syntax:** When updating `.ai/todo.md`, you MUST preserve the exact Markdown checklist format[cite: 2]:
   - Pending task: `- [ ] Task description`[cite: 2]
   - Completed task: `- [x] Task description`[cite: 2]
   - NEVER delete completed tasks, NEVER alter the numbering, and NEVER use custom tags like `[Done]` or `[Finished]`.
6. **Strict Compliance:** Adhere to the specific rules defined in the `.ai/rules/` directory based on the stack we are currently using.

## 5. Initialization Behavior
When entering a repository using this workflow:
1. Read `.ai/ai-workflow-guidelines.md`.
2. Read `.ai/context.md`.
3. Read `.ai/todo.md`.
4. Read `.ai/handoff_state.md` (if it exists in the workspace).
5. Identify the current task and verify the active Git branch.
6. Apply the relevant rules under `.ai/rules/`.
7. Follow the active workflow prompt under `.ai/prompts/`.
8. Begin execution without requiring an acknowledgment message.

# AGENTS.md — LLM Instructions Repository

This repository contains LLM instruction documents, skills, setup guides, and agent definitions for AI coding assistants. Use this file when working with agents (Cursor, Codex, Claude, etc.) in this repository.

## Project Structure

```
llm-instructions/
├── agents/          # Agent definitions (doc-search-agent, etc.)
├── frameworks/      # Framework docs (React Router, Next.js, Svelte, daisyUI)
├── guidelines/      # Design guidelines (e.g., Vercel web interface)
├── setup/           # Setup guides (ESLint, Prettier, Drizzle, etc.)
├── skills/          # Agent skills (create-pr, set-up-llm-docs, etc.)
└── scripts/         # Installation and utility scripts
```

## Key Commands

| Command                                      | Purpose                                                                               |
| -------------------------------------------- | ------------------------------------------------------------------------------------- |
| `./scripts/install-skills.sh skills/`        | Install skills from `skills/` to `~/.agents/skills` and symlink to `~/.claude/skills` |
| `./scripts/install-skills.sh --symlink-only` | Only create/update symlinks from existing `~/.agents/skills`                          |

## Conventions

### Skills

- Each skill lives in `skills/<name>/` with a `SKILL.md` file
- Skills use YAML frontmatter: `description`, `allowed-tools`, `argument-hint`, etc.
- Install script copies to `~/.agents/skills` and symlinks to `~/.claude/skills`

### Commit & PR

- Use conventional commit prefixes: `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `test:`, `ci:`, `chore:`, etc.
- Commit messages end with: `Generated with AI assistant`
- PR body includes attribution and summary.

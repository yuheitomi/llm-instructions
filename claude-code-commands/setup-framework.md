---
description: Setup framework development environment using configuration from setup directory
argument-hint: "[framework]"
allowed-tools: Edit(*), Write(*), Bash(pnpm:*), Bash(npm:*), Bash(bun:*), Bash(mkdir:*), LS(*), Read(*), WebFetch(*)
---

Please help me setup a framework development environment using the configuration files from the setup directory. Here's what I need you to do:

1. First, fetch the setup index from https://raw.githubusercontent.com/yuheitomi/llm-instructions/refs/heads/main/setup/index.md using `curl` or `wget` (prefer these over WebFetch)
2. Parse the index to understand available setup guides
3. Use the '$ARGUMENTS' keyword to find the most relevant setup guide(s)
4. If '$ARGUMENTS' is provided, search for setup guides that match the keyword in:
   - File names
   - Guide titles
   - Guide descriptions
5. If no keyword is provided or multiple matches are found, ask the user to clarify which setup they want
6. Download the selected setup guide to a temporary location
7. Read and execute the instructions from the setup guide
8. Provide a summary of what was configured

## Search Strategy:

When matching keywords, consider these common patterns:

- "prettier" → Prettier setup configuration
- "eslint" → ESLint setup configuration
- "svelte" or "svelte5" → Svelte 5 development environment setup
- "format" or "formatting" → Prettier setup configuration
- "lint" or "linting" → ESLint setup configuration

## Setup Process:

1. Create temporary directory if needed using `mkdir -p ./temp`
2. Download raw markdown files using `curl` or `wget` from: `https://raw.githubusercontent.com/yuheitomi/llm-instructions/refs/heads/main/setup/[file-name]`
3. Prefer `curl -o temp/setup.md URL` or `wget -O temp/setup.md URL` for downloads
4. Read the downloaded setup guide and follow its instructions
5. Execute the configuration steps as described in the guide
6. Clean up temporary files after successful setup

## Command Examples:

```bash
# Fetch setup index first
curl -s https://raw.githubusercontent.com/yuheitomi/llm-instructions/refs/heads/main/setup/index.md

# Download specific setup guides
curl -o ./temp/setup-prettier.md https://raw.githubusercontent.com/yuheitomi/llm-instructions/refs/heads/main/setup/setup-prettier.md
curl -o ./temp/setup-eslint.md https://raw.githubusercontent.com/yuheitomi/llm-instructions/refs/heads/main/setup/setup-eslint.md
curl -o ./temp/setup-svelte5.md https://raw.githubusercontent.com/yuheitomi/llm-instructions/refs/heads/main/setup/setup-svelte5.md
```

## Error Handling:

- If the keyword is ambiguous (multiple matches), list all matches and ask user to choose
- If no matches found, show available setup guides and ask for clarification
- If `curl` or `wget` download fails, provide clear error message and suggest alternatives
- If temporary directory cannot be created, suggest alternative location
- Only use WebFetch as a fallback if curl/wget are not available or fail
- If setup instructions fail, provide clear error message and suggest manual steps

## Tool Priority:

1. **First choice**: Use `curl` or `wget` for all HTTP requests
2. **Fallback**: Use WebFetch only if curl/wget fail or are unavailable
3. **Always**: Use `mkdir -p ./temp` to ensure temporary directory exists
4. **Execution**: Follow the instructions in the downloaded setup guide exactly as written
5. **Cleanup**: Remove temporary files after successful setup

## Important Notes:

- Read this document as guidance and customize the configuration appropriately for the specific project being worked on
- Detect the project structure, existing setup, and framework version before applying setup instructions
- If tools are already configured, improve the existing configuration using the provided instructions
- Ask for clarification if the proposed configuration does not match the existing setup
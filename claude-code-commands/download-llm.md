---
description: Download LLM instruction documents from the repository
argument-hint: "[keyword]"
allowed-tools: WebFetch(*), Bash(curl:*), Bash(wget:*), Bash(mkdir:*), Write(*), LS(*)
---

Please help me download LLM instruction documents from the yuheitomi/llm-instructions repository. Here's what I need you to do:

1. First, fetch the index from https://raw.githubusercontent.com/yuheitomi/llm-instructions/refs/heads/main/index.md using `curl` or `wget` (prefer these over WebFetch)
2. Parse the index to understand available documents
3. Use the '$ARGUMENTS' keyword to find the most relevant document(s)
4. If '$ARGUMENTS' is provided, search for documents that match the keyword in:
   - File names
   - Document titles
   - Document descriptions
5. If no keyword is provided or multiple matches are found, ask the user to clarify which document they want
6. Download the selected document(s) to the ./docs directory (create if it doesn't exist)
7. Provide a summary of what was downloaded

## Search Strategy:

When matching keywords, consider these common patterns:

- "react" → React Router documentation
- "next" or "nextjs" → Next.js documentation
- "daisy" or "daisyui" → daisyUI documentation
- "router" → React Router documentation
- "advanced" → Advanced React Router documentation

## Download Process:

1. Create ./docs directory if it doesn't exist using `mkdir -p ./docs`
2. Download raw markdown files using `curl` or `wget` from: `https://raw.githubusercontent.com/yuheitomi/llm-instructions/refs/heads/main/[file-path]`
3. Prefer `curl -o filename.md URL` or `wget -O filename.md URL` for downloads
4. Save files with descriptive names that include the framework/topic
5. Confirm successful download with file size and location

## Command Examples:

```bash
# Fetch index first
curl -s https://raw.githubusercontent.com/yuheitomi/llm-instructions/refs/heads/main/index.md

# Download specific documents
curl -o ./docs/react-router-v7.md https://raw.githubusercontent.com/yuheitomi/llm-instructions/refs/heads/main/frontend/react-router-v7.md
wget -O ./docs/nextjs-v15.md https://raw.githubusercontent.com/yuheitomi/llm-instructions/refs/heads/main/frontend/nextjs-v15.md
```

## Error Handling:

- If the keyword is ambiguous (multiple matches), list all matches and ask user to choose
- If no matches found, show available documents and ask for clarification
- If `curl` or `wget` download fails, provide clear error message and suggest alternatives
- If ./docs directory cannot be created, suggest alternative location
- Only use WebFetch as a fallback if curl/wget are not available or fail

## Tool Priority:

1. **First choice**: Use `curl` or `wget` for all HTTP requests
2. **Fallback**: Use WebFetch only if curl/wget fail or are unavailable
3. **Always**: Use `mkdir -p ./docs` to ensure directory exists

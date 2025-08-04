---
description: Commits changes in logical chunks with proper commit messages
argument-hint: "[target-branch]"
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git log:*), Bash(git diff:*), Bash(git ls-files:*)
---

Please help me commit my changes. Here's what I need you to do:

1. First, check the current git status to see what files have been modified
2. Analyze the changes and group them into 2-3 logical commits based on:
   - File types (tests, docs, config, etc.)
   - Feature areas (by directory/module)
   - Purpose of changes
3. Present the proposed commit chunks to the user and ask for confirmation before proceeding
4. Create separate commits for each logical group with appropriate commit messages following conventional commit format
5. Run typecheck or lint commands (if available in package.json) before committing to ensure code quality
6. If '$ARGUMENTS' is provided, use it as the target branch name (otherwise default to 'main')

Make sure each commit message ends with:

```
🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

## git commit-prefixes:

- feat: "Adding new features or modifying functionality"
- fix: "Bug fixes or typo corrections"
- docs: "Adding documentation"
- style: "Formatting changes, import order adjustments, or adding comments"
- refactor: "Code refactoring without affecting functionality"
- test: "Adding or modifying tests"
- build: "Changes affecting build system or dependencies"
- ci: "Changes related to CI/CD"
- perf: "Performance improvements"
- security: "Security-related changes"
- docker: "Modifications to Dockerfile or container-related changes"
- chore: "Miscellaneous changes"
---
description: Commits changes in logical chunks and creates a PR
argument-hint: "[target-branch]"
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git push:*), Bash(git log:*), Bash(git diff:*), Bash(git branch:*), Bash(git rev-parse:*), Bash(gh pr create:*), Bash(git ls-files:*)
---

Please help me commit my changes and create a pull request. Here's what I need you to do:

1. First, check the current git status to see what files have been modified
2. Analyze the changes and group them into logical commits based on:
   - File types (tests, docs, config, etc.)
   - Feature areas (by directory/module)
   - Purpose of changes
3. Create separate commits for each logical group with appropriate commit messages following conventional commit format
4. Push the changes to the remote repository
5. Create a pull request to the target branch (use '$ARGUMENTS' if provided, otherwise default to 'dev')
6. The PR should include:
   - A descriptive title
   - Summary of changes
   - List of commits included

Make sure each commit message ends with:

```
🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

For the pull request body, include a proper summary and the same attribution.

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

---
name: set-up-biome
description: Set up Biome as the code linter and formatter for your project.
allowed-tools:
  - Read
  - Write
---

# Instruction

- Analyze the project structure and existing configuration files to determine the best way to integrate Biome.
- Check the existing biome.jsonc file which reflects the user's preferences.
- Apply the necessary configurations to set up Biome as the linter and formatter.
  - Check the project's framework (e.g., Next.js, React Router, TanStack Router) to taior the Biome settings accordingly, especially for ignoring file patterns.
  - If there's an existing Biome configuration (biome.json or biome.jsonc), ask the user how to merge the new settings with the existing ones.
- Use appropriate Biome version schema based on the installed Biome in the project (if any) or install the latest Biome if not present.

# Template

- `biome.jsonc`: Configure Biome settings based on user preferences.

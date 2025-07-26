---
description: "Setup Prettier for consistent code formatting"
allowed-tools: Edit(*), Write(*), Bash(pnpm:*), Bash(bun:*), Bash(mkdir:*), LS(*)
---

# Instructions

Read this document as guidance and customize the configuration appropriately for the specific project being worked on. Detect the project structure, framework, and existing setup before applying these instructions.

If prettier is already configured, improve the existing configuration by using the provided instructions in this document. Ask for clarification if the proposed configuration does not match the existing setup or if there are any specific requirements that need to be addressed.

## Framework-Specific Prettier Setup

### React/TypeScript/Tailwind

### Install

Check for existing package manager and use appropriate command:

```bash
# pnpm
pnpm add -D prettier prettier-plugin-tailwindcss @trivago/prettier-plugin-sort-imports

# bun
bun add -D prettier prettier-plugin-tailwindcss @trivago/prettier-plugin-sort-imports
```

### Configuration

Create `.prettierrc`. If it already exists, merge the new settings with the existing ones. Use the following configuration as a base:

```json
{
  "semi": true,
  "singleQuote": false,
  "tabWidth": 2,
  "useTabs": false,
  "printWidth": 100,
  "trailingComma": "all",
  "endOfLine": "lf",
  "arrowParens": "always",
  "plugins": ["@trivago/prettier-plugin-sort-imports", "prettier-plugin-tailwindcss"],
  "importOrder": [...],,
  "importOrderSeparation": true,
  "importOrderSortSpecifiers": true
}
```

**Note**: Adjust `importOrder` based on framework detection:

<THIRD_PARTY_MODULES> will be replaced with the appropriate regex for third-party modules based on the detected framework (e.g., "@ai-sdk")

- **Next.js**: `["^react", "^next", "<THIRD_PARTY_MODULES>", "^@/", "^[./]"]`
- **React Router v7**: `["^react", "^@react-router", "<THIRD_PARTY_MODULES>", "^~", "^[./]"]`
- **General React**: `["^react", "<THIRD_PARTY_MODULES>", "^[./]"]`

### Svelte

#### Install

```bash
# pnpm
pnpm add -D prettier prettier-plugin-svelte

# bun
bun add -D prettier prettier-plugin-svelte
```

#### Configuration

```json
{
  "semi": true,
  "singleQuote": false,
  "tabWidth": 2,
  "useTabs": false,
  "printWidth": 100,
  "trailingComma": "all",
  "endOfLine": "lf",
  "arrowParens": "always",
  "plugins": ["prettier-plugin-svelte"],
  "overrides": [
    {
      "files": "*.svelte",
      "options": {
        "parser": "svelte"
      }
    }
  ]
}
```

## Scripts

Add to `package.json`, if it doesn't already exist. If scripts are already present, merge them with the existing ones:

```json
{
  "scripts": {
    "format": "prettier --write .",
    "format:check": "prettier --check ."
  }
}
```

## Ignore File

Generate `.prettierignore` based on project structure and detected frameworks:

**Base ignore patterns:**w

```
node_modules/
dist/
build/
package-lock.json
pnpm-lock.yaml
bun.lock
.env*
```

**Framework-specific additions:**

- **Next.js**: `.next/`, `out/`
- **Vite**: `dist/`, `dist-ssr/`
- **Create React App**: `build/`
- **Svelte/SvelteKit**: `.svelte-kit/`
- **Testing**: `coverage/`, `.nyc_output/`
- **Storybook**: `storybook-static/`
- **shadcn/ui**: `components/ui/`, `src/components/ui/`, `app/components/ui/`

## VS Code Integration

Create `.vscode/settings.json`. For Svelte projects, use formatter-specific settings:

**General setup:**
```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode"
}
```

**For Svelte projects:**
```json
{
  "editor.formatOnSave": true,
  "biome.enabled": false,
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[svelte]": {
    "editor.defaultFormatter": "svelte.svelte-vscode"
  }
}
```

---
description: "Setup Svelte 5 development environment with Prettier and ESLint"
allowed-tools: Edit(*), Write(*), Bash(pnpm:*), Bash(bun:*), Bash(mkdir:*), LS(*)
---

# Instructions

Read this document as guidance and customize the configuration appropriately for the specific project being worked on. Detect the project structure, existing setup, and framework version before applying these instructions.

If Svelte is already configured, improve the existing configuration by using the provided instructions in this document. Ask for clarification if the proposed configuration does not match the existing setup or if there are any specific requirements that need to be addressed.

Set up a complete Svelte 5 development environment with proper tooling for code formatting and linting.

## Package Manager Detection

Check for existing `package-lock.json`, `pnpm-lock.yaml`, or `bun.lockb` to detect the package manager in use. Use appropriate commands based on detection:

```bash
# pnpm
pnpm create svelte@latest
pnpm install
pnpm add -D prettier prettier-plugin-svelte eslint eslint-plugin-svelte @typescript-eslint/eslint-plugin @typescript-eslint/parser

# bun
bun create svelte@latest
bun install
bun add -D prettier prettier-plugin-svelte eslint eslint-plugin-svelte @typescript-eslint/eslint-plugin @typescript-eslint/parser
```

## Prettier Configuration

Check if `.prettierrc`, `.prettierrc.json`, or `prettier.config.js` already exists. If so, merge the new settings with existing ones. Otherwise, create `.prettierrc`:

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

## ESLint Configuration

Check if ESLint is already configured (`.eslintrc.js`, `.eslintrc.json`, `eslint.config.js`). If so, merge Svelte-specific settings with existing configuration. Otherwise, create `.eslintrc.js`:

```javascript
module.exports = {
  root: true,
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
    'plugin:svelte/recommended'
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    sourceType: 'module',
    ecmaVersion: 2020,
    extraFileExtensions: ['.svelte']
  },
  env: {
    browser: true,
    es2017: true,
    node: true
  },
  overrides: [
    {
      files: ['*.svelte'],
      parser: 'svelte-eslint-parser',
      parserOptions: {
        parser: '@typescript-eslint/parser'
      }
    }
  ]
};
```

## VS Code Settings

Check if `.vscode/settings.json` already exists. If so, merge the formatter settings with existing ones. Otherwise, create `.vscode/settings.json`:

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

## Scripts

Check existing scripts in `package.json` and add missing ones. Merge with existing scripts if they already exist:

```json
{
  "scripts": {
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "lint": "eslint . --ext .js,.ts,.svelte",
    "lint:fix": "eslint . --ext .js,.ts,.svelte --fix"
  }
}
```

## Ignore Files

Generate ignore files based on detected project structure. Check if they already exist and merge patterns if needed.

Create `.prettierignore`:

```
node_modules/
dist/
build/
.svelte-kit/
package-lock.json
pnpm-lock.yaml
bun.lock
.env*
```

Create `.eslintignore`:

```
node_modules/
dist/
build/
.svelte-kit/
```
# Instructions

Read this document as guidance and customize the configuration appropriately for the specific project being worked on. **Always plan and propose changes before implementing them.**

## Planning Phase

Before making any changes, follow these steps:

1. **Assess Current State**

   - Check if ESLint is already installed: `ls package.json` and look for eslint dependencies
   - Check for existing configuration: `ls eslint.config.js .eslintrc.*`
   - Identify project structure and framework (React, Next.js, Svelte, etc.)
   - Check package manager in use (npm, pnpm, bun)

2. **Detect Project Requirements**

   - Identify TypeScript usage: `ls tsconfig.json`
   - Check for testing frameworks: look for jest, vitest, cypress in dependencies
   - Identify UI frameworks: check for React, Vue, Svelte in dependencies
   - Check for existing linting scripts in package.json

3. **Plan Configuration Strategy**

   - Propose which ESLint configuration template to use
   - List dependencies that need to be installed
   - Identify any conflicts with existing setup
   - Plan migration strategy if upgrading from ESLint 8.x

4. **Present Proposal**
   - Show the user what will be installed
   - Explain the configuration approach
   - Ask for confirmation before proceeding
   - Clarify any specific requirements or preferences

## Implementation Phase

Only proceed with installation and configuration after the user approves the plan.

If ESLint is already configured, improve the existing configuration by using the provided instructions in this document. Ask for clarification if the proposed configuration does not match the existing setup or if there are any specific requirements that need to be addressed.

## ESLint Setup for Modern JavaScript/TypeScript Projects

### Install

Check for existing package manager and use appropriate command:

```bash
# pnpm
pnpm add -D eslint @eslint/js typescript-eslint

# npm
npm install -D eslint @eslint/js typescript-eslint

# bun
bun add -D eslint @eslint/js typescript-eslint
```

**Migration from ESLint 8.x:**
If migrating from an existing ESLint configuration, use the official migrator:

```bash
npx @eslint/migrate-config .eslintrc.json
```

### Framework-Specific Dependencies

**React Projects:**

```bash
# pnpm
pnpm add -D eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-jsx-a11y

# npm
npm install -D eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-jsx-a11y

# bun
bun add -D eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-jsx-a11y
```

**Next.js Projects:**

```bash
# pnpm (Note: @next/eslint-plugin-next may not fully support flat config yet)
pnpm add -D @next/eslint-plugin-next

# npm
npm install -D @next/eslint-plugin-next

# bun
bun add -D @next/eslint-plugin-next
```

**Svelte Projects:**

```bash
# pnpm
pnpm add -D eslint-plugin-svelte

# npm
npm install -D eslint-plugin-svelte

# bun
bun add -D eslint-plugin-svelte
```

### Globals Package

The `globals` package provides global identifiers from different JavaScript environments.

**Important:** ESLint 9 and later require you to depend on this package directly in your ESLint config (it's not automatically included like in ESLint 8).

**Custom Globals:**

```javascript
globals: {
  ...globals.browser,
  myCustomGlobal: 'readonly',    // Read-only global
  myWritableGlobal: 'writable',  // Writable global
}
```

### Configuration

Create `eslint.config.js` (ESLint 9+ flat config). If it already exists, merge the new settings with the existing ones.

**Note:** ESLint 9 makes flat config the default. Legacy `.eslintrc.*` files are no longer supported.

**Base TypeScript Configuration (2025 Best Practices):**

```javascript
// @ts-check
import { defineConfig } from "@eslint/config";
import js from "@eslint/js";
import tseslint from "typescript-eslint";
import globals from "globals";

export default defineConfig([
  // Global ignores
  {
    ignores: ["dist/", "build/", "node_modules/", "**/*.d.ts", "coverage/", ".config/"],
  },

  // Base configuration
  js.configs.recommended,
  ...tseslint.configs.recommended,

  {
    languageOptions: {
      ecmaVersion: 2025,
      sourceType: "module",
      globals: {
        ...globals.browser,
        ...globals.node,
        ...globals.es2025,
      },
    },
    rules: {
      // TypeScript-specific rules
      "@typescript-eslint/no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
      "@typescript-eslint/explicit-function-return-type": "off",
      "@typescript-eslint/explicit-module-boundary-types": "off",
      "@typescript-eslint/no-explicit-any": "warn",
      "@typescript-eslint/prefer-nullish-coalescing": "error",
      "@typescript-eslint/prefer-optional-chain": "error",
    },
  },

  // TypeScript files specific configuration
  {
    files: ["**/*.ts", "**/*.tsx"],
    languageOptions: {
      parser: tseslint.parser,
      parserOptions: {
        project: "./tsconfig.json",
      },
    },
  },
]);
```

**React Configuration:**

```javascript
// @ts-check
import { defineConfig } from "@eslint/config";
import js from "@eslint/js";
import tseslint from "typescript-eslint";
import react from "eslint-plugin-react";
import reactHooks from "eslint-plugin-react-hooks";
import jsxA11y from "eslint-plugin-jsx-a11y";
import globals from "globals";

export default defineConfig([
  // Global ignores
  {
    ignores: ["dist/", "build/", "node_modules/", "**/*.d.ts", "coverage/", "public/"],
  },

  // Base configuration
  js.configs.recommended,
  ...tseslint.configs.recommended,
  react.configs.flat.recommended,
  react.configs.flat["jsx-runtime"],
  jsxA11y.flatConfigs.recommended,

  {
    languageOptions: {
      ecmaVersion: 2025,
      sourceType: "module",
      globals: {
        ...globals.browser,
        ...globals.es2025,
      },
      parserOptions: {
        ecmaFeatures: {
          jsx: true,
        },
      },
    },
    plugins: {
      "react-hooks": reactHooks,
    },
    rules: {
      ...reactHooks.configs.recommended.rules,
      "react/prop-types": "off", // Using TypeScript for prop validation
      "react/react-in-jsx-scope": "off", // Not needed in React 17+
      "@typescript-eslint/no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
    },
    settings: {
      react: {
        version: "detect",
      },
    },
  },
]);
```

**Next.js Configuration:**

```javascript
// @ts-check
import { defineConfig } from "@eslint/config";
import js from "@eslint/js";
import tseslint from "typescript-eslint";
import globals from "globals";

export default defineConfig([
  // Global ignores
  {
    ignores: [
      ".next/",
      "out/",
      "dist/",
      "build/",
      "node_modules/",
      "**/*.d.ts",
      "coverage/",
      "next-env.d.ts",
    ],
  },

  // Base configuration
  js.configs.recommended,
  ...tseslint.configs.recommended,

  {
    languageOptions: {
      ecmaVersion: 2025,
      sourceType: "module",
      globals: {
        ...globals.browser,
        ...globals.node,
        ...globals.es2025,
      },
    },
    rules: {
      "@typescript-eslint/no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
      // Next.js specific rules (add @next/eslint-plugin-next when using)
      // '@next/next/no-html-link-for-pages': 'error',
    },
  },

  // Server-side files
  {
    files: ["**/*.config.{js,ts}", "**/middleware.{js,ts}"],
    languageOptions: {
      globals: {
        ...globals.node,
      },
    },
  },
]);
```

**Svelte Configuration:**

```javascript
// @ts-check
import { defineConfig } from "@eslint/config";
import js from "@eslint/js";
import tseslint from "typescript-eslint";
import svelte from "eslint-plugin-svelte";
import globals from "globals";
// import svelteConfig from './svelte.config.js';

export default defineConfig([
  // Global ignores
  {
    ignores: [
      ".svelte-kit/",
      "build/",
      "dist/",
      "node_modules/",
      "**/*.d.ts",
      "coverage/",
      "src/app.html",
    ],
  },

  // Base configuration
  js.configs.recommended,
  ...tseslint.configs.recommended,
  ...svelte.configs["flat/recommended"],

  {
    languageOptions: {
      ecmaVersion: 2025,
      sourceType: "module",
      globals: {
        ...globals.browser,
        ...globals.node,
        ...globals.es2025,
      },
    },
  },

  // Svelte files specific configuration
  {
    files: ["**/*.svelte"],
    languageOptions: {
      parserOptions: {
        parser: tseslint.parser,
        project: "./tsconfig.json",
        extraFileExtensions: [".svelte"],
        // svelteConfig, // Uncomment if using custom Svelte config
      },
    },
    rules: {
      "@typescript-eslint/no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
      "svelte/no-at-html-tags": "error",
      "svelte/no-target-blank": "error",
      "svelte/no-unused-props": "error",
      "svelte/valid-compile": "error",
      "svelte/no-reactive-functions": "error",
    },
  },
]);
```

## Scripts

Add to `package.json`, if they don't already exist. If scripts are already present, merge them with the existing ones:

```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "lint:check": "eslint . --max-warnings 0"
  }
}
```

## Ignore Patterns

**Note:** ESLint 9 flat config uses `ignores` property in the configuration file instead of `.eslintignore` files.

Ignore patterns are now defined directly in the configuration:

**Base ignore patterns:**

```javascript
{
  ignores: [
    'node_modules/',
    'dist/',
    'build/',
    '**/*.d.ts',
    'coverage/',
  ],
}
```

**Framework-specific ignore patterns:**

```javascript
// Next.js
{
  ignores: [".next/", "out/", "next-env.d.ts", "public/"];
}

// Vite
{
  ignores: ["dist/", "dist-ssr/", "vite-env.d.ts"];
}

// Svelte/SvelteKit
{
  ignores: [".svelte-kit/", "src/app.html", "static/"];
}

// Testing
{
  ignores: ["coverage/", ".nyc_output/", "test-results/"];
}
```

## VS Code Integration

Create or update `.vscode/settings.json`:

```json
{
  "eslint.validate": ["javascript", "javascriptreact", "typescript", "typescriptreact", "svelte"],
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "eslint.workingDirectories": ["."]
}
```

## Integration with Prettier

**Note:** ESLint 9 has deprecated formatter rules to reduce conflicts with Prettier. The recommended approach is to separate ESLint and Prettier.

If you still need integration, install:

```bash
# pnpm
pnpm add -D eslint-config-prettier

# npm
npm install -D eslint-config-prettier

# bun
bun add -D eslint-config-prettier
```

Add to your `eslint.config.js`:

```javascript
import prettier from "eslint-config-prettier";

export default defineConfig([
  // ... other configs
  prettier, // Should be last to override other configs
]);
```

**Recommended:** Use separate commands for linting and formatting:

```json
{
  "scripts": {
    "lint": "eslint .",
    "format": "prettier --write .",
    "check": "eslint . && prettier --check ."
  }
}
```

## Common Rules Customization

### Strict TypeScript Rules

```javascript
{
  files: ['**/*.ts', '**/*.tsx'],
  rules: {
    '@typescript-eslint/strict-boolean-expressions': 'error',
    '@typescript-eslint/prefer-nullish-coalescing': 'error',
    '@typescript-eslint/prefer-optional-chain': 'error',
    '@typescript-eslint/no-unnecessary-condition': 'error',
    '@typescript-eslint/no-floating-promises': 'error',
    '@typescript-eslint/await-thenable': 'error',
  }
}
```

### Performance Rules

```javascript
{
  rules: {
    'no-console': 'warn',
    'no-debugger': 'error',
    'prefer-const': 'error',
    'no-var': 'error',
    'prefer-template': 'error',
    'object-shorthand': 'error',
  }
}
```

### Security Rules

```javascript
{
  rules: {
    'no-eval': 'error',
    'no-implied-eval': 'error',
    'no-script-url': 'error',
    'no-new-func': 'error',
    'no-global-assign': 'error',
  }
}
```

## Testing Integration

For projects with testing frameworks, add appropriate configurations:

```javascript
// Jest/Vitest configuration
{
  files: ['**/*.test.{js,ts,jsx,tsx}', '**/*.spec.{js,ts,jsx,tsx}'],
  languageOptions: {
    globals: {
      ...globals.jest, // or globals.vitest
    },
  },
  rules: {
    '@typescript-eslint/no-explicit-any': 'off',
    'no-console': 'off',
    '@typescript-eslint/no-non-null-assertion': 'off',
  },
},

// E2E test configuration
{
  files: ['e2e/**/*.{js,ts}', '**/*.e2e.{js,ts}'],
  languageOptions: {
    globals: {
      ...globals.node,
    },
  },
  rules: {
    'no-console': 'off',
  },
}
```

## Development Tools

### ESLint Config Inspector

For debugging and visualizing your flat config:

```bash
# Install globally
npm install -g @eslint/config-inspector

# Run in your project
eslint-config-inspector
```

### Pre-commit Hook Integration

If using Husky or similar tools:

```json
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx,svelte}": ["eslint --fix", "prettier --write"]
  }
}
```

### Package.json Scripts for CI/CD

```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "lint:check": "eslint . --max-warnings 0",
    "type-check": "tsc --noEmit",
    "check-all": "npm run lint:check && npm run type-check && prettier --check ."
  }
}
```

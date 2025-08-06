# Instructions

Read this document as guidance and customize the configuration appropriately for the specific project being worked on. **Always plan and propose changes before implementing them.**

**ASSUMPTION: This guide assumes you have an existing React Router v7 project created with a template or create command, using Vite as the build tool.**

## Planning Phase

Before making any changes, follow these steps:

1. **Assess Current State**

   - Verify React Router v7 is installed: `ls package.json` and confirm `react-router` and `@react-router/dev` packages
   - Check deployment platform: look for `vercel.json`, `wrangler.toml`, or deployment scripts
   - Check existing tooling: `ls eslint.config.js .prettierrc vite.config.ts`
   - Check package manager in use (npm, pnpm, bun) by looking for lock files
   - Verify Vite configuration exists: `ls vite.config.ts vite.config.js`

2. **Detect Project Requirements**

   - Confirm TypeScript usage: `ls tsconfig.json`
   - Check for Tailwind CSS: `ls tailwind.config.*` or check dependencies
   - Identify deployment platform: Vercel (vercel.json) or Cloudflare (wrangler.toml)
   - Check existing formatting/linting: look for scripts in package.json
   - Verify React Router v7 structure: `ls app/routes.ts app/root.tsx`

3. **Plan Configuration Strategy**

   - Plan Prettier setup with React Router v7 import ordering
   - Plan ESLint configuration for React Router v7 + React
   - Plan Vite configuration enhancements (warmup, deployment adapters)
   - Plan VS Code integration improvements
   - Identify missing development tooling

4. **Present Proposal**
   - Show what tooling will be installed/configured
   - Explain the configuration enhancements
   - Confirm deployment platform for adapter setup
   - Ask for confirmation before proceeding

## Implementation Phase

Only proceed with installation and configuration after the user approves the plan.

This guide focuses on enhancing an existing React Router v7 project with proper development tooling and deployment configuration.

## Package Manager Detection

Check for existing `package-lock.json`, `pnpm-lock.yaml`, or `bun.lock` to detect the package manager in use.

## Deployment Platform Detection & Configuration

Check for deployment platform indicators and install appropriate adapters:

**Vercel Detection:**

```bash
# Check for vercel configuration
ls vercel.json .vercel/

# Install Vercel adapter if detected
pnpm add -D @react-router/vercel
# or
npm install -D @react-router/vercel
# or
bun add -D @react-router/vercel
```

**Cloudflare Detection:**

```bash
# Check for Cloudflare Workers configuration
ls wrangler.toml

# Install Cloudflare adapter if detected
pnpm add -D @react-router/cloudflare
# or
npm install -D @react-router/cloudflare
# or
bun add -D @react-router/cloudflare
```

## Essential Development Tooling Setup

**IMPORTANT: Use the dedicated setup guides for proper configuration:**

1. **Prettier Setup**: Follow instructions in `@setup/setup-prettier.md`

   - Use React Router v7 specific import ordering: `["^react", "^@react-router", "^[a-zA-Z]", "^~", "^[./]"]`
   - Ensure `.react-router/` is added to `.prettierignore`

2. **ESLint Setup**: Follow instructions in `@setup/setup-eslint.md`
   - Use React configuration from the setup guide
   - Ensure `.react-router/` is added to ignore patterns
   - Include server-side file configuration for `**/*.server.{js,ts,tsx}` and `**/entry.server.tsx`

## Vite Configuration Enhancement

Update or create `vite.config.ts` with React Router v7 optimizations and deployment adapters:

```tsx
import { reactRouter } from "@react-router/dev/vite";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "vite";
import tsconfigPaths from "vite-tsconfig-paths";

export default defineConfig({
  plugins: [tailwindcss(), reactRouter(), tsconfigPaths()],
  server: {
    warmup: {
      clientFiles: ["./app/**/!(*.server|*.test)*.tsx"],
    },
  },
});
```

**For Vercel deployment, update to:**

```tsx
import { reactRouter } from "@react-router/dev/vite";
import { vercelPreset } from "@react-router/vercel";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "vite";
import tsconfigPaths from "vite-tsconfig-paths";

export default defineConfig({
  plugins: [
    tailwindcss(),
    reactRouter({
      presets: [vercelPreset()],
    }),
    tsconfigPaths(),
  ],
  server: {
    warmup: {
      clientFiles: ["./app/**/!(*.server|*.test)*.tsx"],
    },
  },
});
```

**For Cloudflare deployment, update to:**

```tsx
import { reactRouter } from "@react-router/dev/vite";
import { cloudflareDevProxyVitePlugin } from "@react-router/dev/vite/cloudflare";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "vite";
import tsconfigPaths from "vite-tsconfig-paths";

export default defineConfig({
  plugins: [cloudflareDevProxyVitePlugin(), tailwindcss(), reactRouter(), tsconfigPaths()],
  server: {
    warmup: {
      clientFiles: ["./app/**/!(*.server|*.test)*.tsx"],
    },
  },
});
```

## Prettier and ESLint Configuration

**Follow the dedicated setup guides with React Router v7 specific customizations:**

### Prettier Configuration

1. **Follow `@setup/setup-prettier.md`** for base setup
2. **React Router v7 Specific Customizations:**
   - Use import order: `["^react", "^@react-router", "^[a-zA-Z]", "^~", "^[./]"]`
   - Add `.react-router/` to `.prettierignore`

### ESLint Configuration

1. **Follow `@setup/setup-eslint.md`** for React configuration
2. **React Router v7 Specific Customizations:**
   - Add `.react-router/` to ignore patterns
   - Add server-side file configuration:
   ```javascript
   // Server-side files
   {
     files: ["**/*.server.{js,ts,tsx}", "**/entry.server.tsx"],
     languageOptions: {
       globals: {
         ...globals.node,
       },
     },
   },
   ```

## VS Code Integration

Create or update `.vscode/settings.json` for React Router v7 development:

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "eslint.validate": ["javascript", "javascriptreact", "typescript", "typescriptreact"],
  "eslint.workingDirectories": ["."],
  "typescript.preferences.importModuleSpecifier": "relative",
  "typescript.suggest.autoImports": true
}
```

## Scripts Enhancement

Add or update these scripts in `package.json`:

```json
{
  "scripts": {
    "dev": "react-router dev",
    "build": "react-router build",
    "start": "react-router-serve build/server/index.js",
    "typecheck": "react-router typegen && tsc",
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "check-all": "npm run lint:check && npm run typecheck && npm run format:check"
  }
}
```

## TypeScript Configuration

Ensure your `tsconfig.json` includes generated types:

```json
{
  "include": ["**/*.ts", "**/*.tsx", ".react-router/types/**/*"],
  "compilerOptions": {
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "target": "ES2022",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "moduleDetection": "force",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "paths": {
      "~/*": ["./app/*"]
    }
  }
}
```

## CLAUDE.md Creation for React Router v7

Create or update `CLAUDE.md` in the project root to help Claude Code understand React Router v7 best practices:

````markdown
# React Router v7 Framework Mode - Development Guidelines

## Critical Rules for Claude Code

### Route Type Imports - MOST IMPORTANT RULE

**ALWAYS use `./+types/[routeName]` for route type imports - NEVER use relative paths**

```tsx
// ✅ CORRECT - ALWAYS use this pattern:
import type { Route } from "./+types/product-details";
import type { Route } from "./+types/home";

// ❌ NEVER use relative paths:
// import type { Route } from "../+types/product-details"; // WRONG!
```
````

### Type Generation Workflow

- Run `npm run typecheck` after adding/renaming any routes
- Types are auto-generated in `.react-router/types/`
- Never manually modify generated types
- Start dev server to auto-generate types

### Package Guidelines

**✅ Use these packages:**

- `react-router` - Main routing package
- `@react-router/dev` - Development tools
- `@react-router/node` - Node.js adapter
- `@react-router/vercel` - Vercel adapter
- `@react-router/cloudflare` - Cloudflare adapter

**❌ NEVER use these legacy packages:**

- `react-router-dom` - Legacy, use `react-router` instead
- `@remix-run/*` - Old packages, replaced by `@react-router/*`

### Route Module Pattern

```tsx
import type { Route } from "./+types/route-name";

export async function loader({ params }: Route.LoaderArgs) {
  return { data: await fetchData(params.id) };
}

export async function action({ request }: Route.ActionArgs) {
  const formData = await request.formData();
  return redirect(href("/success"));
}

export default function Component({ loaderData }: Route.ComponentProps) {
  return <div>{loaderData.data.name}</div>;
}
```

### Layout Routes with Children

**Always use `<Outlet />` for layout routes that have children:**

```tsx
import { Outlet } from "react-router";

export default function Layout() {
  return (
    <div>
      <nav>Navigation</nav>
      <main>
        <Outlet /> {/* ✅ This renders child routes */}
      </main>
    </div>
  );
}
```

### Type-Safe Navigation

**Always use `href()` for dynamic URLs:**

```tsx
import { Link, href, useNavigate } from "react-router";

// ✅ Type-safe URL generation
<Link to={href("/products/:id", { id: product.id })}>Product</Link>;

// ✅ Programmatic navigation
const navigate = useNavigate();
navigate(href("/products/:id", { id: newId }));

// ✅ In actions/loaders
return redirect(href("/products/:id", { id: params.id }));
```

### Route Configuration

Routes are configured in `app/routes.ts` (the source of truth):

```tsx
import { type RouteConfig, index, route } from "@react-router/dev/routes";

export default [
  index("routes/home.tsx"),
  route("products/:id", "routes/product-details.tsx"),
  route("*", "routes/404.tsx"), // Catch-all must be last
] satisfies RouteConfig;
```

### Project Structure

```
app/
├── routes.ts              # Route configuration (source of truth)
├── root.tsx              # Root layout
└── routes/               # Route modules
    ├── home.tsx         # Use descriptive names
    ├── product-details.tsx
    └── 404.tsx
```

### Common Commands

- `npm run dev` - Start development server
- `npm run typecheck` - Generate types and run TypeScript check
- `npm run build` - Build for production
- `npm run lint` - Run ESLint
- `npm run format` - Format with Prettier

### Anti-Patterns to Avoid

❌ Component-based routing (`<Routes><Route element={} /></Routes>`)
❌ Manual data fetching in components (use loaders instead)
❌ Manual form handling (use actions and `<Form>` instead)
❌ Constructing URLs manually (use `href()` instead)
❌ Using children props in layouts (use `<Outlet />` instead)

## Development Workflow

1. Always run `typecheck` after route changes
2. Use generated types from `./+types/[routeName]`
3. Use `<Form>` for data mutations
4. Use `href()` for all dynamic URLs
5. Use `<Outlet />` in layouts

## Common Patterns

### Data Loading with Error Handling

```tsx
export async function loader({ params }: Route.LoaderArgs) {
  try {
    const data = await fetchData(params.id);
    return { data };
  } catch (error) {
    throw data("Failed to load data", { status: 500 });
  }
}
```

### Form Handling with Validation

```tsx
export async function action({ request }: Route.ActionArgs) {
  const formData = await request.formData();
  const result = validateFormData(formData);

  if (!result.success) {
    return { errors: result.errors };
  }

  await saveData(result.data);
  return redirect(href("/success"));
}
```

### Meta Tags and SEO

```tsx
export function meta({ data }: Route.MetaArgs) {
  return [
    { title: data.product.name },
    { name: "description", content: data.product.description },
    { property: "og:title", content: data.product.name },
  ];
}
```

## Migration from React Router v6

1. **Remove legacy packages**: `react-router-dom`
2. **Install v7 packages**: `react-router`, `@react-router/dev`
3. **Replace component routing** with `routes.ts` configuration
4. **Update imports**: `react-router-dom` → `react-router`
5. **Convert route components** to use generated types
6. **Replace manual data fetching** with loaders
7. **Replace form handling** with actions
8. **Run typecheck** to generate types

This ensures you get the full benefits of React Router v7's type safety, performance, and developer experience improvements.

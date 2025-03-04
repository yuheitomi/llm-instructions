# React Router v7 Framework Mode Reference Guide

> **Important:** React Router v7 can be used in two distinct ways:
>
> 1. As a traditional client-side routing library (similar to RRv6)
> 2. As a full-stack framework with server-side features (similar to Remix)
>
> This guide focuses primarily on the framework approach, which is the major new addition in v7.

This document serves as my reference for assisting users with React Router v7 in framework mode. It focuses on key differences from React Router v6 and Remix v2, with practical guidance for helping users implement common patterns.

## Installation & Setup

React Router v7 requires:

- Node 20+
- React 18+
- React DOM 18+

Basic installation:

```bash
npx create-react-router@latest my-react-router-app
cd my-react-router-app
npm i
npm run dev
```

## Key Concepts to Understand

### Framework vs. Library Modes

When users mention "React Router," I need to determine which mode they're using:

- **Framework mode**: Full-stack approach with SSR, data loading, actions, etc.
- **Library mode**: Traditional client-side routing similar to RRv6

Framework mode has a completely different architecture from library mode. When users don't specify which they're using, I should ask for clarification or check their code to determine the mode.

### Project Structure

Typical framework-mode project structure:

```
app/
├── root.tsx              # Root layout with <html> document
├── routes.ts             # Route configuration
├── routes/               # Route modules
│   ├── _index.tsx        # Index route
│   └── about.tsx         # /about route
├── entry.client.tsx      # Client entry point
└── entry.server.tsx      # Server entry point
react-router.config.ts    # Configuration file
```

## Route Configuration

In framework mode, routes are configured in `app/routes.ts`, not as component trees like in RRv6:

```tsx
// app/routes.ts
import { type RouteConfig, route, index, layout } from "@react-router/dev/routes";

export default [
  index("./home.tsx"),
  route("about", "./about.tsx"),
  route("products/:id", "./product.tsx"),

  // Nested routes
  layout("./dashboard/layout.tsx", [
    index("./dashboard/home.tsx"),
    route("settings", "./dashboard/settings.tsx"),
  ]),
] satisfies RouteConfig;
```

If a user asks about defining routes via components, I should explain that they're likely thinking of library mode, not framework mode.

### File System Routing Alternative

For users who prefer file system routing (similar to Remix or Next.js):

```tsx
// app/routes.ts
import { type RouteConfig } from "@react-router/dev/routes";
import { flatRoutes } from "@react-router/fs-routes";

export default flatRoutes() satisfies RouteConfig;
```

With flatRoutes, the file structure determines routing:

```
app/routes/
├── _index.tsx            # / (index route)
├── about.tsx             # /about
├── dashboard.tsx         # /dashboard
└── dashboard.$id.tsx     # /dashboard/:id (dynamic parameter)
```

## Route Modules

Route modules are the core building blocks in framework mode. These are files that export various functions and components:

```tsx
// A complete route module example
import type { Route } from "./+types/my-route";

// Server-side data loading
export async function loader({ params, request }: Route.LoaderArgs) {
  return { message: `Hello ${params.name}` };
}

// Client-side data loading
export async function clientLoader({ params, serverLoader }: Route.ClientLoaderArgs) {
  // Optional: get server data
  const serverData = await serverLoader();
  return { ...serverData, clientTime: Date.now() };
}

// Server-side data mutation
export async function action({ request }: Route.ActionArgs) {
  const formData = await request.formData();
  // Process form submission
  return { success: true };
}

// Client-side action
export async function clientAction({ request, serverAction }: Route.ClientActionArgs) {
  // Call server action if needed
  return await serverAction();
}

// Error UI
export function ErrorBoundary({ error }: Route.ErrorBoundaryProps) {
  return <div>Error: {error.message}</div>;
}

// Loading UI during hydration
export function HydrateFallback() {
  return <div>Loading...</div>;
}

// Main route component
export default function RouteComponent({
  loaderData, // Typed from loader/clientLoader return
  actionData, // Typed from action/clientAction return
  params, // Typed from route path
}: Route.ComponentProps) {
  return <div>{loaderData.message}</div>;
}
```

Users migrating from RRv6 or using React Router in library mode might try to define routes as components. I should guide them toward the route module pattern instead.

## Data Loading

### Server vs. Client Loading

Explain the differences between server and client loaders:

```tsx
// Server loader - runs ONLY on the server
export async function loader({ params }) {
  // Can use server-only APIs (databases, file system, etc.)
  return await database.getProduct(params.id);
}

// Client loader - runs ONLY in the browser
export async function clientLoader({ params }) {
  // Must use browser-compatible APIs
  return await fetch(`/api/products/${params.id}`).then((r) => r.json());
}
```

### When to Use Each Loader Type

Use cases for each loader type:

- **Server loaders**: For database access, authentication checks, server-side APIs
- **Client loaders**: For browser-only APIs, optimistic UI, real-time updates

### Combined Loading Pattern

For optimal user experience, I should recommend this pattern when appropriate:

```tsx
// Server-side data load
export async function loader({ params }) {
  return await database.getProduct(params.id);
}

// Additional client-side enhancements
export async function clientLoader({ serverLoader, params }) {
  // Get server data
  const serverData = await serverLoader();

  // Enhance with client-only data
  const userPreferences = JSON.parse(localStorage.getItem("preferences") || "{}");

  return {
    ...serverData,
    isFavorite: userPreferences.favorites?.includes(params.id),
  };
}

// For initial load hydration (run clientLoader during SSR hydration)
clientLoader.hydrate = true as const;

// Show during hydration
export function HydrateFallback() {
  return <ProductSkeleton />;
}
```

## Forms and Data Mutations

### Actions and Forms

For server-side data mutations:

```tsx
// Server-side action
export async function action({ request }) {
  const formData = await request.formData();
  const product = await database.createProduct({
    name: formData.get("name"),
    price: Number(formData.get("price")),
  });

  // Redirect after successful creation
  return redirect(`/products/${product.id}`);
}

// Usage in component
<Form method="post">
  <input name="name" />
  <input name="price" type="number" />
  <button type="submit">Create Product</button>
</Form>;
```

### Non-Navigating Forms with Fetchers

For forms that don't cause navigation:

```tsx
// In component
import { useFetcher } from "react-router";

function AddToCartButton({ productId }) {
  const fetcher = useFetcher();
  const isAdding = fetcher.state !== "idle";

  return (
    <fetcher.Form method="post" action="/cart">
      <input type="hidden" name="productId" value={productId} />
      <button disabled={isAdding}>{isAdding ? "Adding..." : "Add to Cart"}</button>
    </fetcher.Form>
  );
}
```

## Error Handling

### ErrorBoundary Component

Every route module can export an ErrorBoundary to handle errors:

```tsx
export function ErrorBoundary() {
  const error = useRouteError();

  if (isRouteErrorResponse(error)) {
    // For responses thrown from loaders/actions
    return (
      <div>
        <h1>
          {error.status} {error.statusText}
        </h1>
        <p>{error.data}</p>
      </div>
    );
  }

  // For other errors
  return (
    <div>
      <h1>Error</h1>
      <p>{error.message}</p>
      <p>The stack trace is:</p>
      <pre>{error.stack}</pre>
    </div>
  );
}
```

### Throwing vs. Returning Errors

Two ways to handle errors in loaders/actions:

```tsx
// Throwing errors (for critical errors that should show the ErrorBoundary)
export async function loader({ params }) {
  const product = await database.getProduct(params.id);

  if (!product) {
    // This will render the ErrorBoundary
    throw data("Product not found", { status: 404 });
  }

  return product;
}

// Returning errors (for validation errors shown in the UI)
export async function action({ request }) {
  const formData = await request.formData();
  const errors = validateForm(formData);

  if (Object.keys(errors).length > 0) {
    // This will return to the component via actionData
    return data({ errors }, { status: 400 });
  }

  // Process valid submission...
  return { success: true };
}
```

## Type Safety

React Router v7 generates types for route modules:

```tsx
// Import generated types for this specific route
import type { Route } from "./+types/product";

export async function loader({
  params, // Typed based on route pattern (:id -> string)
  request,
}: Route.LoaderArgs) {
  return {
    product: await database.getProduct(params.id),
    relatedIds: [1, 2, 3],
  };
}

export default function Product({
  // Typed from loader return value
  loaderData, // { product: Product, relatedIds: number[] }
  params, // { id: string }
}: Route.ComponentProps) {
  return <h1>{loaderData.product.name}</h1>;
}
```

### Type Setup

Users need to set up their TypeScript config for types to work correctly:

```json
// tsconfig.json
{
  "include": [".react-router/types/**/*"],
  "compilerOptions": {
    "rootDirs": [".", "./.react-router/types"]
  }
}
```

## Rendering Strategies

React Router v7 supports three rendering strategies:

1. **Server-Side Rendering (default)**:

```ts
// react-router.config.ts
export default {
  ssr: true, // Default
} satisfies Config;
```

2. **Client-Side Rendering (SPA mode)**:

```ts
// react-router.config.ts
export default {
  ssr: false,
} satisfies Config;
```

3. **Static Pre-rendering**:

```ts
// react-router.config.ts
export default {
  async prerender() {
    return ["/", "/about", "/products/featured"];
  },
} satisfies Config;
```

## Common User Questions and Problems

### "How do I access the loader data?"

```tsx
// Option 1: Component props (preferred, type-safe)
export default function Component({ loaderData }) {
  return <div>{loaderData.message}</div>;
}

// Option 2: useLoaderData hook (familiar to users from RRv6)
import { useLoaderData } from "react-router";

export default function Component() {
  const data = useLoaderData();
  return <div>{data.message}</div>;
}
```

### "How do I handle form validation?"

```tsx
export async function action({ request }) {
  const formData = await request.formData();
  const errors = {};

  if (!formData.get("email")) {
    errors.email = "Email is required";
  }

  if (Object.keys(errors).length > 0) {
    return data({ errors }, { status: 400 });
  }

  // Process valid submission...
  return { success: true };
}

export default function Component({ actionData }) {
  return (
    <Form method="post">
      <input name="email" type="email" />
      {actionData?.errors?.email && <div className="error">{actionData.errors.email}</div>}
      <button type="submit">Submit</button>
    </Form>
  );
}
```

### "How do I implement authentication?"

Basic authentication flow:

```tsx
// app/sessions.server.ts
import { createCookieSessionStorage } from "react-router";

export const { getSession, commitSession, destroySession } = createCookieSessionStorage({
  cookie: {
    name: "__session",
    secrets: ["s3cret1"],
    sameSite: "lax",
    path: "/",
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
  },
});

// app/auth.server.ts
export async function requireAuth(request) {
  const session = await getSession(request.headers.get("Cookie"));
  const userId = session.get("userId");

  if (!userId) {
    throw redirect("/login", {
      headers: {
        "Set-Cookie": await commitSession(session),
      },
    });
  }

  return userId;
}

// app/routes/protected.tsx
import { requireAuth } from "~/auth.server";

export async function loader({ request }) {
  const userId = await requireAuth(request);
  return { userId };
}
```

### "How do I implement loading states?"

```tsx
import { useNavigation } from "react-router";

function LoadingIndicator() {
  const navigation = useNavigation();
  const isLoading = navigation.state !== "idle";

  return isLoading ? <div className="spinner" /> : null;
}
```

## Common Integration Examples

### Root Layout Structure

```tsx
// app/root.tsx
import { Links, Meta, Outlet, Scripts, ScrollRestoration } from "react-router";

export function Layout({ children }) {
  return (
    <html lang="en">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <Meta />
        <Links />
      </head>
      <body>
        {children}
        <ScrollRestoration />
        <Scripts />
      </body>
    </html>
  );
}

export default function App() {
  return (
    <>
      <header>My App</header>
      <Outlet />
      <footer>© 2025</footer>
    </>
  );
}

export function ErrorBoundary() {
  const error = useRouteError();
  return (
    <div>
      <h1>App Error</h1>
      <p>{error.message || "Unknown error"}</p>
    </div>
  );
}
```

### CSS/Styling Integration

```tsx
// app/root.tsx - global styles
import "./global.css";

export function links() {
  return [
    { rel: "stylesheet", href: "/fonts.css" },
    { rel: "icon", href: "/favicon.png", type: "image/png" },
  ];
}

// Route-specific styles
// app/routes/products.$id.tsx
export function links() {
  return [{ rel: "stylesheet", href: "/products.css" }];
}
```

## Key Differences from React Router v6

1. **Framework vs Library**: RRv7 can be used as full framework with SSR, not just a client-side routing library
2. **Route Configuration**: Uses `routes.ts` configuration file vs JSX component tree definitions
3. **Route Modules**: File-based approach with data loading and actions vs component-based approach
4. **Type Safety**: Auto-generated types for loader/action data with TypeScript integration
5. **Component Props**: Components receive props directly instead of using hooks
6. **Data Flow**: Built-in data loading/mutation with automatic revalidation
7. **Rendering Strategies**: First-class support for CSR, SSR, and static pre-rendering
8. **Performance**: Built-in code splitting and optimized data loading

## Key Differences from Remix v2

1. **Package Names**: `@remix-run/*` becomes `react-router` or `@react-router/*`
2. **Configuration**: Uses `routes.ts` configuration rather than file-based routing by default
3. **Bundle Size**: Smaller, more focused on routing and data loading
4. **Client-Side Features**: `clientLoader` and `clientAction` are more prominent
5. **Vite Integration**: Uses Vite by default instead of esbuild

## Migration Guide Summary

When helping users migrate:

### From React Router v6

- Routes.tsx vs JSX component trees
- Route modules vs useLoaderData/useFetcher hooks
- Framework configuration vs BrowserRouter

### From Remix v2

- routes.ts vs file-based convention (can use flatRoutes adapter)
- route module exports remain similar but in a new package
- Update package imports from @remix-run/_ to react-router or @react-router/_

## Common Patterns

1. **Nested Layouts**: Use layout routes for UI nesting without URL changes
2. **Data Fetching**: Prefer server loaders for initial load, client loaders for subsequent updates
3. **Optimistic UI**: Update UI immediately before server confirms changes
4. **Error Handling**: Use ErrorBoundary for both rendering and data loading errors
5. **Protected Routes**: Use loader redirects for auth checks
6. **Form Handling**: Use `<Form>` and actions for data mutations instead of custom handlers
7. **Loading States**: Leverage `useNavigation()` and fetcher states for pending UI
8. **Type Safety**: Use auto-generated types from `./+types/routeName`
9. **Data Revalidation**: Automatic after actions, or manual with `useRevalidator()`
10. **Progressive Enhancement**: Forms work without JS enabled due to browser's native form behavior

## Gotchas and Important Notes

1. **Server vs Client Code**: Server loaders/actions never run in the browser, safe for DB access
2. **Component Props**: Route components receive props like `loaderData` and `actionData` instead of using hooks
3. **Route Order**: More specific routes should come before less specific ones
4. **Auto-Revalidation**: All loaders revalidate after an action completes by default
5. **URL-Based State**: Prefer URL parameters over React state for shareable/bookmarkable UI state
6. **`clientLoader.hydrate`**: Set to `true` to run client loaders during hydration (remember to provide HydrateFallback)
7. **Server Headers**: Set with `headers()` export, used for things like caching policies

## Debugging Tips

Common issues to watch for:

- Missing return values from loaders/actions
- Missing type imports for route modules
- Server-only code in client loaders/components
- Mixing library mode and framework mode concepts
- Incorrect package imports (react-router vs react-router-dom)
- Hydration mismatches when server and client render different content
- Missing HydrateFallback when using clientLoader.hydrate

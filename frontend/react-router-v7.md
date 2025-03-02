# React Router v7 Framework Guide for LLMs

This guide outlines the key concepts, patterns, and differences in React Router v7 when used as a framework (similar to Remix). Use this as reference when assisting users with RRv7 development.

> **Important:** React Router v7 can be used in two distinct ways:
>
> 1. As a traditional client-side routing library (similar to RRv6)
> 2. As a full-stack framework with server-side features (similar to Remix)
>
> This guide focuses primarily on the framework approach, which is the major new addition in v7.

## Core Concepts

React Router v7 introduces a framework approach (similar to Remix) alongside its traditional component-based routing. Key requirements:

- Node 20+
- React 18+
- React DOM 18+

## Installation & Setup

```bash
npx create-react-router@latest my-react-router-app
cd my-react-router-app
npm i
npm run dev
```

## Route Configuration

Routes are defined in `app/routes.ts` using a declarative API (this is a shift from the more component-based approach in RRv6):

```typescript
import { type RouteConfig, route, index, layout, prefix } from "@react-router/dev/routes";

export default [
  index("./home.tsx"), // Root index route
  route("about", "./about.tsx"), // Regular route

  layout("./auth/layout.tsx", [
    // Layout route with children
    route("login", "./auth/login.tsx"),
    route("register", "./auth/register.tsx"),
  ]),

  ...prefix("concerts", [
    // Route prefix
    index("./concerts/home.tsx"), // /concerts
    route(":city", "./concerts/city.tsx"), // /concerts/:city
  ]),
] satisfies RouteConfig;
```

### Route Types

1. **Regular routes**: `route("path", "./component.tsx")` - standard routes with path segments
2. **Index routes**: `index("./component.tsx")` - default child for parent, renders at parent's path
3. **Layout routes**: `layout("./component.tsx", [...children])` - nesting without URL segments (UI organization)
4. **Prefix routes**: `prefix("path", [...routes])` - add path prefix to a group of routes

### File System Routes

You can also use file-based routing conventions with the `@react-router/fs-routes` package:

```typescript
import { flatRoutes } from "@react-router/fs-routes";

export default [
  // Manual routes
  route("/", "./home.tsx"),

  // File system routes
  ...(await flatRoutes()),
] satisfies RouteConfig;
```

This allows for a Remix or Next.js-like file-based routing experience.

### Dynamic Segments

- Basic param: `route("users/:userId", "./user.tsx")`
- Optional segments: `route(":lang?/categories", "./categories.tsx")`
- Splat/catchall: `route("files/*", "./files.tsx")`

## Route Modules

Route modules are individual files that define route behavior (similar to Remix route modules). This is significantly different from RRv6's component-based approach. Each module can export:

```typescript
// app/users.$userId.tsx
import type { Route } from "./+types/users.$userId";

// Component (required default export)
export default function User({ loaderData, params }: Route.ComponentProps) {
  return <h1>User: {loaderData.name}</h1>;
}

// Data loading (server-side)
export async function loader({ params }: Route.LoaderArgs) {
  const user = await fetchUser(params.userId);
  return { name: user.name };
}

// Client-side data loading
export async function clientLoader({ params, serverLoader }: Route.ClientLoaderArgs) {
  // Can call serverLoader() to reuse server data
  const data = await fetch(`/api/users/${params.userId}`);
  return await data.json();
}
clientLoader.hydrate = true as const; // Optional: run during hydration

// Data mutations (server-side)
export async function action({ request }: Route.ActionArgs) {
  const formData = await request.formData();
  const user = await updateUser(formData);
  return { success: true, user };
}

// Client-side data mutations
export async function clientAction({ request, serverAction }: Route.ClientActionArgs) {
  // Can call serverAction() if needed
  const formData = await request.formData();
  // Client-side processing
  return { success: true };
}

// Error handling
export function ErrorBoundary() {
  const error = useRouteError();
  return <div>Error: {error.message}</div>;
}

// Loading fallback (for client data loading)
export function HydrateFallback() {
  return <div>Loading...</div>;
}

// HTTP headers
export function headers() {
  return {
    "Cache-Control": "max-age=300, s-maxage=3600",
  };
}

// Meta tags for document head
export function meta() {
  return [{ title: "User Profile" }, { name: "description", content: "User profile page" }];
}

// Link tags for document head
export function links() {
  return [{ rel: "stylesheet", href: "/styles/user.css" }];
}

// Custom data for useMatches()
export const handle = {
  breadcrumb: (data) => <Link to={`/users/${data.id}`}>{data.name}</Link>,
};

// Control when loaders revalidate
export function shouldRevalidate(args) {
  return true;
}
```

## Data Flow & Type Safety

Route modules automatically generate TypeScript types for your data and parameters. Import them like this:

```typescript
import type { Route } from "./+types/routeName";

// Now you can use:
// Route.LoaderArgs, Route.ActionArgs, Route.ComponentProps, etc.
```

These types are automatically generated based on your route path patterns and the data returned from loaders.

## Data Loading & Mutations

### Data Loading Options

1. **Server loaders** (`loader`):

   - Run on the server during SSR and for client navigations
   - Server-only code is safe here (file system, DB access)
   - Automatically serialized for client consumption

2. **Client loaders** (`clientLoader`):

   - Run only in the browser
   - Can access browser APIs
   - Can call `serverLoader()` to merge with server data

3. **Using both together**:

   ```typescript
   export async function loader({ params }) {
     return getServerData(params.id);
   }

   export async function clientLoader({ serverLoader, params }) {
     const serverData = await serverLoader();
     const clientData = getClientData();
     return { ...serverData, ...clientData };
   }
   ```

### Data Mutations

1. **Server actions** (`action`):

   - Run on server when forms are submitted
   - Automatically revalidate loader data

2. **Client actions** (`clientAction`):

   - Run in browser only
   - Can call `serverAction()` if needed

3. **Calling actions**:
   - Declarative: `<Form method="post">`
   - Imperative: `useSubmit()`
   - Without navigation: `useFetcher()`

## Components Props vs Hooks

In RRv7 framework mode, components receive props directly instead of using hooks:

```typescript
// React Router v6 style with hooks
function Component() {
  const data = useLoaderData();
  const params = useParams();
  // ...
}

// React Router v7 framework style with props
function Component({ loaderData, params }: Route.ComponentProps) {
  // loaderData is typed according to your loader's return type
  // ...
}
```

This enables better type inference and reduces the need for type assertions.

## Rendering Strategies

React Router v7 supports three rendering strategies:

1. **Client-Side Rendering (CSR)**

   ```typescript
   // react-router.config.ts
   export default {
     ssr: false,
   } satisfies Config;
   ```

2. **Server-Side Rendering (SSR)**

   ```typescript
   export default {
     ssr: true,
   } satisfies Config;
   ```

3. **Static Pre-rendering**
   ```typescript
   export default {
     async prerender() {
       return ["/", "/about", "/contact"];
     },
   } satisfies Config;
   ```

## Navigation

1. **Standard links**: `<Link to="/about">About</Link>`
2. **Active state links**: `<NavLink to="/dashboard">Dashboard</NavLink>`
3. **Forms**:
   ```jsx
   <Form method="post" action="/tasks/new">
     <input name="title" />
     <button type="submit">Add Task</button>
   </Form>
   ```
4. **Redirect from loaders/actions**: `return redirect("/login");`
5. **Programmatic navigation**: `useNavigate()` hook

## Pending UI States

```jsx
// Global navigation indicator
function Layout() {
  const navigation = useNavigation();
  const isNavigating = Boolean(navigation.location);

  return (
    <div>
      {isNavigating && <Spinner />}
      <Outlet />
    </div>
  );
}

// Local form submission state
function TaskForm() {
  const fetcher = useFetcher();
  const busy = fetcher.state !== "idle";

  return (
    <fetcher.Form method="post">
      <input name="title" />
      <button type="submit">{busy ? "Saving..." : "Save"}</button>
    </fetcher.Form>
  );
}
```

## Testing

Use `createRoutesStub` to test components that use React Router hooks:

```jsx
import { createRoutesStub } from "react-router";
import { render, screen } from "@testing-library/react";

test("component test", () => {
  const Stub = createRoutesStub([
    {
      path: "/test",
      Component: MyComponent,
      loader: () => ({ message: "Hello" }),
    },
  ]);

  render(<Stub initialEntries={["/test"]} />);
  // Test assertions...
});
```

## Key Differences from React Router v6

1. **Framework vs Library**: RRv7 can be used as full framework with SSR, not just a client-side routing library
2. **Route Modules**: File-based routing with data loading and actions (vs component-based approach)
3. **Type Safety**: Auto-generated types for loader/action data with TypeScript integration
4. **Rendering Strategies**: Support for CSR, SSR, and static pre-rendering
5. **Data Flow**: Built-in data loading/mutation with automatic revalidation (similar to Remix)
6. **File Structure**: More opinionated project structure with `app/` directory
7. **Performance**: Built-in code splitting and optimized data loading
8. **Server Integration**: First-class server concepts like headers, redirects, and HTTP status codes

## Key Differences from Remix v2

1. **Bundle Size**: Smaller, more focused on routing and data loading
2. **Vite Integration**: Uses Vite by default instead of esbuild
3. **Client-Side Capabilities**: `clientLoader` and `clientAction` are more prominent
4. **Configuration**: Uses `routes.ts` configuration file vs file-based routing (though file-based routing is available via plugin)

## Custom Framework Integration

For advanced users wanting to integrate React Router's framework features into custom bundlers:

```jsx
// Client
import { createBrowserRouter, RouterProvider } from "react-router";

const router = createBrowserRouter([
  {
    path: "/",
    Component: Root,
    children: [
      {
        path: "products/:id",
        Component: Product,
        loader: ({ params }) => fetchProduct(params.id),
        action: ({ request }) => updateProduct(request),
      },
    ],
  },
]);

// Server
import { createStaticHandler, createStaticRouter, StaticRouterProvider } from "react-router";

const { query, dataRoutes } = createStaticHandler(routes);

export async function handler(request) {
  const context = await query(request);
  const router = createStaticRouter(dataRoutes, context);

  return renderToString(<StaticRouterProvider router={router} context={context} />);
}
```

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

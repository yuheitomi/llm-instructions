## Code Style and Structure

- Write concise, technical TypeScript code with accurate examples.
- Use functional and declarative programming patterns; avoid classes.
- Prefer iteration and modularization over code duplication.
- Use descriptive variable names with auxiliary verbs (e.g., isLoading, hasError).
- Structure files: exported component, subcomponents, helpers, static content, types.

## Naming Conventions

- Use `kebab-case` for directories and component files (e.g., components/auth-wizard).
- Favor named exports for components.

## TypeScript Usage

- Use TypeScript for all code; prefer interfaces over types.
- Avoid enums; use maps instead.
- Use functional components with TypeScript interfaces.

## Syntax and Formatting

- Use the "function" keyword for pure functions.
- Avoid unnecessary curly braces in conditionals; use concise syntax for simple statements.
- Use declarative JSX.

## Performance Optimization

- Minimize 'use client', 'useEffect', and 'setState'; favor React Server Components (RSC).
- Wrap client components in Suspense with fallback.
- Use dynamic loading for non-critical components.
- Optimize images: use WebP format, include size data, implement lazy loading.

## Important changes in Next.js 15

- In RSC, `params` and `searchParams` are passed as promises.

Follow Next.js docs for Data Fetching, Rendering, and Routing.

## Project structures

- Use `/app` for routing and user facing components as part of Next.js default structure.
- Use `/components` for general-purpose, resusable components. Route specific components should co-locate with the related route folder.
- Use `/lib` for non-UI-related source codes.

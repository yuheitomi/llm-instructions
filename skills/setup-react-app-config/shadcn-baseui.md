# Set up Shadcn/UI with Base UI

## Setup Steps

### 1. Initialize Shadcn/UI

Run the default init command to create basic configuration files:

```bash
pnpx shadcn@latest init
```

Select your preferred options when prompted (style, color, CSS variables, etc.).

### 2. Install Base UI

Install the Base UI package. Ensure to use `@base-ui/react`. It's NOT `@base-ui-components/react`.

```bash
pnpm add @base-ui/react
```

### 3. Remove Radix UI Dependencies

After initialization, remove any Radix UI packages that were installed:

```bash
pnpm remove @radix-ui/react-*
```

Or selectively remove only the primitives you'll replace with Base UI equivalents.

### 4. Update components.json

Modify `components.json` to reflect the Base UI approach:

```json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "base-{vega|nova|maia|lyra|mira}",
  // ...
  "iconLibrary": "lucide"
}
```

Ask the user which style to pick from the available Base UI styles.

## Notes

- Not all Radix primitives have direct Base UI equivalents - check Base UI documentation for available components
- Base UI components may have slightly different APIs; adjust component implementations accordingly
- Refer to [Base UI documentation](https://base-ui.com/) for component usage details

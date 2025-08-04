# Drizzle + Turso Setup Instructions

## 1. Install Dependencies

```bash
npm i drizzle-orm @libsql/client dotenv
npm i -D drizzle-kit tsx
```

## 2. Environment Variables (.env)

```env
# For remote Turso database
TURSO_DATABASE_URL=libsql://your-db-name.turso.io
TURSO_AUTH_TOKEN=your-auth-token

# For local database (optional - can use same connection)
LOCAL_DB_PATH=file:./local.db
```

## 3. Database Connection (src/db/index.ts)

```typescript
import "dotenv/config";
import { drizzle } from "drizzle-orm/libsql";

// Dynamic connection based on environment
const isDev = process.env.NODE_ENV === "development";

export const db = drizzle({
  connection: {
    url: isDev ? process.env.LOCAL_DB_PATH || "file:./local.db" : process.env.TURSO_DATABASE_URL!,
    authToken: isDev ? undefined : process.env.TURSO_AUTH_TOKEN!,
  },
});
```

## 4. Schema Definition (src/db/schema.ts)

```typescript
import { int, sqliteTable, text } from "drizzle-orm/sqlite-core";

export const usersTable = sqliteTable("users", {
  id: int().primaryKey({ autoIncrement: true }),
  name: text().notNull(),
  age: int().notNull(),
  email: text().notNull().unique(),
});
```

## 5. Drizzle Config (drizzle.config.ts)

```typescript
import "dotenv/config";
import { defineConfig } from "drizzle-kit";

const isDev = process.env.NODE_ENV === "development";

export default defineConfig({
  out: "./drizzle",
  schema: "./src/db/schema.ts",
  dialect: "turso",
  dbCredentials: {
    url: isDev ? process.env.LOCAL_DB_PATH || "file:./local.db" : process.env.TURSO_DATABASE_URL!,
    authToken: isDev ? undefined : process.env.TURSO_AUTH_TOKEN!,
  },
});
```

## 6. Database Operations

```bash
# Generate migrations
npx drizzle-kit generate

# Apply migrations (works with both local and remote)
npx drizzle-kit migrate

# Push schema directly (development)
npx drizzle-kit push
```

## 7. Usage Example

```typescript
import { db } from "./db";
import { usersTable } from "./db/schema";

// Works with both local.db and remote Turso
const users = await db.select().from(usersTable);
```

## Key Notes

- **LibSQL handles local files**: Use `file:./local.db` as URL for local database
- **No auth token needed** for local databases
- **Same API**: Identical code works for both local and remote
- **Environment-based switching**: Use `NODE_ENV` or custom env var to toggle
- **Turso setup**: Run `turso db create` and `turso db tokens create` for remote database

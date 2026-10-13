import { defineConfig } from "drizzle-kit";

export default defineConfig({
    dialect: "postgresql",
    dbCredentials: {
        url: "postgresql://postgres:password@localhost:5433/postgres"
    }
})

# Pedis Architecture

Pedis is designed to bring Redis inspired caching and data structures directly into PostgreSQL. Instead of relying on a separate caching server Pedis uses PostgreSQL's native capabilities, including UNLOGGED tables, SQL functions and JSON operations, to handle caching and data manipulation within the database.

Currently Pedis consists of SQL files that implement core data structures such as key-value stores, hashes, lists, sets and sorted sets. These functions provide the foundation for the project and can be executed directly inside a PostgreSQL database.

The long term goal is to build a complete caching engine around this SQL foundation. A TypeScript based engine will provide a convenient interface for applications to interact with PostgreSQL followed by SDKs for other programming languages. These components will communicate with the database functions rather than reimplementing the underlying data structures.

Pedis also aims to explore additional data types including vectors and spatial data taking advantage of PostgreSQL's broader capabilities.

The project is still evolving, and its architecture will grow alongside the implementation. The focus is to create a lightweight, PostgreSQL native caching solution that provides familiar Redis-like operations without requiring a separate Redis instance.

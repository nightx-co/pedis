# Pedis

**Redis-inspired caching, powered entirely by PostgreSQL.**

Pedis is an open-source project aiming to bring Redis like caching, data structures, and operations directly into PostgreSQL. By leveraging PostgreSQL's native capabilities, including UNLOGGED tables, SQL functions, and JSON manipulation, Pedis aims to make PostgreSQL the central host for both application data and caching.

The vision is simple: **Redis like operations, without requiring a separate Redis server.**

## Vision

Modern applications often rely on PostgreSQL for persistent data and Redis for caching, in memory data structures, counters and other fast access operations. While this combination works well, it also introduces another service to deploy, configure, monitor and maintain.

Pedis explores a different approach: bringing Redis inspired caching capabilities directly into PostgreSQL.

Instead of building an entirely separate caching server Pedis uses PostgreSQL's native database features to implement familiar data structures and operations. The long-term goal is to provide a cohesive caching engine that applications can use simply by connecting to a PostgreSQL database.

Pedis is not intended to reproduce every aspect of Redis. Its focus is on making Redis inspired operations and data structures available natively within PostgreSQL.

## Core Principles

* **PostgreSQL First** — Keep caching logic, data structures, and execution close to the database.
* **Redis-Inspired API** — Provide familiar commands and operations for common caching workloads.
* **Lightweight Storage** — Use PostgreSQL UNLOGGED tables where appropriate for disposable cache data.
* **Native Execution** — Implement data manipulation through SQL functions and PostgreSQL's built in capabilities.
* **Open Source** — Build an openly available project under the Apache License 2.0.
* **Extensible Architecture** — Create a foundation for additional data structures, client libraries and language-specific SDKs.

## Data Structures

Pedis aims to support the core data structures commonly associated with Redis implemented using PostgreSQL native storage and functions.

| Data structure | Intended capabilities                  |
| -------------- | -------------------------------------- |
| Key-value      | Set, get, update, ttl and delete values    |
| Hashes         | Store and manipulate field-value pairs |
| Lists          | Manage ordered collections of values   |
| Sets           | Maintain collections of unique values  |
| Sorted sets    | Organize values by score and ordering  |
| Counters       | Increment and decrement numeric values |

These structures are part of the project's broader direction. Their availability and supported operations will depend on the current implementation.

## Beyond Traditional Caching

Pedis also aims to explore data types that extend beyond conventional Redis style caching.

Potential future additions include:

* **Vectors** — Support vector oriented storage and operations for applications working with embeddings and similarity search.
* **Spatial Data** — Explore caching and manipulation of geographic and spatial values.
* **Additional Data Structures** — Expand the available types and operations as the project evolves.

By building on PostgreSQL, Pedis can explore data structures that benefit from the database's broader ecosystem rather than being limited to traditional key-value caching.

## How It Works

Pedis takes a database-native approach to caching.

The foundation consists of SQL scripts that define tables and database functions. These functions implement operations over stored values and use PostgreSQL's native capabilities to manipulate data structures including JSON-based representations where appropriate.

UNLOGGED tables are particularly relevant because they avoid ordinary write-ahead logging for table data making them useful for cache contents that do not need crash durability.

The intended architecture has three main layers:

1. **Storage Layer** — PostgreSQL tables hold cached data and the internal representations of supported data structures.
2. **Function Layer** — SQL functions implement the operations that create, retrieve, update and manipulate cached values.
3. **Client and Engine Layer** — Planned client libraries and an engine will provide a more convenient interface for applications to execute these operations through PostgreSQL.

The long term goal is to bring these pieces together into a cohesive caching system that can be used from application code without requiring a separate Redis deployment.

## Roadmap

Pedis is being developed toward a complete PostgreSQL native caching engine.

Planned areas of development include:

* Expanding support for Redis inspired data structures and operations.
* Establishing consistent command semantics across supported data types.
* Developing a TypeScript-based engine and client interface.
* Exploring SDKs for additional programming languages.
* Improving command execution, error handling, and developer experience.
* Investigating vector, spatial and other advanced data types.
* Building toward a practical caching solution for applications already using PostgreSQL.

The roadmap will evolve as the underlying implementation develops.

## Project Structure

The current repository primarily contains SQL files defining the database side foundation of Pedis.

These files form the starting point for implementing the data structures and operations that will eventually be exposed through a more complete engine and client interface.

As development progresses the repository is expected to grow to include application-side code, client libraries, documentation and supporting tooling.

## Design Philosophy

Pedis is built around one central idea:

**Your database should be able to do more than persist data. It can also host your caching layer.**

By keeping caching operations inside PostgreSQL, Pedis aims to simplify infrastructure and reduce the need for a separate caching service in suitable workloads and provide developers with a familiar way to work with Redis inspired data structures.

Pedis is not a drop in replacement for Redis today and full Redis compatibility is not implied. Its long-term ambition is to become a practical alternative for applications that want Redis like caching capabilities while keeping their infrastructure centered on PostgreSQL.

## License

Pedis is open-source software licensed under the [Apache License 2.0](LICENSE).

## Contributing

Contributions, ideas, discussions and feedback are welcome as Pedis evolves toward its goal of making PostgreSQL a capable host for Redis-inspired caching.

If you're interested in database-native caching, PostgreSQL internals or alternative approaches to application infrastructure, you're welcome to follow the project and contribute to its development.

---

**Pedis — Redis-inspired caching, native to PostgreSQL.**

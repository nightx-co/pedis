### Throughput Performance Benchmark Summary

| Command / Operation | Throughput (TPS) | Execution Time (10,000 ops) | Analysis & Bottleneck Factor |
| --- | --- | --- | --- |
| **`HSET`** | **~37,127 TPS** | 0.2693s | **Write Overhead:** Involves state mutation and structure updates, resulting in lower throughput compared to read operations due to index and write handling costs. |
| **`HGET`** | **~68,442 TPS** | 0.1461s | **Fast Single-Field Access:** Efficiently targets and retrieves specific values from cached database records with minimal overhead. |
| **`HGETALL`** | **~74,614 TPS** | 0.1340s | **High Read Efficiency:** Bulk-fetches entire structured hash entries, benefiting heavily from fast memory-cached execution paths in PostgreSQL. |
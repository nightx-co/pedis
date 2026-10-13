### Throughput Performance Benchmark Summary

| Command / Operation | Throughput (TPS) | Execution Time (10,000 ops) | Analysis & Bottleneck Factor |
| --- | --- | --- | --- |
| **`SADD`** | **~98 TPS** | 101.5786s | **Heavy Write Mutation:** Involves uniqueness checks, index management, and state insertion, resulting in high overhead and low write throughput. |
| **`SCARD`** | **~759 TPS** | 13.1804s | **Metadata Retrieval:** Efficiently queries set cardinality without fetching full collection elements, providing fast read performance. |
| **`SISMEMBER`** | **~687 TPS** | 14.5665s | **Membership Lookup:** Performs targeted membership verification against set elements with minimal structural overhead. |
| **`SMEMBERS`** | **~768 TPS** | 1.3021s (1k iter) | **Bulk Member Fetch:** Retrieves member items (tested on 1,000 iterations), benefiting from fast cached execution paths. |
| **`SREM`** | **~59 TPS** | 170.3385s | **Deletion Overhead:** Involves searching, unlinking, and mutating set state during item removal, resulting in the highest execution time and lowest throughput. |
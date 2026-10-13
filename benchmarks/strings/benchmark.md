### Throughput Performance Benchmark Summary

| Command / Operation | Throughput (TPS) | Execution Time (10,000 ops) | Analysis & Bottleneck Factor |
| --- | --- | --- | --- |
| **`GET`** | **~84,839 TPS** | 0.1179s | **Blazingly Fast:** Reads exclusively from memory cached via PostgreSQL buffers, hitting minimal overhead. |
| **`SETNX`** | **~64,519 TPS** | 0.1550s | **High Efficiency:** Tests non-existent/new keys distributed across a range, bypassing heavy lock contention. |
| **`SET`** | **~47,800 TPS** | 0.2092s | **Strong Write Speed:** Involves disk/WAL logging interaction, though heavily buffered in RAM. |
| **`INCR`** | **~11,458 TPS** | 0.8727s | **The Contention Wall:** Heavily penalized because hammering a single hot counter key forces strict row-level serialization. |

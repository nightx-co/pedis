### Throughput Performance Benchmark Summary

| Command / Operation | Throughput (TPS) | Execution Time (10,000 ops) | Analysis & Bottleneck Factor |
| --- | --- | --- | --- |
| **`LPUSH`** | **~811 TPS** | 12.3235s | **Write Head Insertion:** Involves state mutation and structure updates at the head of the list, resulting in moderate overhead during 10,000 iterations. |
| **`LLEN`** | **~2,137 TPS** | 4.6795s | **Fast Metadata Access:** Efficiently queries the list length without scanning individual elements, yielding the highest read performance. |
| **`LRANGE`** | **~1,853 TPS** | 5.3975s | **Range Retrieval Efficiency:** Fetches a targeted slice of elements with minimal overhead compared to heavy write mutations. |
| **`L/RPOP`** | **~621 TPS** | 16.1129s | **Pop Mutation Overhead:** Involves item removal and structural updates at either end of the list, resulting in the highest execution time and lowest throughput. |
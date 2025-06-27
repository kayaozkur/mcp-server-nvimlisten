# Performance Optimization Rules

## Tool Call Batching and Parallelization

### Mandatory Batching Rules

**Rule PO-1: Always Batch Independent Operations**
```python
# ALWAYS DO THIS - Batch independent operations
parallel_calls = [
    read_file("src/main.py"),
    read_file("src/utils.py"),
    read_file("tests/test_main.py")
]

# NEVER DO THIS - Sequential calls for independent operations
read_file("src/main.py")
read_file("src/utils.py")  # Should be batched with above
read_file("tests/test_main.py")  # Should be batched with above
```

**Rule PO-2: Intelligent Operation Grouping**
- **Read Operations**: Always batch file reads when multiple files needed
- **Search Operations**: Batch Grep/Glob calls when searching multiple patterns
- **Git Operations**: Batch git status, git diff, git log when creating commits/PRs
- **Validation Operations**: Batch all pre-commit checks together

### Batching Decision Matrix

**Rule PO-3: Batch Size Optimization**
```
Operation Type | Max Batch Size | Timeout Multiplier | Priority
File Reads     | 8-12 files     | 1.5x              | High
Searches       | 5-8 patterns   | 2.0x              | Medium
Git Commands   | 4-6 commands   | 1.2x              | High
Edits          | 3-5 files      | 1.0x              | Critical
```

**Rule PO-4: Smart Batching Strategies**
- Batch operations with similar resource requirements
- Group operations that benefit from shared context
- Separate high-priority operations from background tasks
- Balance batch size with timeout constraints

## Lazy Loading and Progressive Disclosure

### Lazy Loading Decision Tree

```
Is information immediately needed? YES → Load now
                                 NO → Continue evaluation

Is information likely needed (>70%)? YES → Preload in background
                                      NO → Continue evaluation

Is information expensive to load? YES → Defer until explicitly needed
                                 NO → Load now for better UX
```

**Rule LL-1: Progressive File Loading**
- Load file headers/imports first for structure understanding
- Load function signatures before implementations
- Load public interfaces before private implementations
- Use line limits for initial loads, expand on demand

**Rule LL-2: Context-Aware Lazy Loading**
```python
def smart_file_loading(file_path, context):
    if context.task_type == "debugging":
        # Load more context for debugging
        return read_file(file_path, limit=500)
    elif context.task_type == "quick_fix":
        # Load less for quick changes
        return read_file(file_path, limit=100)
    else:
        # Standard loading
        return read_file(file_path, limit=200)
```

## Cache Utilization Strategies

### Multi-Level Caching Architecture

**Rule CU-1: Cache Hierarchy**
1. **Hot Cache**: Frequently accessed files and data (in-memory)
2. **Warm Cache**: Recently accessed project context (session-based)
3. **Cold Cache**: Historical patterns and solutions (persistent)
4. **Shared Cache**: Cross-project patterns and templates

**Rule CU-2: Cache Invalidation Rules**
```python
def should_invalidate_cache(file_path, cached_timestamp):
    file_modified = get_file_modification_time(file_path)
    
    # Invalidate if file changed
    if file_modified > cached_timestamp:
        return True
    
    # Invalidate if dependencies changed
    if any_dependency_changed(file_path, cached_timestamp):
        return True
    
    # Invalidate if cache is stale (configurable threshold)
    cache_age = current_time() - cached_timestamp
    if cache_age > get_cache_ttl(file_path):
        return True
    
    return False
```

**Rule CU-3: Intelligent Caching Policies**
- Cache expensive operations (large file reads, complex searches)
- Cache frequently accessed project metadata
- Cache compiled patterns and regular expressions
- Cache dependency graphs and relationship maps

### Cache Optimization Strategies

**Rule CO-1: Predictive Caching**
- Pre-cache files likely to be needed based on current task
- Cache related files when one file in a module is accessed
- Use historical patterns to predict cache needs
- Pre-populate cache during idle periods

**Rule CO-2: Cache Compression and Storage**
- Compress large cached files to reduce memory usage
- Use differential caching for frequently modified files
- Implement cache partitioning for different data types
- Use memory-mapped files for large cached datasets

## Parallel Processing Identification

### Parallelizable Operation Detection

**Rule PP-1: Operation Independence Analysis**
```python
def can_parallelize(operations):
    dependency_graph = build_dependency_graph(operations)
    
    # Operations are parallelizable if:
    # 1. No shared resource conflicts
    # 2. No sequential dependencies
    # 3. Similar resource requirements
    # 4. No order-dependent side effects
    
    return analyze_parallelizability(dependency_graph)
```

**Rule PP-2: Common Parallelizable Patterns**
- **File System Operations**: Reading multiple independent files
- **Search Operations**: Multiple pattern searches across different directories
- **Validation Operations**: Running multiple independent checks
- **Data Processing**: Processing independent data chunks
- **Network Operations**: Multiple independent API calls

### Parallel Execution Optimization

**Rule PE-1: Resource-Aware Parallelization**
```python
def optimize_parallel_execution(operations):
    # Group by resource type
    cpu_intensive = filter_cpu_operations(operations)
    io_intensive = filter_io_operations(operations)
    network_operations = filter_network_operations(operations)
    
    # Optimize concurrency for each type
    cpu_pool_size = min(len(cpu_intensive), cpu_count())
    io_pool_size = min(len(io_intensive), io_optimal_concurrency())
    network_pool_size = min(len(network_operations), network_optimal_concurrency())
    
    return execute_with_optimized_pools(operations, pool_sizes)
```

**Rule PE-2: Failure Isolation in Parallel Operations**
- Implement circuit breakers for failing operations
- Use timeouts appropriate for each operation type
- Provide partial results when some parallel operations fail
- Implement retry logic for transient failures

## Resource Management and Monitoring

### Resource Usage Monitoring

**Rule RM-1: Performance Metrics Collection**
```python
class PerformanceMetrics:
    def __init__(self):
        self.tool_call_latencies = {}
        self.cache_hit_rates = {}
        self.parallel_efficiency = {}
        self.resource_utilization = {}
    
    def record_operation(self, operation_type, latency, resources_used):
        self.tool_call_latencies[operation_type].append(latency)
        self.resource_utilization[operation_type].append(resources_used)
        
    def get_optimization_recommendations(self):
        return analyze_metrics_for_optimization_opportunities(self)
```

**Rule RM-2: Adaptive Resource Allocation**
- Monitor tool execution times and adjust timeouts dynamically
- Track memory usage patterns and optimize cache sizes
- Adapt parallel execution parameters based on system performance
- Implement load balancing for resource-intensive operations

### Performance Bottleneck Detection

**Rule BD-1: Automated Bottleneck Identification**
```python
def identify_performance_bottlenecks():
    bottlenecks = []
    
    # Check tool call performance
    slow_operations = find_operations_above_threshold(latency_threshold=5.0)
    bottlenecks.extend(categorize_slow_operations(slow_operations))
    
    # Check resource utilization
    resource_bottlenecks = find_resource_constraints()
    bottlenecks.extend(resource_bottlenecks)
    
    # Check cache efficiency
    cache_misses = find_high_cache_miss_operations()
    bottlenecks.extend(cache_misses)
    
    return prioritize_bottlenecks(bottlenecks)
```

**Rule BD-2: Proactive Performance Optimization**
- Continuously monitor operation performance trends
- Implement automatic performance regression detection
- Suggest optimizations based on usage patterns
- Perform background optimization during idle periods

## Advanced Optimization Techniques

### Intelligent Prefetching

**Rule IP-1: Context-Based Prefetching**
- Prefetch likely-needed files based on current task context
- Pre-load related documentation when working on specific features
- Anticipate user needs based on historical patterns
- Use idle time for speculative loading

**Rule IP-2: Dependency-Aware Prefetching**
```python
def intelligent_prefetch(current_files):
    dependency_graph = build_project_dependency_graph()
    likely_needed = predict_related_files(current_files, dependency_graph)
    
    # Prefetch in priority order
    for file_path in sorted(likely_needed, key=lambda f: f.priority, reverse=True):
        if prefetch_budget_available():
            background_load(file_path)
        else:
            break
```

### Operation Fusion and Optimization

**Rule OF-1: Operation Combining**
- Combine multiple small edits into single MultiEdit operations
- Merge related search operations into single complex queries
- Consolidate validation steps into comprehensive checks
- Batch related git operations for atomic execution

**Rule OF-2: Query Optimization**
```python
def optimize_search_query(patterns, file_filters):
    # Combine similar patterns
    merged_patterns = merge_compatible_patterns(patterns)
    
    # Optimize file filters
    optimized_filters = consolidate_file_filters(file_filters)
    
    # Use most efficient search strategy
    strategy = select_optimal_search_strategy(merged_patterns, optimized_filters)
    
    return execute_optimized_search(strategy)
```

## Performance Budgets and Limits

### Operation Budget Management

**Rule BM-1: Performance Budget Allocation**
```python
PERFORMANCE_BUDGETS = {
    'file_operations': {
        'max_concurrent': 8,
        'timeout_per_operation': 10.0,
        'total_budget_per_minute': 60.0
    },
    'search_operations': {
        'max_concurrent': 4,
        'timeout_per_operation': 15.0,
        'total_budget_per_minute': 45.0
    },
    'git_operations': {
        'max_concurrent': 2,
        'timeout_per_operation': 30.0,
        'total_budget_per_minute': 90.0
    }
}
```

**Rule BM-2: Budget Enforcement and Adaptation**
- Track resource consumption against budgets
- Implement graceful degradation when budgets exceeded
- Adapt budgets based on system performance and user needs
- Provide feedback when operations are budget-constrained

### Efficiency Metrics and Optimization

**Rule EM-1: Continuous Efficiency Monitoring**
```python
def calculate_efficiency_metrics():
    return {
        'operations_per_second': completed_operations / elapsed_time,
        'cache_hit_rate': cache_hits / total_cache_requests,
        'parallel_efficiency': actual_speedup / theoretical_speedup,
        'resource_utilization': used_resources / available_resources,
        'user_satisfaction': positive_outcomes / total_outcomes
    }
```

**Rule EM-2: Performance Optimization Feedback Loop**
- Continuously measure and analyze performance metrics
- Identify optimization opportunities automatically
- Implement A/B testing for performance improvements
- Learn from performance patterns to improve future operations

## Emergency Performance Protocols

### Performance Crisis Management

**Rule PC-1: Performance Degradation Response**
```python
def handle_performance_degradation(severity_level):
    if severity_level == 'critical':
        # Emergency mode: disable non-essential features
        disable_background_operations()
        increase_cache_aggressiveness()
        reduce_parallel_operation_limits()
        
    elif severity_level == 'warning':
        # Optimization mode: improve efficiency
        optimize_cache_policies()
        increase_batching_thresholds()
        defer_non_urgent_operations()
```

**Rule PC-2: Graceful Performance Recovery**
- Implement circuit breakers for consistently slow operations
- Provide alternative execution paths for performance-critical operations
- Maintain minimum viable performance levels
- Gradually restore full functionality as performance improves

These performance optimization rules ensure that Claude Code operates with maximum efficiency, making intelligent decisions about resource usage, operation batching, and system optimization to provide the best possible user experience.
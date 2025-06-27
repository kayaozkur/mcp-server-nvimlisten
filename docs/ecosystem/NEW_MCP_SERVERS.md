# New MCP Servers Documentation

This document provides comprehensive documentation for the 7 new MCP servers that expand the capabilities of the MCP ecosystem.

## Table of Contents

1. [server-time](#server-time)
2. [server-fetch](#server-fetch)
3. [server-memory](#server-memory)
4. [server-sequentialthinking](#server-sequentialthinking)
5. [server-everything](#server-everything)
6. [agentql-mcp](#agentql-mcp)
7. [agentrpc](#agentrpc)

---

## server-time

### Overview
The server-time MCP provides comprehensive time and timezone operations, enabling Claude to work with dates, times, and timezones accurately across different regions.

### Key Features
- Current time retrieval in any timezone
- Timezone conversion and calculations
- Date arithmetic and formatting
- Time difference calculations
- Business hours validation

### Tools Available

#### get_current_time
Retrieves the current time in a specified timezone.

```javascript
await use_mcp_tool("server-time", "get_current_time", {
  "timezone": "America/New_York"
});
```

#### convert_timezone
Converts time between different timezones.

```javascript
await use_mcp_tool("server-time", "convert_timezone", {
  "time": "2024-01-15 14:30:00",
  "from_timezone": "UTC",
  "to_timezone": "Asia/Tokyo"
});
```

#### calculate_time_difference
Calculates the difference between two times.

```javascript
await use_mcp_tool("server-time", "calculate_time_difference", {
  "time1": "2024-01-15 10:00:00",
  "time2": "2024-01-15 15:30:00",
  "unit": "hours"
});
```

### Use Cases
- **Meeting Scheduling**: Schedule meetings across multiple timezones
- **Deadline Management**: Calculate deadlines considering timezone differences
- **Log Analysis**: Convert timestamps to local time for debugging
- **International Operations**: Manage business hours across regions

### Integration Example
```javascript
// Check if Tokyo office is open
const tokyoTime = await use_mcp_tool("server-time", "get_current_time", {
  "timezone": "Asia/Tokyo"
});

const hour = parseInt(tokyoTime.hour);
if (hour >= 9 && hour < 18) {
  console.log("Tokyo office is open");
}
```

---

## server-fetch

### Overview
The server-fetch MCP enables HTTP requests with advanced features like authentication, custom headers, and response handling, making it ideal for API integrations and web scraping.

### Key Features
- All HTTP methods (GET, POST, PUT, DELETE, PATCH)
- Custom headers and authentication
- Request/response body handling
- Cookie management
- Proxy support
- Timeout configuration

### Tools Available

#### fetch
Performs HTTP requests with full configuration options.

```javascript
await use_mcp_tool("server-fetch", "fetch", {
  "url": "https://api.example.com/data",
  "method": "GET",
  "headers": {
    "Authorization": "Bearer token123",
    "Accept": "application/json"
  }
});
```

#### fetch_with_retry
Performs HTTP requests with automatic retry logic.

```javascript
await use_mcp_tool("server-fetch", "fetch_with_retry", {
  "url": "https://api.example.com/data",
  "method": "POST",
  "body": JSON.stringify({ key: "value" }),
  "max_retries": 3,
  "retry_delay": 1000
});
```

### Use Cases
- **API Integration**: Connect to external services and APIs
- **Data Collection**: Fetch data from web services
- **Webhook Handling**: Send notifications to webhook endpoints
- **Service Monitoring**: Check API endpoint health

### Integration Example
```javascript
// Fetch GitHub repository information
const response = await use_mcp_tool("server-fetch", "fetch", {
  "url": "https://api.github.com/repos/anthropics/claude",
  "headers": {
    "Accept": "application/vnd.github.v3+json"
  }
});

const repoData = JSON.parse(response.body);
console.log(`Stars: ${repoData.stargazers_count}`);
```

---

## server-memory

### Overview
The server-memory MCP provides persistent knowledge storage, allowing Claude to remember information across conversations and sessions.

### Key Features
- Key-value storage with namespaces
- Persistent memory across sessions
- Memory search and retrieval
- Memory categorization
- Expiration support
- Memory statistics

### Tools Available

#### store_memory
Stores information in persistent memory.

```javascript
await use_mcp_tool("server-memory", "store_memory", {
  "key": "user_preferences",
  "value": {
    "theme": "dark",
    "language": "en",
    "notifications": true
  },
  "namespace": "user_settings",
  "ttl": 86400  // 24 hours
});
```

#### retrieve_memory
Retrieves stored information from memory.

```javascript
await use_mcp_tool("server-memory", "retrieve_memory", {
  "key": "user_preferences",
  "namespace": "user_settings"
});
```

#### search_memory
Searches through stored memories.

```javascript
await use_mcp_tool("server-memory", "search_memory", {
  "query": "project",
  "namespace": "work_notes"
});
```

### Use Cases
- **User Preferences**: Store and retrieve user settings
- **Context Preservation**: Maintain context across conversations
- **Knowledge Base**: Build a searchable knowledge repository
- **Session Management**: Track session-specific information

### Integration Example
```javascript
// Store project context
await use_mcp_tool("server-memory", "store_memory", {
  "key": "current_project",
  "value": {
    "name": "MCP Documentation",
    "status": "in_progress",
    "last_updated": new Date().toISOString()
  },
  "namespace": "projects"
});

// Later retrieve it
const project = await use_mcp_tool("server-memory", "retrieve_memory", {
  "key": "current_project",
  "namespace": "projects"
});
```

---

## server-sequentialthinking

### Overview
The server-sequentialthinking MCP enables step-by-step problem solving, breaking down complex tasks into manageable sequential steps with validation at each stage.

### Key Features
- Step-by-step task decomposition
- Progress tracking and validation
- Rollback capabilities
- Dependency management
- Parallel step execution
- Result aggregation

### Tools Available

#### create_sequence
Creates a new sequential thinking process.

```javascript
await use_mcp_tool("server-sequentialthinking", "create_sequence", {
  "name": "deploy_application",
  "steps": [
    { "id": "1", "action": "run_tests", "dependencies": [] },
    { "id": "2", "action": "build_docker", "dependencies": ["1"] },
    { "id": "3", "action": "push_registry", "dependencies": ["2"] },
    { "id": "4", "action": "deploy_k8s", "dependencies": ["3"] }
  ]
});
```

#### execute_step
Executes a specific step in the sequence.

```javascript
await use_mcp_tool("server-sequentialthinking", "execute_step", {
  "sequence_id": "deploy_application",
  "step_id": "1",
  "input": { "test_suite": "all" }
});
```

#### get_sequence_status
Gets the current status of a sequence.

```javascript
await use_mcp_tool("server-sequentialthinking", "get_sequence_status", {
  "sequence_id": "deploy_application"
});
```

### Use Cases
- **Complex Deployments**: Orchestrate multi-step deployment processes
- **Data Pipelines**: Build sequential data processing workflows
- **Problem Solving**: Break down complex problems into steps
- **Task Automation**: Create reproducible task sequences

### Integration Example
```javascript
// Create a code review sequence
await use_mcp_tool("server-sequentialthinking", "create_sequence", {
  "name": "code_review_process",
  "steps": [
    { "id": "lint", "action": "run_linter" },
    { "id": "test", "action": "run_tests", "dependencies": ["lint"] },
    { "id": "security", "action": "security_scan", "dependencies": ["lint"] },
    { "id": "review", "action": "human_review", "dependencies": ["test", "security"] }
  ]
});

// Execute each step
for (const step of ["lint", "test", "security"]) {
  await use_mcp_tool("server-sequentialthinking", "execute_step", {
    "sequence_id": "code_review_process",
    "step_id": step
  });
}
```

---

## server-everything

### Overview
The server-everything MCP provides ultra-fast file search capabilities using advanced indexing, making it perfect for large codebases and document repositories.

### Key Features
- Lightning-fast file search
- Content indexing and search
- Regex pattern matching
- File type filtering
- Size and date filtering
- Real-time index updates

### Tools Available

#### search_files
Searches for files based on various criteria.

```javascript
await use_mcp_tool("server-everything", "search_files", {
  "query": "TODO",
  "path": "/project",
  "file_types": [".js", ".ts"],
  "max_results": 50
});
```

#### search_content
Searches within file contents with advanced options.

```javascript
await use_mcp_tool("server-everything", "search_content", {
  "pattern": "function.*async",
  "path": "/src",
  "regex": true,
  "case_sensitive": false
});
```

#### index_directory
Indexes a directory for faster future searches.

```javascript
await use_mcp_tool("server-everything", "index_directory", {
  "path": "/large/codebase",
  "recursive": true,
  "file_types": [".js", ".py", ".go"]
});
```

### Use Cases
- **Code Search**: Find functions, classes, or patterns in code
- **Documentation Search**: Locate specific documentation
- **Refactoring**: Find all occurrences of code to refactor
- **Audit**: Search for security patterns or issues

### Integration Example
```javascript
// Find all test files that use a specific function
const testFiles = await use_mcp_tool("server-everything", "search_files", {
  "query": "test",
  "path": "/project",
  "file_types": [".test.js", ".spec.js"]
});

// Search for usage of deprecated function
const deprecatedUsage = await use_mcp_tool("server-everything", "search_content", {
  "pattern": "oldFunction\\(",
  "path": "/src",
  "regex": true
});
```

---

## agentql-mcp

### Overview
The agentql-mcp server provides intelligent web scraping capabilities with CSS selectors, XPath, and AI-powered element detection for reliable data extraction.

### Key Features
- Smart element detection
- CSS and XPath selectors
- JavaScript execution
- Screenshot capture
- Form interaction
- Pagination handling

### Tools Available

#### scrape_page
Scrapes data from a web page using intelligent selectors.

```javascript
await use_mcp_tool("agentql-mcp", "scrape_page", {
  "url": "https://example.com/products",
  "selectors": {
    "title": "h1.product-title",
    "price": ".price-tag",
    "description": ".product-description"
  },
  "wait_for": ".products-loaded"
});
```

#### extract_table
Extracts tabular data from web pages.

```javascript
await use_mcp_tool("agentql-mcp", "extract_table", {
  "url": "https://example.com/data",
  "table_selector": "table#data-table",
  "headers": true
});
```

#### interact_with_page
Interacts with page elements (click, type, select).

```javascript
await use_mcp_tool("agentql-mcp", "interact_with_page", {
  "url": "https://example.com/form",
  "actions": [
    { "type": "fill", "selector": "#username", "value": "user123" },
    { "type": "fill", "selector": "#password", "value": "pass123" },
    { "type": "click", "selector": "#submit-button" }
  ]
});
```

### Use Cases
- **Data Collection**: Scrape product information, prices, reviews
- **Monitoring**: Track website changes and updates
- **Testing**: Automated UI testing and validation
- **Research**: Gather data from multiple sources

### Integration Example
```javascript
// Scrape GitHub trending repositories
const trending = await use_mcp_tool("agentql-mcp", "scrape_page", {
  "url": "https://github.com/trending",
  "selectors": {
    "repos": ".Box-row",
    "name": "h2 a",
    "description": "p.text-gray",
    "stars": ".octicon-star + span"
  }
});

// Process the data
trending.repos.forEach(repo => {
  console.log(`${repo.name}: ${repo.stars} stars`);
});
```

---

## agentrpc

### Overview
The agentrpc MCP enables remote function calls across different services and systems, providing a unified interface for distributed computing and microservice communication.

### Key Features
- Remote procedure calls
- Service discovery
- Load balancing
- Async/await support
- Error handling and retries
- Response caching

### Tools Available

#### call_remote_function
Calls a function on a remote service.

```javascript
await use_mcp_tool("agentrpc", "call_remote_function", {
  "service": "auth-service",
  "function": "validateToken",
  "args": {
    "token": "eyJhbGc..."
  },
  "timeout": 5000
});
```

#### discover_services
Discovers available services and their functions.

```javascript
await use_mcp_tool("agentrpc", "discover_services", {
  "namespace": "production",
  "tags": ["api", "v2"]
});
```

#### batch_call
Executes multiple remote calls in parallel.

```javascript
await use_mcp_tool("agentrpc", "batch_call", {
  "calls": [
    {
      "service": "user-service",
      "function": "getUser",
      "args": { "id": "123" }
    },
    {
      "service": "order-service",
      "function": "getOrders",
      "args": { "userId": "123" }
    }
  ]
});
```

### Use Cases
- **Microservice Communication**: Call functions across services
- **Distributed Computing**: Execute tasks on remote machines
- **API Gateway**: Unified interface for multiple services
- **Load Distribution**: Distribute work across multiple instances

### Integration Example
```javascript
// Orchestrate a multi-service operation
const userAuth = await use_mcp_tool("agentrpc", "call_remote_function", {
  "service": "auth-service",
  "function": "authenticateUser",
  "args": {
    "username": "john@example.com",
    "password": "secure123"
  }
});

if (userAuth.success) {
  // Get user profile and preferences in parallel
  const results = await use_mcp_tool("agentrpc", "batch_call", {
    "calls": [
      {
        "service": "profile-service",
        "function": "getProfile",
        "args": { "userId": userAuth.userId }
      },
      {
        "service": "preference-service",
        "function": "getPreferences",
        "args": { "userId": userAuth.userId }
      }
    ]
  });
  
  console.log("User authenticated and data loaded");
}
```

---

## Integration Patterns

### Pattern 1: Data Pipeline
Combine multiple servers for complex data processing:

```javascript
// 1. Fetch data from API
const apiData = await use_mcp_tool("server-fetch", "fetch", {
  "url": "https://api.example.com/data"
});

// 2. Store in memory for caching
await use_mcp_tool("server-memory", "store_memory", {
  "key": "api_data_cache",
  "value": apiData,
  "ttl": 3600
});

// 3. Process sequentially
await use_mcp_tool("server-sequentialthinking", "create_sequence", {
  "name": "data_processing",
  "steps": [
    { "id": "validate", "action": "validate_data" },
    { "id": "transform", "action": "transform_data" },
    { "id": "store", "action": "store_results" }
  ]
});
```

### Pattern 2: Monitoring System
Build a comprehensive monitoring solution:

```javascript
// Check service health across timezones
const checks = ["US", "EU", "ASIA"].map(async (region) => {
  const localTime = await use_mcp_tool("server-time", "get_current_time", {
    "timezone": getTimezone(region)
  });
  
  const health = await use_mcp_tool("agentrpc", "call_remote_function", {
    "service": `health-${region}`,
    "function": "checkStatus"
  });
  
  return { region, time: localTime, health };
});

// Store results
await use_mcp_tool("server-memory", "store_memory", {
  "key": "health_check_results",
  "value": await Promise.all(checks),
  "namespace": "monitoring"
});
```

### Pattern 3: Research Assistant
Combine search and scraping for research:

```javascript
// 1. Search for relevant files
const files = await use_mcp_tool("server-everything", "search_files", {
  "query": "machine learning",
  "file_types": [".md", ".pdf"]
});

// 2. Scrape additional online resources
const webData = await use_mcp_tool("agentql-mcp", "scrape_page", {
  "url": "https://arxiv.org/search/?query=machine+learning",
  "selectors": {
    "papers": ".arxiv-result",
    "title": ".title",
    "abstract": ".abstract"
  }
});

// 3. Create sequential research plan
await use_mcp_tool("server-sequentialthinking", "create_sequence", {
  "name": "research_plan",
  "steps": [
    { "id": "analyze_local", "action": "analyze_files" },
    { "id": "analyze_web", "action": "analyze_papers" },
    { "id": "synthesize", "action": "create_summary" }
  ]
});
```

## Best Practices

1. **Error Handling**: Always wrap MCP calls in try-catch blocks
2. **Caching**: Use server-memory to cache expensive operations
3. **Timeouts**: Set appropriate timeouts for network operations
4. **Batch Operations**: Use batch calls when possible to improve performance
5. **Sequential Processing**: Use server-sequentialthinking for complex workflows
6. **Time Awareness**: Consider timezones when scheduling or logging
7. **Resource Management**: Clean up resources and connections when done

## Troubleshooting

### Common Issues

1. **Connection Timeouts**: Increase timeout values for slow operations
2. **Memory Limits**: Use namespaces to organize stored data
3. **Rate Limiting**: Implement retry logic with exponential backoff
4. **Scraping Failures**: Use multiple selectors and fallbacks

### Debug Tools

```javascript
// Test server connectivity
const services = await use_mcp_tool("agentrpc", "discover_services", {});
console.log("Available services:", services);

// Check memory usage
const memStats = await use_mcp_tool("server-memory", "get_statistics", {});
console.log("Memory usage:", memStats);

// Verify timezone data
const timezones = await use_mcp_tool("server-time", "list_timezones", {});
console.log("Available timezones:", timezones.length);
```
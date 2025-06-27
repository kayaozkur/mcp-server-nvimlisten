# Practical Multi-Server Workflow Examples

Ready-to-use examples combining MCP servers for real development tasks.

## 🔍 Example 1: Smart API Development Workflow

**Scenario**: Building a new REST API endpoint with automatic documentation and testing.

```javascript
// 1. Research best practices for the API you're building
const apiType = "REST API pagination";
const research = await use_mcp_tool("server-brave-search", "search", {
  "query": `${apiType} best practices 2024 offset vs cursor`
});

// 2. Open your API file in main editor
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/api/users.js"
});

// 3. Display research findings in navigator
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7002,
  "command": ":enew<CR>:set ft=markdown<CR>i# API Research Findings<CR><CR>" +
            research.results.slice(0, 3).map(r => 
              `- [${r.title}](${r.url})<CR>  ${r.description}<CR>`
            ).join('<CR>')
});

// 4. Implement the endpoint (you write the code)
// ... coding happens here ...

// 5. Test the endpoint immediately
const testResponse = await use_mcp_tool("server-fetch", "fetch", {
  "url": "http://localhost:3000/api/users?page=1&limit=10",
  "method": "GET",
  "headers": {
    "Authorization": "Bearer test-token"
  }
});

// 6. Auto-generate API documentation
const apiDoc = `## GET /api/users

### Description
Retrieves paginated list of users

### Parameters
- \`page\` (number): Page number (default: 1)
- \`limit\` (number): Items per page (default: 10)

### Example Request
\`\`\`bash
curl -X GET "http://localhost:3000/api/users?page=1&limit=10" \\
  -H "Authorization: Bearer YOUR_TOKEN"
\`\`\`

### Example Response (${testResponse.status})
\`\`\`json
${JSON.stringify(testResponse.data, null, 2)}
\`\`\`

### Response Headers
- Rate-Limit-Remaining: ${testResponse.headers['x-rate-limit-remaining']}
- Response-Time: ${testResponse.headers['x-response-time']}ms
`;

// 7. Save documentation
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "docs/api/users.md"
});

await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7002,
  "command": ":normal! Go<CR>" + apiDoc.replace(/\n/g, '<CR>')
});

// 8. Remember this pattern for next time
await use_mcp_tool("server-memory", "create_memory", {
  "content": JSON.stringify({
    type: "api-pattern",
    endpoint: "/api/users",
    implementation: "cursor-based pagination",
    reasoning: research.results[0].description,
    performanceNotes: "Handles 10k+ records efficiently"
  })
});
```

## 🧪 Example 2: Test-Driven Development with Live Data

**Scenario**: Writing tests using real API responses.

```javascript
// 1. Fetch live data from production API
const prodData = await use_mcp_tool("server-fetch", "fetch", {
  "url": "https://jsonplaceholder.typicode.com/posts/1"
});

// 2. Open test file
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "tests/post.test.js"
});

// 3. Generate test cases from real data
const testCode = `
describe('Post API Tests', () => {
  const mockPost = ${JSON.stringify(prodData.data, null, 4).replace(/\n/g, '\n  ')};

  test('should handle post structure', () => {
    expect(mockPost).toHaveProperty('userId');
    expect(mockPost).toHaveProperty('id');
    expect(mockPost).toHaveProperty('title');
    expect(mockPost).toHaveProperty('body');
  });

  test('should validate data types', () => {
    expect(typeof mockPost.userId).toBe('number');
    expect(typeof mockPost.id).toBe('number');
    expect(typeof mockPost.title).toBe('string');
    expect(typeof mockPost.body).toBe('string');
  });

  test('should handle empty responses', async () => {
    const response = await fetchPost(999999);
    expect(response).toBeNull();
  });
});`;

// 4. Insert test code
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":normal! Go<CR>" + testCode.replace(/\n/g, '<CR>')
});

// 5. Run tests immediately
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test tests/post.test.js"
});

// 6. Save test patterns
await use_mcp_tool("server-memory", "create_memory", {
  "content": "Test pattern: Generate test cases from production API responses for realistic testing"
});
```

## ⏰ Example 3: Pomodoro Coding Session with Progress Tracking

**Scenario**: Focused coding session with automatic progress tracking.

```javascript
// 1. Start a Pomodoro session
const sessionGoal = "Implement user authentication";
await use_mcp_tool("server-time", "set_timer", {
  "seconds": 1500,  // 25 minutes
  "label": "Pomodoro: " + sessionGoal
});

// 2. Log session start
const startTime = await use_mcp_tool("server-time", "get_current_time", {});
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": `🍅 Pomodoro started at ${startTime.datetime} - Goal: ${sessionGoal}`,
  "messageType": "info"
});

// 3. Open relevant files
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/auth/login.js"
});

await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "src/auth/jwt.js"
});

// 4. After 25 minutes, the timer expires...
// Log what you accomplished
const accomplishments = [
  "Created login endpoint",
  "Added password validation",
  "Implemented JWT token generation",
  "Started refresh token logic"
];

// 5. Save session results
await use_mcp_tool("server-memory", "create_memory", {
  "content": JSON.stringify({
    type: "pomodoro-session",
    date: startTime.datetime,
    goal: sessionGoal,
    duration: 25,
    completed: accomplishments,
    nextSteps: ["Finish refresh token", "Add rate limiting", "Write tests"]
  })
});

// 6. Generate session summary
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": `🎉 Pomodoro complete! Accomplished: ${accomplishments.length} tasks`,
  "messageType": "info"
});

// 7. Search for all today's pomodoros
const todaysSessions = await use_mcp_tool("server-memory", "search_memories", {
  "query": "pomodoro-session"
});

console.log(`Today's productivity: ${todaysSessions.memories.length} pomodoros completed!`);
```

## 🌐 Example 4: Multi-Service Development

**Scenario**: Developing microservices with real-time monitoring.

```javascript
// 1. Start multiple services with monitoring
const services = [
  { name: "auth-service", port: 3001, file: "services/auth/index.js" },
  { name: "user-service", port: 3002, file: "services/user/index.js" },
  { name: "email-service", port: 3003, file: "services/email/index.js" }
];

// 2. Open each service in Neovim
for (const [index, service] of services.entries()) {
  const port = [7001, 7002, 7777][index];
  await use_mcp_tool("nvimlisten", "neovim-open-file", {
    "port": port,
    "filepath": service.file
  });
}

// 3. Start services in terminal
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm run start:all-services"
});

// 4. Test inter-service communication
const authTest = await use_mcp_tool("server-fetch", "fetch", {
  "url": "http://localhost:3001/auth/login",
  "method": "POST",
  "headers": { "Content-Type": "application/json" },
  "body": JSON.stringify({
    "email": "test@example.com",
    "password": "testpass123"
  })
});

// 5. Display service health
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": `Services Health: Auth ✅ (${authTest.status}) | User ⏳ | Email ⏳`,
  "messageType": "info"
});

// 6. Monitor for 5 minutes
await use_mcp_tool("server-time", "set_timer", {
  "seconds": 300,
  "label": "Service monitoring period"
});

// 7. Log service interactions
await use_mcp_tool("server-memory", "create_memory", {
  "content": JSON.stringify({
    type: "service-test",
    timestamp: new Date().toISOString(),
    services: services.map(s => s.name),
    testResults: {
      auth: { status: authTest.status, response: authTest.data }
    }
  })
});
```

## 🕵️ Example 5: Debug Session with Memory

**Scenario**: Debugging a complex issue with persistent notes.

```javascript
// 1. Start debug session
const bugDescription = "Users report login fails after password reset";

await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": `🐛 Debug session: ${bugDescription}`,
  "messageType": "warning"
});

// 2. Search for related code
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope grep_string<CR>password reset<CR>"
});

// 3. Check previous similar issues
const similarIssues = await use_mcp_tool("server-memory", "search_memories", {
  "query": "password reset bug"
});

if (similarIssues.memories.length > 0) {
  await use_mcp_tool("nvimlisten", "broadcast-message", {
    "message": `Found ${similarIssues.memories.length} similar past issues`,
    "messageType": "info"
  });
}

// 4. Test the bug scenario
const bugTest = await use_mcp_tool("server-fetch", "fetch", {
  "url": "http://localhost:3000/api/auth/reset-password",
  "method": "POST",
  "headers": { "Content-Type": "application/json" },
  "body": JSON.stringify({
    "token": "test-reset-token",
    "newPassword": "newPass123!"
  })
});

// 5. Log findings
const debugFindings = {
  issue: bugDescription,
  timestamp: new Date().toISOString(),
  testResult: {
    status: bugTest.status,
    error: bugTest.data.error
  },
  hypothesis: "Token expiration not being checked properly",
  files_checked: [
    "src/auth/reset-password.js",
    "src/middleware/auth.js",
    "src/utils/tokens.js"
  ],
  solution: "Add token expiration validation before password update"
};

// 6. Save debug session
await use_mcp_tool("server-memory", "create_memory", {
  "content": JSON.stringify({
    type: "debug-session",
    ...debugFindings
  })
});

// 7. Create fix task
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": `echo "- [ ] Fix: ${debugFindings.solution}" >> TODO.md`
});
```

## 🎨 Example 6: UI Component Development with Competitive Analysis

**Scenario**: Building a pricing table while analyzing competitors.

```javascript
// 1. Scrape competitor pricing pages
const competitors = [
  "https://stripe.com/pricing",
  "https://github.com/pricing"
];

const competitorData = [];
for (const url of competitors) {
  const data = await use_mcp_tool("agentql-mcp", "query", {
    "url": url,
    "query": `{
      pricing_cards {
        tier_name
        price
        features[]
        cta_button_text
      }
    }`
  });
  competitorData.push({ url, data: data.result });
}

// 2. Open your component
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/components/PricingTable.tsx"
});

// 3. Display competitor analysis
const analysis = `# Competitor Pricing Analysis

${competitorData.map(c => `
## ${new URL(c.url).hostname}
${c.data.pricing_cards.map(card => `
- **${card.tier_name}**: ${card.price}
  - ${card.features.slice(0, 3).join('\\n  - ')}
  - CTA: "${card.cta_button_text}"
`).join('')}
`).join('')}`;

await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7002,
  "command": ":enew<CR>:set ft=markdown<CR>i" + analysis.replace(/\n/g, '<CR>')
});

// 4. Save insights
await use_mcp_tool("server-memory", "create_memory", {
  "content": JSON.stringify({
    type: "competitive-analysis",
    component: "pricing-table",
    date: new Date().toISOString(),
    insights: [
      "Most competitors use 3-tier pricing",
      "Free tier is common but limited",
      "Enterprise requires 'Contact Sales'"
    ],
    data: competitorData
  })
});
```

## 🚀 Quick Command Reference

```javascript
// Start your development session
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"
});

// Set up your workspace
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "🚀 Development environment ready!",
  "messageType": "info"
});

// Quick research
const quick = await use_mcp_tool("server-brave-search", "search", {
  "query": "your search query here"
});

// Quick API test
const test = await use_mcp_tool("server-fetch", "fetch", {
  "url": "your-api-endpoint"
});

// Quick note
await use_mcp_tool("server-memory", "create_memory", {
  "content": "Your important note here"
});

// Quick timer
await use_mcp_tool("server-time", "set_timer", {
  "seconds": 300,
  "label": "5 minute reminder"
});
```

## 💡 Pro Tips

1. **Batch Operations**: Run multiple tool calls in parallel for speed
2. **Session Templates**: Save common workflows as memory entries
3. **Keyboard Shortcuts**: Use Neovim keybindings to trigger MCP tools
4. **Error Handling**: Always wrap in try-catch for production code
5. **Progress Tracking**: Use broadcast messages for real-time updates

These examples show real, practical workflows you can use today. Mix and match tools based on your needs!
# MCP Integration Quick Start Guide - Power Features

## 🚀 3 Essential Things to Know

### 1. **Restart Claude Desktop First!**
The new MCP servers won't work until you restart Claude Desktop. After restart, all 16 servers will be available.

### 2. **Access via `use_mcp_tool()` Function**
```javascript
// Example: Search while coding
await use_mcp_tool("server-brave-search", "search", {
  "query": "React hooks best practices 2024"
});

// Example: Remember your work
await use_mcp_tool("server-memory", "store", {
  "key": "project-decisions",
  "value": "Using TypeScript + Vitest for testing"
});

// Example: Time your work
await use_mcp_tool("server-time", "get_current_time", {});
```

### 3. **Debug with MCP Inspector**
```bash
mcp-inspector-cli --help  # Get help
mcp-inspector-cli --cli   # Interactive mode
```

## 🎯 5 Power Integration Features

### 1. **Research + Code** 🔍
Search for best practices WHILE implementing:
```javascript
// Research OAuth implementation
const research = await use_mcp_tool("server-brave-search", "search", {
  "query": "OAuth 2.0 PKCE flow Node.js 2024"
});

// Open your code
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/auth/oauth.js"
});

// Save findings
await use_mcp_tool("server-memory", "store", {
  "key": "oauth-research",
  "value": research.results
});
```

### 2. **Memory + Sessions** 🧠
Never lose development context:
```javascript
// Save your entire session
await use_mcp_tool("server-memory", "store", {
  "key": "session-auth-feature",
  "value": {
    "openFiles": ["src/auth.js", "tests/auth.test.js"],
    "decisions": ["JWT tokens", "15min expiry"],
    "todos": ["Add refresh token", "Test edge cases"]
  }
});

// Restore tomorrow
const session = await use_mcp_tool("server-memory", "retrieve", {
  "key": "session-auth-feature"
});
```

### 3. **Time + Productivity** ⏰
Track and optimize coding time:
```javascript
// Start Pomodoro timer
await use_mcp_tool("server-time", "set_timer", {
  "duration": 1500,  // 25 minutes
  "message": "Time for a break!"
});

// Log what you accomplished
await use_mcp_tool("server-memory", "store", {
  "key": `pomodoro-${Date.now()}`,
  "value": {
    "task": "Implement auth",
    "completed": ["Login endpoint", "Password hashing"]
  }
});
```

### 4. **Scraping + Analysis** 🕷️
Competitive analysis automation:
```javascript
// Scrape competitor features
const data = await use_mcp_tool("agentql-mcp", "extract", {
  "url": "https://competitor.com/features",
  "query": "feature { name description pricing }"
});

// Analyze and document
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "docs/competitor-analysis.md"
});
```

### 5. **RPC + Microservices** 🔌
Build distributed systems:
```javascript
// Call remote service
const result = await use_mcp_tool("agentrpc", "call", {
  "service": "auth-service",
  "method": "validateToken",
  "args": [token]
});

// Use in your code
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": `:put ='const isValid = ${result}'<CR>`
});
```

## 📚 Documentation Locations

- **Integration Workflows**: `/docs/INTEGRATED_WORKFLOWS.md`
- **Advanced Patterns**: `/docs/ENHANCED_DEVELOPMENT_PATTERNS.md`
- **Troubleshooting**: `/docs/TROUBLESHOOTING.md`
- **API Reference**: `/docs/MCP_TOOLS_API.md`

## 💡 Pro Tips

1. **Combine Multiple Servers**: The real power comes from using servers together
2. **Use Memory for Context**: Store decisions, research, and progress
3. **Time-Box Complex Tasks**: Use timers to maintain focus
4. **Document as You Go**: Use broadcast messages to log important events
5. **Debug Early**: Use MCP Inspector when things don't work as expected

## 🔥 Quick Productivity Boost

```javascript
// The Ultimate Dev Setup
async function startProductiveSession(projectName) {
  // 1. Start environment
  await use_mcp_tool("nvimlisten", "start-environment", {
    "layout": "enhanced"
  });
  
  // 2. Load previous session
  const lastSession = await use_mcp_tool("server-memory", "retrieve", {
    "key": `session-${projectName}`
  });
  
  // 3. Open files where you left off
  if (lastSession?.openFiles) {
    for (const file of lastSession.openFiles) {
      await use_mcp_tool("nvimlisten", "neovim-open-file", {
        "port": 7001,
        "filepath": file
      });
    }
  }
  
  // 4. Start timer
  await use_mcp_tool("server-time", "set_timer", {
    "duration": 1500,
    "message": "First Pomodoro complete!"
  });
  
  // 5. Broadcast ready
  await use_mcp_tool("nvimlisten", "broadcast-message", {
    "message": `Starting work on ${projectName}`,
    "messageType": "info"
  });
}

// Use it!
await startProductiveSession("my-awesome-project");
```

## 🚦 Status Check

Run this after restart to verify all servers:
```javascript
// Test each server
const tests = [
  ["server-time", "get_current_time", {}],
  ["server-memory", "store", {"key": "test", "value": "working!"}],
  ["server-brave-search", "search", {"query": "test"}],
  ["nvimlisten", "health-check", {}]
];

for (const [server, method, args] of tests) {
  try {
    await use_mcp_tool(server, method, args);
    console.log(`✅ ${server}: Working`);
  } catch (e) {
    console.log(`❌ ${server}: Failed`);
  }
}
```

---

**Remember**: Restart Claude Desktop to activate these superpowers! 🚀
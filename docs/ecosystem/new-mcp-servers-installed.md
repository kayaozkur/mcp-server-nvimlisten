# New MCP Servers & Tools Installation Guide

## 🎉 Installation Summary

Successfully installed **7 new MCP servers**, **1 debugging tool**, and noted **2 SDKs** for development!

## 📦 Newly Installed MCP Servers

### 1. **@modelcontextprotocol/server-time** ⏰
- **Purpose**: Provides current time and timezone information
- **Features**:
  - Get current time in various formats
  - Timezone conversions
  - Date calculations
- **Installation**: Via uvx
- **Usage**: Access time-based functionality without external APIs

### 2. **@modelcontextprotocol/server-fetch** 🌐
- **Purpose**: Web content fetching and HTTP requests
- **Features**:
  - HTTP/HTTPS requests (GET, POST, etc.)
  - Headers and authentication support
  - Response parsing
  - Web scraping capabilities
- **Installation**: Via uvx
- **Usage**: Fetch web content, APIs, and remote resources

### 3. **@modelcontextprotocol/server-memory** 🧠
- **Purpose**: Knowledge graph-based persistent memory system
- **Features**:
  - Store and retrieve information across sessions
  - Create knowledge relationships
  - Semantic search capabilities
  - Context persistence
- **Installation**: Via npx
- **Usage**: Maintain context and memory across conversations

### 4. **@modelcontextprotocol/server-sequentialthinking** 🤔
- **Purpose**: Dynamic and reflective problem-solving through thought sequences
- **Features**:
  - Step-by-step reasoning
  - Thought chain management
  - Problem decomposition
  - Solution synthesis
- **Installation**: Via uvx
- **Usage**: Complex problem-solving and reasoning tasks

### 5. **@modelcontextprotocol/server-everything** 🔍
- **Purpose**: Local file search using Everything search engine (Windows) or similar
- **Features**:
  - Ultra-fast file searching
  - Real-time results
  - Regex support
  - File metadata access
- **Installation**: Via npx
- **Usage**: Instant file and folder searches across entire system

### 6. **@tinyfish-io/agentql-mcp** 🕷️
- **Purpose**: Web scraping and data extraction using AgentQL
- **Features**:
  - Structured data extraction from websites
  - CSS selector-based queries
  - JavaScript execution support
  - API integration
- **Installation**: Via uvx
- **Usage**: Extract structured data from unstructured web pages

### 7. **@agentrpc/agentrpc** 🔌
- **Purpose**: Connect to any function, any language, across network boundaries
- **Features**:
  - Cross-language RPC
  - Network-transparent function calls
  - Multi-protocol support
  - Service discovery
- **Installation**: Via uvx
- **Usage**: Call remote functions as if they were local

## 🛠️ Development Tools

### MCP Inspector 🔍
**Installed globally via npm**
```bash
npm install -g @modelcontextprotocol/inspector-cli
```

**Features**:
- Debug MCP connections
- Inspect protocol messages
- Monitor server responses
- Test tool implementations
- Visualize data flow

**Usage**:
```bash
# Inspect a running MCP server
mcp-inspector inspect <server-name>

# Test MCP tools
mcp-inspector test <tool-name>

# Monitor live connections
mcp-inspector monitor
```

### SDKs for Building MCP Servers

#### Python SDK 🐍
**Repository**: https://github.com/modelcontextprotocol/python-sdk
```bash
pip install mcp
```

**Features**:
- Build Python-based MCP servers
- FastMCP for quick development
- Async support
- Type hints

**Quick Example**:
```python
from mcp.server import Server
from mcp.types import TextContent

server = Server("my-server")

@server.tool()
async def hello_world(name: str) -> TextContent:
    return TextContent(text=f"Hello, {name}!")
```

#### TypeScript SDK 📘
**Repository**: https://github.com/modelcontextprotocol/typescript-sdk
```bash
npm install @modelcontextprotocol/sdk
```

**Features**:
- Build TypeScript/JavaScript MCP servers
- Full type safety
- Browser and Node.js support
- Streaming capabilities

**Quick Example**:
```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new Server({
  name: "my-server",
  version: "1.0.0",
});

server.setRequestHandler(/* ... */);
```

## 📋 Complete MCP Server List (Now 16!)

| Server | Purpose | Status |
|--------|---------|---------|
| **repomix** | Code repository analysis | ✅ |
| **mcp-installer** | Server installation | ✅ |
| **desktop-commander** | File & command ops | ✅ |
| **mcp-acquaint** | R language integration | ✅ |
| **nvimlisten** | Neovim control | ✅ |
| **doppler-mcp** | Secrets management | ✅ |
| **server-filesystem** | File operations | ✅ |
| **server-git** | Git integration | ✅ |
| **server-brave-search** | Web search | ✅ |
| **server-time** ✨ | Time & timezone | ✅ |
| **server-fetch** ✨ | HTTP requests | ✅ |
| **server-memory** ✨ | Persistent memory | ✅ |
| **server-sequentialthinking** ✨ | Problem solving | ✅ |
| **server-everything** ✨ | File search | ✅ |
| **agentql-mcp** ✨ | Web scraping | ✅ |
| **agentrpc** ✨ | Remote functions | ✅ |

✨ = Newly installed

## 🚀 Usage Examples

### Time Server
```javascript
// Get current time
await use_mcp_tool("server-time", "get_current_time", {});

// Convert timezone
await use_mcp_tool("server-time", "convert_timezone", {
  "time": "2025-06-26T10:00:00",
  "from": "UTC",
  "to": "America/New_York"
});
```

### Fetch Server
```javascript
// Fetch a webpage
await use_mcp_tool("server-fetch", "fetch", {
  "url": "https://example.com/api/data",
  "method": "GET",
  "headers": {"Authorization": "Bearer token"}
});
```

### Memory Server
```javascript
// Store information
await use_mcp_tool("server-memory", "store", {
  "key": "project_notes",
  "value": "Important: Deploy on Friday",
  "metadata": {"category": "deployment"}
});

// Retrieve information
await use_mcp_tool("server-memory", "retrieve", {
  "key": "project_notes"
});
```

### Sequential Thinking
```javascript
// Solve a complex problem
await use_mcp_tool("server-sequentialthinking", "think", {
  "problem": "How to optimize database queries in a large application",
  "steps": 5
});
```

### Everything Search
```javascript
// Find files instantly
await use_mcp_tool("server-everything", "search", {
  "query": "*.pdf",
  "path": "/Users/kayaozkur/Documents"
});
```

### AgentQL
```javascript
// Extract structured data
await use_mcp_tool("agentql-mcp", "extract", {
  "url": "https://example.com/products",
  "query": "product { name price description }"
});
```

### AgentRPC
```javascript
// Call remote function
await use_mcp_tool("agentrpc", "call", {
  "service": "calculator",
  "function": "multiply",
  "args": [42, 10]
});
```

## 🔧 Configuration

All servers have been added to:
```
/Users/kayaozkur/Library/Application Support/Claude/claude_desktop_config.json
```

## 🔄 Next Steps

1. **Restart Claude Desktop** to activate all new servers
2. **Test the servers** using the examples above
3. **Use MCP Inspector** to debug and monitor connections
4. **Build custom servers** using the Python or TypeScript SDKs

## 💡 Pro Tips

1. **Memory Server**: Use it to maintain context across sessions
2. **Sequential Thinking**: Great for complex problem decomposition
3. **Fetch + AgentQL**: Powerful combo for web data extraction
4. **Everything**: Fastest file search available
5. **Time Server**: No more timezone confusion!

## 🐛 Debugging with Inspector

```bash
# List all available MCP servers
mcp-inspector list

# Test a specific server
mcp-inspector test server-memory

# Monitor real-time communication
mcp-inspector monitor --server server-fetch

# Debug connection issues
mcp-inspector debug --verbose
```

---

**Remember to restart Claude Desktop to activate these new capabilities!**
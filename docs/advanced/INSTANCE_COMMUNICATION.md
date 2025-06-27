# Instance Communication Guide

This guide explains how to communicate between different Neovim instances using the MCP Neovim Listen Server.

## Overview

The MCP server enables powerful inter-instance communication through multiple channels:
- Direct port-specific commands
- Broadcast messaging to all instances
- Orchestra mode for coordinated editing
- Shared clipboard and data exchange

## Communication Methods

### 1. Direct Instance Communication

Each Neovim instance runs on a specific port and can receive targeted commands:

```javascript
// Send to main editor (port 7001)
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":echo 'Message to main editor'<CR>"
});

// Send to navigator (port 7002)
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7002,
  "command": ":echo 'Message to navigator'<CR>"
});

// Send to broadcast instance (port 7777)
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7777,
  "command": ":echo 'Status update'<CR>"
});
```

### 2. Broadcast Messaging

Send messages to all instances simultaneously through the broadcast system:

```javascript
// Information broadcast
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Syncing all editors...",
  "messageType": "info"
});

// Command broadcast (executes in all instances)
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": ":w",  // Save all files
  "messageType": "command"
});

// Warning broadcast
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Build failed - check errors",
  "messageType": "warning"
});

// Error broadcast
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Critical: Database connection lost",
  "messageType": "error"
});
```

### 3. Orchestra Mode

Coordinate multiple instances for complex workflows:

```javascript
// Start full orchestra (3 instances)
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "full",
  "ports": [7777, 7778, 7779]
});

// Start dual setup
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "dual",
  "ports": [7777, 7778]
});

// Broadcast commands to all orchestra instances
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "gg=G",  // Format all files
  "messageType": "command"
});
```

## Communication Patterns

### Status Updates Pattern

Use port 7777 as a dedicated status display:

```javascript
// Send progress updates
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7777,
  "command": ":echo 'Step 1/5: Initializing...'<CR>"
});

// Update with completion
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7777,
  "command": ":echo 'Step 1/5: ✓ Complete'<CR>"
});
```

### Synchronized Editing Pattern

Open and edit the same content across instances:

```javascript
// Open same file in multiple instances
const ports = [7001, 7002];
const filepath = "/path/to/shared/file.js";

for (const port of ports) {
  await use_mcp_tool("nvimlisten", "neovim-open-file", {
    "port": port,
    "filepath": filepath
  });
}

// Make synchronized changes
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": ":%s/oldFunction/newFunction/g",
  "messageType": "command"
});
```

### Cross-Instance Data Sharing

Transfer content between instances using the system clipboard:

```javascript
// Copy from source instance
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "ggVG\"+y"  // Copy entire file to system clipboard
});

// Paste to target instance
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7002,
  "command": ":enew<CR>\"+p"  // New buffer and paste
});
```

### Multi-File Coordination

Work with related files across instances:

```javascript
// Open MVC components in different instances
const files = {
  7001: "src/models/user.js",      // Model in main editor
  7002: "src/views/user-view.js",  // View in navigator
  7777: "src/controllers/user.js"  // Controller in broadcast
};

for (const [port, filepath] of Object.entries(files)) {
  await use_mcp_tool("nvimlisten", "neovim-open-file", {
    "port": parseInt(port),
    "filepath": filepath
  });
}
```

## Real-World Workflows

### Code Review Workflow

Compare versions across instances:

```javascript
// 1. Current version in main editor
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/component.jsx"
});

// 2. Previous version in navigator
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7002,
  "command": ":Git show HEAD~1:src/component.jsx<CR>"
});

// 3. Status in broadcast
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Comparing current vs previous version",
  "messageType": "info"
});

// 4. Diff view
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":diffthis<CR>"
});

await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7002,
  "command": ":diffthis<CR>"
});
```

### Refactoring Workflow

Coordinate changes across multiple files:

```javascript
// 1. Create session backup
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "pre-refactor"
});

// 2. Open affected files
const refactorFiles = [
  "src/utils/helper.js",
  "src/components/Button.jsx",
  "src/services/api.js"
];

// Distribute files across instances
refactorFiles.forEach((file, index) => {
  const port = [7001, 7002, 7777][index % 3];
  await use_mcp_tool("nvimlisten", "neovim-open-file", {
    "port": port,
    "filepath": file
  });
});

// 3. Broadcast refactor command
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": ":%s/oldAPICall/newAPICall/gc",
  "messageType": "command"
});

// 4. Save all
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": ":wa",
  "messageType": "command"
});
```

### Testing Workflow

Run tests and display results:

```javascript
// 1. Open test file
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "tests/component.test.js"
});

// 2. Run tests in terminal
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test component.test.js"
});

// 3. Broadcast results
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Tests completed: 15 passed, 0 failed",
  "messageType": "info"
});

// 4. Open coverage report
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "coverage/lcov-report/index.html"
});
```

## Best Practices

### 1. Port Assignment Convention
- **Port 7001**: Main editor for primary work
- **Port 7002**: Navigator for references and comparisons
- **Port 7777**: Broadcast for status and logs
- **Ports 7778-7779**: Additional instances for orchestra mode

### 2. Message Type Guidelines
- **info**: General status updates, progress indicators
- **command**: Vim commands to execute
- **warning**: Non-critical issues or cautions
- **error**: Critical problems requiring attention

### 3. Performance Considerations
- Batch related commands together
- Use broadcast for simultaneous updates
- Avoid rapid successive commands to same instance
- Allow time for complex operations to complete

### 4. Error Handling
```javascript
try {
  await use_mcp_tool("nvimlisten", "neovim-connect", {
    "port": 7001,
    "command": ":echo 'Test connection'<CR>"
  });
} catch (error) {
  // Instance not available, start it
  await use_mcp_tool("nvimlisten", "start-environment", {
    "layout": "enhanced"
  });
}
```

## Advanced Techniques

### Dynamic Port Selection
```javascript
const activePorts = [7001, 7002, 7777];
const availablePort = activePorts.find(async (port) => {
  try {
    await use_mcp_tool("nvimlisten", "neovim-connect", {
      "port": port,
      "command": ":echo 'ping'<CR>"
    });
    return true;
  } catch {
    return false;
  }
});
```

### Message Queuing
```javascript
const messages = [
  "Starting build process...",
  "Compiling TypeScript...",
  "Running tests...",
  "Build complete!"
];

for (const [index, message] of messages.entries()) {
  await use_mcp_tool("nvimlisten", "broadcast-message", {
    "message": `[${index + 1}/${messages.length}] ${message}`,
    "messageType": "info"
  });
  // Add delay if needed
  await new Promise(resolve => setTimeout(resolve, 1000));
}
```

### Instance State Synchronization
```javascript
// Get current directory from all instances
const ports = [7001, 7002, 7777];
for (const port of ports) {
  await use_mcp_tool("nvimlisten", "neovim-connect", {
    "port": port,
    "command": ":pwd<CR>"
  });
}
```

## Troubleshooting

### Instance Not Responding
```javascript
// Check if instance is alive
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":echo serverlist()<CR>"
});
```

### Broadcast Not Working
```javascript
// Verify broadcast instance
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7777,
  "command": ":echo 'Broadcast test'<CR>"
});
```

### Commands Not Executing
```javascript
// Add explicit carriage return
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":source $MYVIMRC<CR>"  // Always include <CR>
});
```

## Conclusion

The MCP Neovim Listen Server provides powerful instance communication capabilities that enable sophisticated multi-editor workflows. By leveraging direct communication, broadcasting, and orchestra mode, you can create highly efficient development environments that coordinate seamlessly across multiple Neovim instances.

Remember to follow the port conventions, use appropriate message types, and handle errors gracefully for the best experience.
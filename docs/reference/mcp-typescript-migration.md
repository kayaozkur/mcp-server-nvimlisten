# MCP Server TypeScript Migration Guide

This document describes the migration from uvx-based MCP servers to their TypeScript/npx equivalents.

## Migration Summary

### Successfully Migrated (3 servers)

1. **server-sequentialthinking**
   - **Old**: `uvx @modelcontextprotocol/server-sequentialthinking`
   - **New**: `npx -y @modelcontextprotocol/server-sequential-thinking`
   - **Status**: ✅ Migrated to TypeScript version

2. **agentql-mcp**
   - **Old**: `uvx @tinyfish-io/agentql-mcp`
   - **New**: `npx -y agentql-mcp`
   - **Status**: ✅ Migrated to TypeScript version
   - **Note**: Requires `AGENTQL_API_KEY` environment variable

3. **agentrpc**
   - **Old**: `uvx @agentrpc/agentrpc`
   - **New**: `npx agentrpc mcp`
   - **Status**: ✅ Migrated to TypeScript version
   - **Note**: Requires `AGENTRPC_API_SECRET` environment variable

### Not Available in TypeScript (3 servers)

These servers remain on uvx as no TypeScript/npm equivalents are available:

1. **server-git**
   - **Current**: `uvx @modelcontextprotocol/server-git`
   - **Alternative**: Consider using filesystem operations with git commands

2. **server-time**
   - **Current**: `uvx @modelcontextprotocol/server-time`
   - **Alternative**: Could be implemented as custom MCP server using `@modelcontextprotocol/sdk`

3. **server-fetch**
   - **Current**: `uvx @modelcontextprotocol/server-fetch`
   - **Alternative**: Could be implemented as custom MCP server using `@modelcontextprotocol/sdk`

## Configuration Changes

The following changes were made to `/Users/kayaozkur/Library/Application Support/Claude/claude_desktop_config.json`:

```json
// Before
"server-sequentialthinking": {
  "command": "uvx",
  "args": ["@modelcontextprotocol/server-sequentialthinking"]
}

// After
"server-sequentialthinking": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
}
```

## Benefits of TypeScript Migration

1. **Consistency**: More servers now use the same runtime (Node.js)
2. **Performance**: npx caching can improve startup times
3. **Ecosystem**: Better integration with JavaScript/TypeScript tooling
4. **Maintenance**: Easier to maintain and debug TypeScript-based servers

## Next Steps

For the remaining uvx-based servers without TypeScript equivalents:

1. **Monitor official releases** for TypeScript versions
2. **Consider custom implementations** using `@modelcontextprotocol/sdk`
3. **Keep uvx installed** for servers that require it

## Verification

After migration, restart Claude desktop app and verify all servers are working:

1. Check Claude's MCP server status
2. Test each migrated server's functionality
3. Monitor for any connection errors

A backup of the original configuration has been created with timestamp.
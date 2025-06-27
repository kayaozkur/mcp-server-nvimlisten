# Documentation Structure

This directory contains all documentation for the MCP Server Neovim Listen project. The documentation is organized into categories for easy navigation.

## 📁 Directory Structure

```
docs/
├── getting-started/       # Quick start guides and tutorials
├── guides/               # How-to guides and workflows
│   └── environment/      # Environment setup and configuration
├── api/                  # API documentation and references
├── reference/            # Technical references and specifications
├── advanced/             # Advanced features and techniques
├── ecosystem/            # MCP ecosystem and integrations
└── troubleshooting/      # Problem solving and debugging
```

## 🔄 Automatic Index Generation

The `index.md` file is automatically generated based on the contents of this directory. 

To update the index:
```bash
npm run docs:index
```

To watch for changes and auto-update:
```bash
npm run docs:watch
```

## 📝 Adding New Documentation

1. Place your markdown file in the appropriate category directory
2. Use a descriptive filename (e.g., `feature-name-guide.md`)
3. Start your document with a level-1 heading (`# Title`)
4. Run `npm run docs:index` to update the main index

## 🏷️ Categories

- **getting-started**: Installation, setup, and beginner tutorials
- **guides**: Step-by-step guides for specific tasks
- **api**: API references and tool documentation
- **reference**: Technical specifications and quick references
- **advanced**: Complex features and advanced usage patterns
- **ecosystem**: MCP ecosystem, integrations, and related tools
- **troubleshooting**: Common problems and their solutions

## 🤖 GitHub Actions

A GitHub Action automatically updates the documentation index when:
- Any markdown file in the docs directory is added or modified
- The index generation script is updated

This ensures the documentation index always reflects the current state of the documentation.

## 📚 Documentation Structure

### Getting Started
- **[Tutorial](getting-started/tutorial.md)** - Step-by-step guide from basics to advanced
- **[Setup Guide](getting-started/Setup%20Guide.md)** - Installation and configuration
- **[Quick Reference](reference/Quick%20Reference.md)** - Common commands at a glance

### API Reference
- **[Complete API Reference](api/API.md)** - Comprehensive documentation of all MCP tools
- **[MCP Tools API](api/MCP_TOOLS_API.md)** - Detailed tool specifications
- **[API Reference](api/API%20Reference.md)** - Quick API overview

### Usage & Workflows
- **[Usage Examples](guides/USAGE_EXAMPLES.md)** - Practical examples for common tasks
- **[Workflows](guides/WORKFLOWS.md)** - Advanced workflow patterns
- **[Multi-Instance Guide](advanced/Multi-Instance%20Guide.md)** - Orchestrating multiple Neovim instances
- **[Instance Communication](advanced/INSTANCE_COMMUNICATION.md)** - Communication between Neovim instances

### Integration & Advanced Patterns
- **[Integrated Workflows](advanced/INTEGRATED_WORKFLOWS.md)** 🆕 - Combining Neovim Listen with other MCP servers
- **[Enhanced Development Patterns](advanced/ENHANCED_DEVELOPMENT_PATTERNS.md)** 🆕 - Advanced patterns using multiple MCP servers
- **[New MCP Servers](ecosystem/NEW_MCP_SERVERS.md)** 🆕 - Comprehensive guide to 7 new MCP servers
- **[MCP Ecosystem](ecosystem/MCP_ECOSYSTEM.md)** 🆕 - How all 16 servers work together
- **[CLAUDE.md](../CLAUDE.md)** - Claude-specific integration guide

### Configuration & Customization
- **[Port Configuration](reference/Port%20Configuration.md)** - Understanding port conventions
- **[Keybindings Reference](reference/Keybindings%20Reference.md)** - Available keyboard shortcuts

### Troubleshooting & Testing
- **[Troubleshooting Guide](troubleshooting/TROUBLESHOOTING_GUIDE.md)** - Solutions to common problems
- **[Testing Guide](guides/Testing%20Guide.md)** - Testing the server

## 🚀 Quick Start Path

1. **New Users**: Start with [Tutorial](getting-started/tutorial.md) → [Usage Examples](guides/USAGE_EXAMPLES.md)
2. **Experienced Users**: Jump to [API Reference](api/API.md) → [Workflows](guides/WORKFLOWS.md)
3. **Advanced Users**: Explore [Integrated Workflows](advanced/INTEGRATED_WORKFLOWS.md) → [Enhanced Development Patterns](advanced/ENHANCED_DEVELOPMENT_PATTERNS.md)

## 🎯 Common Use Cases

### For Development
- Code editing with multi-file support
- Integrated terminal for running tests
- Git integration and workflow
- Plugin management

### For Code Review
- Side-by-side file comparison
- Navigation between implementation and tests
- Quick search across codebase
- Session management for review states

### For Learning
- Interactive command exploration
- Configuration experimentation
- Keybinding discovery
- Plugin exploration

## 💡 Key Concepts

### Port Convention
- **7001**: Main editor window
- **7002**: Navigator/file browser
- **7003**: Reference documentation
- **7777-7779**: Orchestra instances

### Environment Layouts
- **Enhanced**: Full-featured 9-pane layout
- **Minimal**: Simple editor + terminal
- **Orchestra**: Multi-instance coordination

### Tool Categories
1. **Connection Tools**: Direct Neovim control
2. **Terminal Tools**: Command execution
3. **Configuration Tools**: Settings management
4. **Plugin Tools**: Extension management
5. **Orchestra Tools**: Multi-instance coordination
6. **Session Tools**: State management

## 🔍 Finding Information

- **Looking for a specific tool?** → [API Reference](api/API.md)
- **Need step-by-step instructions?** → [Tutorial](getting-started/tutorial.md)
- **Having problems?** → [Troubleshooting](troubleshooting/TROUBLESHOOTING_GUIDE.md)
- **Want practical examples?** → [Usage Examples](guides/USAGE_EXAMPLES.md)
- **Setting up for the first time?** → [Setup Guide](getting-started/Setup%20Guide.md)

## 🆕 What's New

### Enhanced MCP Server Integration
The server now includes comprehensive documentation for integrating with all 16 MCP servers:

**Original MCP Servers:**
- **Brave Search**: Research while coding
- **Memory Server**: Persistent context across sessions
- **Time Server**: Productivity tracking and Pomodoro
- **Fetch Server**: API integration and testing
- **Sequential Thinking**: Step-by-step problem solving
- **Everything Server**: Fast file operations
- **AgentQL**: Web scraping and automation
- **AgentRPC**: Microservice communication
- **Filesystem**: File system operations

**New MCP Servers (7 additions):**
- **server-time**: Advanced time and timezone operations
- **server-fetch**: HTTP requests with retry and auth
- **server-memory**: Persistent knowledge storage
- **server-sequentialthinking**: Step-by-step problem solving
- **server-everything**: Ultra-fast file search
- **agentql-mcp**: Intelligent web scraping
- **agentrpc**: Remote function calls

📖 **Documentation:**
- [New MCP Servers](NEW_MCP_SERVERS.md) - Detailed guide for the 7 new servers
- [MCP Ecosystem](MCP_ECOSYSTEM.md) - How all 16 servers work together
- [Integrated Workflows](INTEGRATED_WORKFLOWS.md) - Multi-server workflows
- [Enhanced Development Patterns](ENHANCED_DEVELOPMENT_PATTERNS.md) - Advanced patterns

## 📝 Documentation Standards

All documentation in this project follows these standards:
- Clear, concise explanations
- Practical, working examples
- Consistent formatting
- Regular updates with new features
- User feedback incorporation

## 🤝 Contributing to Documentation

Found an error or want to improve the docs? 
1. Check existing documentation
2. Follow the established format
3. Include working examples
4. Test all code snippets
5. Submit a pull request

## 📞 Support

If you can't find what you need:
1. Check all documentation sections
2. Review the [FAQ](TROUBLESHOOTING_GUIDE.md#faq)
3. Search [GitHub Issues](https://github.com/yourusername/mcp-server-nvimlisten/issues)
4. Create a new issue with details

---

Happy coding with MCP Neovim Listen Server! 🚀
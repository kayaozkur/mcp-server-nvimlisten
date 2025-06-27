# MCP Server Neovim Listen - Common Workflows

This guide provides step-by-step workflows for common development tasks using the MCP Server Neovim Listen.

## Table of Contents

1. [Development Workflows](#development-workflows)
2. [Code Review Workflow](#code-review-workflow)
3. [Debugging Workflow](#debugging-workflow)
4. [Refactoring Workflow](#refactoring-workflow)
5. [Testing Workflow](#testing-workflow)
6. [Documentation Workflow](#documentation-workflow)
7. [Git Workflow](#git-workflow)
8. [Multi-Project Workflow](#multi-project-workflow)
9. [Performance Optimization Workflow](#performance-optimization-workflow)
10. [Plugin Development Workflow](#plugin-development-workflow)

---

## Development Workflows

### New Feature Development

**Scenario**: Implementing a new user authentication feature

```javascript
// Step 1: Start environment and create session
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"
});

await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "feature-auth"
});

// Step 2: Create feature branch
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git checkout -b feature/user-authentication"
});

// Step 3: Open relevant files
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/auth/index.js"
});

await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "docs/auth-requirements.md"
});

// Step 4: Create new files
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "mkdir -p src/auth/components src/auth/services"
});

// Step 5: Start development server
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm run dev"
});

// Step 6: Broadcast status
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Starting authentication feature development",
  "messageType": "info"
});
```

### Bug Fixing Workflow

**Scenario**: Fixing a critical bug in production

```javascript
// Step 1: Create bug fix session
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "bugfix-prod-issue-123"
});

// Step 2: Checkout hotfix branch
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git checkout -b hotfix/issue-123"
});

// Step 3: Search for error in codebase
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope live_grep<CR>"
});
// User searches for error message

// Step 4: Open problematic file
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/services/payment.js",
  "line": 156
});

// Step 5: Run tests to reproduce
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test src/services/payment.test.js -- --watch"
});

// Step 6: Fix the bug (user makes changes)

// Step 7: Verify fix
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test src/services/payment.test.js"
});

// Step 8: Commit fix
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git add -A && git commit -m 'fix: resolve payment processing error (fixes #123)'"
});
```

---

## Code Review Workflow

**Scenario**: Reviewing a pull request with multiple changed files

```javascript
// Step 1: Setup orchestra mode for review
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "full",
  "ports": [7777, 7778, 7779]
});

// Step 2: Fetch PR changes
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git fetch origin pull/42/head:pr-42 && git checkout pr-42"
});

// Step 3: Get list of changed files
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git diff --name-only main..pr-42 > /tmp/changed-files.txt"
});

// Step 4: Open changed files in different instances
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7777,
  "filepath": "src/components/UserProfile.jsx"
});

await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7778,
  "filepath": "src/services/userService.js"
});

// Step 5: Open review notes
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7779,
  "filepath": "/tmp/pr-42-review.md"
});

// Step 6: Add review header
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7779,
  "command": "i# PR #42 Review Notes\n\n## Overview\n- [ ] Code quality\n- [ ] Tests coverage\n- [ ] Documentation\n\n## Comments\n\n<Esc>"
});

// Step 7: Run tests for PR
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test"
});

// Step 8: Check linting
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm run lint"
});

// Step 9: Broadcast review status
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Code review in progress for PR #42",
  "messageType": "info"
});
```

---

## Debugging Workflow

**Scenario**: Debugging a complex issue with multiple breakpoints

```javascript
// Step 1: Setup debugging environment
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "debug-session"
});

// Step 2: Install debugging plugin if needed
await use_mcp_tool("nvimlisten", "manage-plugin", {
  "action": "install",
  "pluginName": "mfussenegger/nvim-dap",
  "config": "{}"
});

// Step 3: Open files for debugging
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/api/routes.js"
});

await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "src/api/middleware.js"
});

// Step 4: Set breakpoints
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "42G:lua require('dap').toggle_breakpoint()<CR>"
});

await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "78G:lua require('dap').toggle_breakpoint()<CR>"
});

// Step 5: Start debug server
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "node --inspect-brk src/server.js"
});

// Step 6: Attach debugger
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":lua require('dap').continue()<CR>"
});

// Step 7: Monitor logs in broadcast
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Debugging session active - monitoring breakpoints",
  "messageType": "info"
});
```

---

## Refactoring Workflow

**Scenario**: Refactoring a large module into smaller components

```javascript
// Step 1: Create refactoring session with backup
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "refactor-user-module"
});

// Step 2: Create backup branch
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git checkout -b refactor/split-user-module"
});

// Step 3: Analyze current structure
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/modules/user.js"
});

// Step 4: Create new directory structure
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "mkdir -p src/modules/user/{controllers,services,models,utils}"
});

// Step 5: Open multiple files for refactoring
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "full"
});

// Original file
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7777,
  "filepath": "src/modules/user.js"
});

// New controller file
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7778,
  "filepath": "src/modules/user/controllers/userController.js"
});

// New service file
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7779,
  "filepath": "src/modules/user/services/userService.js"
});

// Step 6: Run tests continuously
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test -- --watch"
});

// Step 7: Update imports across codebase
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope live_grep<CR>"
});
// Search for: require('./modules/user')

// Step 8: Verify refactoring
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm run lint && npm test"
});

// Step 9: Commit changes
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git add -A && git commit -m 'refactor: split user module into separate concerns'"
});
```

---

## Testing Workflow

**Scenario**: Writing and running tests for new functionality

```javascript
// Step 1: Setup testing environment
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/utils/validator.js"
});

await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "tests/utils/validator.test.js"
});

// Step 2: Run tests in watch mode
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test tests/utils/validator.test.js -- --watch"
});

// Step 3: Create test structure
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7002,
  "command": "idescribe('Validator', () => {\n  describe('email validation', () => {\n    it('should validate correct email', () => {\n      // Test implementation\n    });\n  });\n});<Esc>"
});

// Step 4: Run coverage report
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test -- --coverage"
});

// Step 5: Open coverage report
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "open coverage/lcov-report/index.html"
});

// Step 6: Broadcast test results
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "✅ All tests passing - Coverage: 92%",
  "messageType": "info"
});
```

---

## Documentation Workflow

**Scenario**: Updating project documentation

```javascript
// Step 1: Open documentation files
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "README.md"
});

await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "docs/API.md"
});

// Step 2: Generate API documentation
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npx jsdoc src -r -d docs/generated"
});

// Step 3: Preview markdown
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":MarkdownPreview<CR>"
});

// Step 4: Check for broken links
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npx markdown-link-check README.md"
});

// Step 5: Update table of contents
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":GenTocGFM<CR>"
});

// Step 6: Commit documentation
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git add docs/ README.md && git commit -m 'docs: update API documentation'"
});
```

---

## Git Workflow

**Scenario**: Managing git operations efficiently

```javascript
// Step 1: Check current status
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git status"
});

// Step 2: Review changes in Neovim
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git diff > /tmp/current-diff.txt"
});

await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "/tmp/current-diff.txt"
});

// Step 3: Stage specific files
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Git add %<CR>"  // Stage current file
});

// Step 4: Interactive staging
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git add -p"
});

// Step 5: Commit with detailed message
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git commit"
});

// Step 6: Push with tracking
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git push -u origin feature/new-feature"
});

// Step 7: Create pull request
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "gh pr create --title 'Add new feature' --body 'Description of changes'"
});
```

---

## Multi-Project Workflow

**Scenario**: Working on multiple related projects simultaneously

```javascript
// Step 1: Use project switcher
await use_mcp_tool("nvimlisten", "project-switcher", {});

// Step 2: Open projects in different instances
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "full"
});

// Frontend project
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "cd ~/projects/app-frontend"
});

await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7777,
  "filepath": "~/projects/app-frontend/src/App.jsx"
});

// Backend project
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7778,
  "filepath": "~/projects/app-backend/src/server.js"
});

// Shared library
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7779,
  "filepath": "~/projects/app-shared/index.js"
});

// Step 3: Start development servers
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "cd ~/projects/app-frontend && npm run dev"
});

// Step 4: Link shared library
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "cd ~/projects/app-shared && npm link"
});

// Step 5: Monitor all projects
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Multi-project development environment active",
  "messageType": "info"
});
```

---

## Performance Optimization Workflow

**Scenario**: Optimizing application performance

```javascript
// Step 1: Profile current performance
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm run build -- --profile"
});

// Step 2: Analyze bundle size
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm run analyze"
});

// Step 3: Check Neovim startup time
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":StartupTime<CR>"
});

// Step 4: Profile plugin load times
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Lazy profile<CR>"
});

// Step 5: Find slow code
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope live_grep<CR>"
});
// Search for: console.time

// Step 6: Run performance tests
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm run test:performance"
});

// Step 7: Generate lighthouse report
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npx lighthouse http://localhost:3000 --view"
});

// Step 8: Document improvements
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "docs/performance-improvements.md"
});
```

---

## Plugin Development Workflow

**Scenario**: Developing a custom Neovim plugin

```javascript
// Step 1: Create plugin structure
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "mkdir -p ~/.config/nvim/lua/custom-plugin/{init,config,utils}"
});

// Step 2: Open plugin files
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "~/.config/nvim/lua/custom-plugin/init.lua"
});

// Step 3: Create plugin skeleton
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "ilocal M = {}\n\nfunction M.setup(opts)\n  opts = opts or {}\n  -- Plugin setup\nend\n\nreturn M<Esc>"
});

// Step 4: Test plugin loading
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":source %<CR>"
});

// Step 5: Add to plugin manager
await use_mcp_tool("nvimlisten", "set-nvim-config", {
  "configType": "plugins",
  "content": "{ 'custom-plugin', config = function() require('custom-plugin').setup() end }",
  "backup": true
});

// Step 6: Reload and test
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Lazy reload custom-plugin<CR>"
});

// Step 7: Create documentation
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "~/.config/nvim/lua/custom-plugin/README.md"
});
```

---

## Integration with Other MCP Servers

The workflows above can be enhanced by integrating with other MCP servers:

### With Brave Search
- Research best practices before implementing features
- Find documentation and examples while coding
- Search for error messages and solutions

### With Memory Server
- Persist session context across restarts
- Track decisions and reasoning for features
- Maintain project-specific knowledge bases

### With Time Server
- Implement Pomodoro technique for focused work
- Track time spent on different features
- Set reminders for code reviews and breaks

### With Fetch Server
- Test APIs directly from Neovim
- Fetch documentation and incorporate into code
- Validate external endpoints during development

### With Sequential Thinking
- Break down complex refactoring tasks
- Debug issues step by step
- Plan feature implementation systematically

See [Integrated Workflows](INTEGRATED_WORKFLOWS.md) for detailed examples of combining these servers.

## Best Practices Summary

1. **Always create sessions** before starting major work
2. **Use orchestra mode** for complex multi-file operations
3. **Leverage the broadcast pane** for status updates and logging
4. **Run tests continuously** during development
5. **Backup configurations** before making changes
6. **Use the terminal bridge** for visible command execution
7. **Document your workflow** for team consistency
8. **Integrate with other MCP servers** for enhanced capabilities

These workflows can be adapted and combined based on your specific needs. The key is to leverage the multi-instance capabilities and terminal integration to create an efficient development environment.
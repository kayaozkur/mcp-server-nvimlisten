#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Configuration
const docsDir = path.join(__dirname, '..', 'docs');
const indexPath = path.join(docsDir, 'index.md');

// Category mappings for better organization
const categoryMappings = {
  'getting-started': {
    title: 'Getting Started',
    description: 'Quick start guides and tutorials',
    priority: 1
  },
  'guides': {
    title: 'User Guides', 
    description: 'How-to guides and workflows',
    priority: 2
  },
  'api': {
    title: 'API Documentation',
    description: 'API documentation and references',
    priority: 3
  },
  'reference': {
    title: 'Reference Materials',
    description: 'Technical references and specifications',
    priority: 4
  },
  'advanced': {
    title: 'Advanced Features',
    description: 'Advanced features and techniques',
    priority: 5
  },
  'ecosystem': {
    title: 'MCP Ecosystem',
    description: 'MCP ecosystem and integrations',
    priority: 6
  },
  'troubleshooting': {
    title: 'Troubleshooting',
    description: 'Problem solving and debugging',
    priority: 7
  }
};

// Subcategory mappings
const subcategoryMappings = {
  'environment': 'Environment Configuration'
};

// Files to ignore
const ignoreFiles = [
  'index.md',
  '.DS_Store',
  'README.md' // We'll handle README separately
];

// Function to get all markdown files in a directory
function getMarkdownFiles(dir, basePath = '') {
  const files = [];
  const items = fs.readdirSync(dir);

  items.forEach(item => {
    const fullPath = path.join(dir, item);
    const relativePath = path.join(basePath, item);
    const stat = fs.statSync(fullPath);

    if (stat.isDirectory()) {
      const subFiles = getMarkdownFiles(fullPath, relativePath);
      files.push(...subFiles);
    } else if (item.endsWith('.md') && !ignoreFiles.includes(item)) {
      files.push({
        path: relativePath,
        name: item.replace('.md', ''),
        title: getTitle(fullPath) || item.replace('.md', '').replace(/-/g, ' ')
      });
    } else if (item.endsWith('.txt') && item === 'claude_communication.txt') {
      files.push({
        path: relativePath,
        name: item,
        title: 'Claude Communication Reference'
      });
    }
  });

  return files;
}

// Function to extract title from markdown file
function getTitle(filePath) {
  try {
    const content = fs.readFileSync(filePath, 'utf8');
    const lines = content.split('\n');
    for (const line of lines) {
      if (line.startsWith('# ')) {
        return line.substring(2).trim();
      }
    }
  } catch (err) {
    console.error(`Error reading ${filePath}:`, err);
  }
  return null;
}

// Function to organize files by category
function organizeFilesByCategory(files) {
  const organized = {};

  files.forEach(file => {
    const parts = file.path.split(path.sep);
    const category = parts[0];
    const subcategory = parts.length > 2 ? parts[1] : null;

    if (!organized[category]) {
      organized[category] = {
        files: [],
        subcategories: {}
      };
    }

    if (subcategory) {
      if (!organized[category].subcategories[subcategory]) {
        organized[category].subcategories[subcategory] = [];
      }
      organized[category].subcategories[subcategory].push(file);
    } else {
      organized[category].files.push(file);
    }
  });

  return organized;
}

// Function to generate markdown link
function generateLink(file, baseDir = '') {
  const encodedPath = file.path.split(path.sep).map(encodeURIComponent).join('/');
  return `- **[${file.title}](${encodedPath})** ${getDescription(file)}`;
}

// Function to get file description based on name
function getDescription(file) {
  const descriptions = {
    'Setup Guide': '- Installation and initial configuration',
    'tutorial': '- Step-by-step guide from basics to advanced',
    'mcp-integration-quick-guide': '- Fast track to MCP integration',
    'USAGE_EXAMPLES': '- Practical examples for common tasks',
    'WORKFLOWS': '- Advanced workflow patterns',
    'Testing Guide': '- Testing your MCP setup',
    'API': '- All available MCP tools',
    'API Reference': '- In-depth API documentation',
    'MCP_TOOLS_API': '- Tool specifications and schemas',
    'Quick Reference': '- Command cheat sheet',
    'Keybindings Reference': '- All keyboard shortcuts',
    'Port Configuration': '- Port conventions and layouts',
    'TROUBLESHOOTING': '- Common issues and solutions',
    'TROUBLESHOOTING_GUIDE': '- Complex problem solving'
  };

  return descriptions[file.name] || '';
}

// Main function to generate index
function generateIndex() {
  console.log('Generating documentation index...');

  const files = getMarkdownFiles(docsDir);
  const organized = organizeFilesByCategory(files);

  // Sort categories by priority
  const sortedCategories = Object.keys(organized).sort((a, b) => {
    const aPriority = categoryMappings[a]?.priority || 999;
    const bPriority = categoryMappings[b]?.priority || 999;
    return aPriority - bPriority;
  });

  // Generate index content
  let content = `# MCP Server Neovim Listen Documentation

Welcome to the official documentation for **MCP Server Neovim Listen** - a powerful Model Context Protocol (MCP) server that provides seamless integration between Claude and Neovim, enabling advanced text editing, code navigation, and development environment management.

> 📝 **Note**: This index is automatically generated. Run \`npm run docs:index\` to update it.

## 📁 Documentation Structure

\`\`\`
docs/
`;

  // Add directory tree
  sortedCategories.forEach(category => {
    const info = categoryMappings[category];
    const padding = category === sortedCategories[sortedCategories.length - 1] ? '└── ' : '├── ';
    content += `${padding}${category}/`;
    if (info) {
      content += ` # ${info.description}`;
    }
    content += '\n';

    const subcategories = Object.keys(organized[category].subcategories);
    if (subcategories.length > 0) {
      subcategories.forEach((sub, idx) => {
        const subPadding = category === sortedCategories[sortedCategories.length - 1] ? '    ' : '│   ';
        const subPrefix = idx === subcategories.length - 1 ? '└── ' : '├── ';
        content += `${subPadding}${subPrefix}${sub}/`;
        if (subcategoryMappings[sub]) {
          content += ` # ${subcategoryMappings[sub]}`;
        }
        content += '\n';
      });
    }
  });

  content += `\`\`\`

## 🚀 Quick Start

New to MCP Server Neovim Listen? Start here:

`;

  // Add getting started links
  if (organized['getting-started']) {
    const gettingStartedFiles = organized['getting-started'].files.sort((a, b) => {
      const order = ['Setup Guide', 'tutorial', 'mcp-integration-quick-guide'];
      return order.indexOf(a.name) - order.indexOf(b.name);
    });

    gettingStartedFiles.forEach((file, idx) => {
      content += `${idx + 1}. **[${file.title}](${encodeURIComponent('getting-started')}/${encodeURIComponent(file.name + '.md')})** ${getDescription(file)}\n`;
    });
  }

  content += '\n## 📚 Documentation by Category\n\n';

  // Generate sections for each category
  sortedCategories.forEach(category => {
    const info = categoryMappings[category];
    if (!info) return;

    content += `### ${info.title}\n\n`;

    // Add category files
    if (organized[category].files.length > 0) {
      organized[category].files.forEach(file => {
        content += generateLink(file) + '\n';
      });
      content += '\n';
    }

    // Add subcategories
    Object.entries(organized[category].subcategories).forEach(([subcat, files]) => {
      if (files.length > 0) {
        content += `#### ${subcategoryMappings[subcat] || subcat.charAt(0).toUpperCase() + subcat.slice(1)}\n`;
        files.forEach(file => {
          content += generateLink(file) + '\n';
        });
        content += '\n';
      }
    });
  });

  // Add quick links section
  content += `## 🎯 Quick Links by Use Case

### I want to...

#### Set up MCP Server Neovim Listen
→ Start with [Setup Guide](getting-started/Setup%20Guide.md) then follow the [Tutorial](getting-started/tutorial.md)

#### Edit files with Claude
→ See [Usage Examples](guides/USAGE_EXAMPLES.md) → File Operations section

#### Manage Neovim plugins
→ Check [API Reference](api/API.md) → Plugin Management Tools

#### Work with multiple files
→ Read [Multi-Instance Guide](advanced/Multi-Instance%20Guide.md)

#### Debug connection issues
→ Visit [Troubleshooting Guide](troubleshooting/TROUBLESHOOTING.md)

#### Understand the architecture
→ Review [Complete Environment Analysis](guides/environment/complete-environment-analysis.md)

## 🔧 Additional Resources

### Project Files
- **[README](../README.md)** - Project overview and quick start
- **[CHANGELOG](../CHANGELOG.md)** - Version history and updates
- **[CLAUDE.md](../CLAUDE.md)** - Claude AI integration instructions

### External Links
- [GitHub Repository](https://github.com/your-repo/mcp-server-nvimlisten)
- [MCP Protocol Documentation](https://modelcontextprotocol.io)
- [Neovim Documentation](https://neovim.io/doc/)

## 📝 Contributing

Found an issue or want to contribute? Please check our [GitHub repository](https://github.com/your-repo/mcp-server-nvimlisten) for contribution guidelines.

---

*Last updated: ${new Date().toISOString().split('T')[0]}*
*Generated automatically by \`scripts/generate-docs-index.js\`*
`;

  // Write the index file
  fs.writeFileSync(indexPath, content);
  console.log(`✅ Documentation index generated at ${indexPath}`);

  // Report statistics
  const totalFiles = files.length;
  console.log(`📊 Found ${totalFiles} documentation files across ${sortedCategories.length} categories`);
}

// Run the generator
generateIndex();
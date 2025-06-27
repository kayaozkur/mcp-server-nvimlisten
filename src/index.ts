#!/usr/bin/env node

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ErrorCode,
  ListToolsRequestSchema,
  McpError,
} from "@modelcontextprotocol/sdk/types.js";
import { execa } from "execa";
import * as path from "path";
import * as fs from "fs/promises";
import which from "which";

// Import handlers
import { ConfigHandler } from "./handlers/config-handler.js";
import { PluginHandler } from "./handlers/plugin-handler.js";
import { OrchestraHandler } from "./handlers/orchestra-handler.js";
import { KeybindingHandler } from "./handlers/keybinding-handler.js";
import { SessionHandler } from "./handlers/session-handler.js";
import { HealthHandler } from "./handlers/health-handler.js";

// Check if required tools are available
async function checkDependencies() {
  const required = ["nvim"];
  const optional = ["zellij", "tmux", "python3", "fzf", "rg", "fd"];
  const missing = [];
  const missingOptional = [];
  
  for (const tool of required) {
    try {
      await which(tool);
    } catch {
      missing.push(tool);
    }
  }
  
  for (const tool of optional) {
    try {
      await which(tool);
    } catch {
      missingOptional.push(tool);
    }
  }
  
  if (missing.length > 0) {
    console.error(`Missing required tools: ${missing.join(", ")}`);
    console.error("Please install them first.");
    process.exit(1);
  }
  
  if (missingOptional.length > 0) {
    console.error(`Missing optional tools (some features may not work): ${missingOptional.join(", ")}`);
  }
}

// Define our tools - combining both nvimlisten and nvim server capabilities
const TOOLS = {
  // Neovim Connection Tools (from nvimlisten)
  "neovim-connect": {
    description: "Connect to a running Neovim instance on a specific port",
    inputSchema: {
      type: "object",
      properties: {
        port: {
          type: "number",
          description: "Port number (7001, 7002, 7777, etc.)",
          default: 7001
        },
        command: {
          type: "string",
          description: "Neovim command to execute"
        }
      },
      required: ["command"]
    }
  },
  "neovim-open-file": {
    description: "Open a file in a specific Neovim instance",
    inputSchema: {
      type: "object",
      properties: {
        port: {
          type: "number",
          description: "Port number (7001, 7002, 7777, etc.)",
          default: 7001
        },
        filepath: {
          type: "string",
          description: "Path to the file to open"
        },
        line: {
          type: "number",
          description: "Optional line number to jump to"
        }
      },
      required: ["filepath"]
    }
  },
  
  // Terminal & Environment Tools
  "terminal-execute": {
    description: "Execute a command in the visible terminal using the bridge",
    inputSchema: {
      type: "object",
      properties: {
        command: {
          type: "string",
          description: "Command to execute in the terminal"
        }
      },
      required: ["command"]
    }
  },
  "command-palette": {
    description: "Open the interactive command palette with fzf",
    inputSchema: {
      type: "object",
      properties: {}
    }
  },
  "project-switcher": {
    description: "Open the project switcher to navigate between projects",
    inputSchema: {
      type: "object",
      properties: {}
    }
  },
  "start-environment": {
    description: "Start the Claude development environment with Zellij",
    inputSchema: {
      type: "object",
      properties: {
        layout: {
          type: "string",
          description: "Layout type to use",
          enum: ["enhanced", "minimal", "orchestra"],
          default: "enhanced"
        }
      }
    }
  },
  
  // Configuration Management (from nvim server)
  "get-nvim-config": {
    description: "Retrieve current Neovim configuration files and settings",
    inputSchema: {
      type: "object",
      properties: {
        configType: {
          type: "string",
          enum: ["init", "plugins", "mappings", "options", "all"],
          description: "Type of configuration to retrieve"
        },
        filePath: {
          type: "string",
          description: "Specific file path (optional)"
        }
      }
    }
  },
  "set-nvim-config": {
    description: "Update Neovim configuration files",
    inputSchema: {
      type: "object",
      properties: {
        configType: {
          type: "string",
          enum: ["init", "plugins", "mappings", "options"],
          description: "Type of configuration to update"
        },
        content: {
          type: "string",
          description: "New configuration content"
        },
        filePath: {
          type: "string",
          description: "Specific file path to update"
        },
        backup: {
          type: "boolean",
          default: true,
          description: "Create backup before updating"
        }
      },
      required: ["configType", "content"]
    }
  },
  
  // Plugin Management
  "list-plugins": {
    description: "List all installed Neovim plugins with their status",
    inputSchema: {
      type: "object",
      properties: {
        filter: {
          type: "string",
          description: "Filter plugins by name or category"
        },
        includeConfig: {
          type: "boolean",
          default: false,
          description: "Include plugin configuration details"
        }
      }
    }
  },
  "manage-plugin": {
    description: "Install, update, or remove plugins",
    inputSchema: {
      type: "object",
      properties: {
        action: {
          type: "string",
          enum: ["install", "update", "remove", "sync"],
          description: "Action to perform"
        },
        pluginName: {
          type: "string",
          description: "Name or URL of the plugin"
        },
        config: {
          type: "string",
          description: "Plugin configuration (for install)"
        }
      },
      required: ["action"]
    }
  },
  
  // Orchestra Functions
  "run-orchestra": {
    description: "Execute nvim-orchestra scripts for multi-instance coordination",
    inputSchema: {
      type: "object",
      properties: {
        mode: {
          type: "string",
          enum: ["full", "solo", "dual", "dev", "jupyter", "performance"],
          description: "Orchestra mode to run",
          default: "full"
        },
        ports: {
          type: "array",
          items: { type: "number" },
          description: "Custom ports to use",
          default: [7777, 7778, 7779]
        }
      }
    }
  },
  "broadcast-message": {
    description: "Broadcast messages to all Neovim instances",
    inputSchema: {
      type: "object",
      properties: {
        message: {
          type: "string",
          description: "Message to broadcast"
        },
        messageType: {
          type: "string",
          enum: ["info", "warning", "error", "command"],
          default: "info",
          description: "Type of message"
        }
      },
      required: ["message"]
    }
  },
  
  // Keybinding Management
  "get-keybindings": {
    description: "Retrieve keybinding documentation and current mappings",
    inputSchema: {
      type: "object",
      properties: {
        mode: {
          type: "string",
          enum: ["normal", "insert", "visual", "command", "all"],
          default: "all",
          description: "Vim mode for keybindings"
        },
        plugin: {
          type: "string",
          description: "Filter by specific plugin"
        },
        format: {
          type: "string",
          enum: ["json", "markdown", "table"],
          default: "json",
          description: "Output format"
        }
      }
    }
  },
  
  // Session Management
  "manage-session": {
    description: "Create, restore, or manage Neovim sessions",
    inputSchema: {
      type: "object",
      properties: {
        action: {
          type: "string",
          enum: ["create", "restore", "list", "delete"],
          description: "Session action to perform"
        },
        sessionName: {
          type: "string",
          description: "Name of the session"
        }
      },
      required: ["action"]
    }
  },
  
  // Health Check
  "health-check": {
    description: "Check system health and dependencies",
    inputSchema: {
      type: "object",
      properties: {}
    }
  }
};

class NvimListenServer {
  private server: Server;
  private scriptsDir: string;
  private configHandler: ConfigHandler;
  private pluginHandler: PluginHandler;
  private orchestraHandler: OrchestraHandler;
  private keybindingHandler: KeybindingHandler;
  private sessionHandler: SessionHandler;
  private healthHandler: HealthHandler;

  constructor() {
    this.server = new Server(
      {
        name: "mcp-server-nvimlisten",
        version: "0.1.0",
      },
      {
        capabilities: {
          tools: {},
          resources: {},
        },
      }
    );

    // Find scripts directory
    this.scriptsDir = path.join(__dirname, "..", "scripts");

    // Initialize handlers
    this.configHandler = new ConfigHandler();
    this.pluginHandler = new PluginHandler();
    this.orchestraHandler = new OrchestraHandler();
    this.keybindingHandler = new KeybindingHandler();
    this.sessionHandler = new SessionHandler();
    this.healthHandler = new HealthHandler();

    this.setupHandlers();
  }

  private async executeScript(scriptName: string, args: string[] = []): Promise<string> {
    const scriptPath = path.join(this.scriptsDir, scriptName);
    
    try {
      // Check if script exists
      await fs.access(scriptPath);
      
      const { stdout, stderr } = await execa("bash", [scriptPath, ...args]);
      
      if (stderr) {
        console.error(`Script stderr: ${stderr}`);
      }
      
      return stdout || "Command executed successfully";
    } catch (error: any) {
      throw new McpError(
        ErrorCode.InternalError,
        `Failed to execute script: ${error.message}`
      );
    }
  }

  private setupHandlers() {
    this.server.setRequestHandler(ListToolsRequestSchema, async () => ({
      tools: Object.entries(TOOLS).map(([name, tool]) => ({
        name,
        description: tool.description,
        inputSchema: tool.inputSchema,
      })),
    }));

    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args } = request.params;

      try {
        switch (name) {
          // Neovim Connection Tools
          case "neovim-connect": {
            const { port = 7001, command } = args as any;
            const { stdout } = await execa("nvim", [
              "--server",
              `127.0.0.1:${port}`,
              "--remote-send",
              command
            ]);
            return {
              content: [
                {
                  type: "text",
                  text: `Command sent to Neovim on port ${port}`,
                },
              ],
            };
          }

          case "neovim-open-file": {
            const { port = 7001, filepath, line } = args as any;
            let remoteArgs = ["--server", `127.0.0.1:${port}`, "--remote"];
            
            if (line) {
              remoteArgs.push(`+${line}`);
            }
            remoteArgs.push(filepath);
            
            await execa("nvim", remoteArgs);
            return {
              content: [
                {
                  type: "text",
                  text: `Opened ${filepath} in Neovim on port ${port}${line ? ` at line ${line}` : ""}`,
                },
              ],
            };
          }

          // Terminal & Environment Tools
          case "terminal-execute": {
            const { command } = args as any;
            const output = await this.executeScript("claude-terminal-bridge.sh", [command]);
            return {
              content: [
                {
                  type: "text",
                  text: output,
                },
              ],
            };
          }

          case "command-palette": {
            const output = await this.executeScript("claude-command-palette.sh");
            return {
              content: [
                {
                  type: "text",
                  text: output || "Command palette opened",
                },
              ],
            };
          }

          case "project-switcher": {
            const output = await this.executeScript("claude-project-switcher.sh");
            return {
              content: [
                {
                  type: "text",
                  text: output || "Project switcher opened",
                },
              ],
            };
          }

          case "start-environment": {
            const { layout = "enhanced" } = args as any;
            const scriptName = layout === "orchestra" ? "ultimate-orchestra.sh" : "start-claude-dev-enhanced.sh";
            const output = await this.executeScript(scriptName);
            return {
              content: [
                {
                  type: "text",
                  text: `Claude development environment started with ${layout} layout`,
                },
              ],
            };
          }

          // Configuration Management
          case "get-nvim-config":
            return await this.configHandler.getConfig(args);
          case "set-nvim-config":
            return await this.configHandler.setConfig(args);

          // Plugin Management
          case "list-plugins":
            return await this.pluginHandler.listPlugins(args);
          case "manage-plugin":
            return await this.pluginHandler.managePlugin(args);

          // Orchestra Functions
          case "run-orchestra": {
            const { mode = "full", ports = [7777, 7778, 7779] } = args as any;
            const scriptArgs = [mode, ...ports.map(String)];
            const output = await this.executeScript("ultimate-orchestra.sh", scriptArgs);
            return {
              content: [
                {
                  type: "text",
                  text: `Orchestra started in ${mode} mode on ports ${ports.join(", ")}`,
                },
              ],
            };
          }
          case "broadcast-message":
            return await this.orchestraHandler.broadcastMessage(args);

          // Keybinding Management
          case "get-keybindings":
            return await this.keybindingHandler.getKeybindings(args);

          // Session Management
          case "manage-session":
            return await this.sessionHandler.manageSession(args);

          // Health Check
          case "health-check":
            return await this.healthHandler.checkHealth(args);

          default:
            throw new McpError(
              ErrorCode.MethodNotFound,
              `Unknown tool: ${name}`
            );
        }
      } catch (error: any) {
        throw new McpError(
          ErrorCode.InternalError,
          `Tool execution failed: ${error.message}`
        );
      }
    });
  }

  async run() {
    await checkDependencies();
    
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.error("Neovim Listen MCP Server running on stdio");
  }
}

const server = new NvimListenServer();
server.run().catch(console.error);

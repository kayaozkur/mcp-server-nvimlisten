import { execa } from "execa";

export class PluginHandler {
  async listPlugins(args: any) {
    const { filter, includeConfig = false } = args;

    try {
      // Execute nvim command to list plugins
      const { stdout } = await execa("nvim", [
        "--headless",
        "-c",
        "lua print(vim.inspect(require('lazy').plugins()))",
        "-c",
        "quit"
      ]);

      let pluginList = stdout;

      if (filter) {
        // Simple filter implementation
        const lines = stdout.split('\n');
        pluginList = lines.filter(line => line.toLowerCase().includes(filter.toLowerCase())).join('\n');
      }

      return {
        content: [
          {
            type: "text",
            text: pluginList || "No plugins found",
          },
        ],
      };
    } catch (error: any) {
      throw new Error(`Failed to list plugins: ${error.message}`);
    }
  }

  async managePlugin(args: any) {
    const { action, pluginName, config } = args;

    try {
      let command = "";
      
      switch (action) {
        case "install":
          command = `lua require('lazy').install({${pluginName}${config ? `, config = ${config}` : ''}})`;
          break;
        case "update":
          command = pluginName ? 
            `lua require('lazy').update('${pluginName}')` : 
            `lua require('lazy').update()`;
          break;
        case "remove":
          if (!pluginName) throw new Error("Plugin name required for remove action");
          command = `lua require('lazy').clean({${pluginName}})`;
          break;
        case "sync":
          command = `lua require('lazy').sync()`;
          break;
      }

      const { stdout, stderr } = await execa("nvim", [
        "--headless",
        "-c",
        command,
        "-c",
        "quit"
      ]);

      return {
        content: [
          {
            type: "text",
            text: `Plugin ${action} completed: ${stdout || "Success"}`,
          },
        ],
      };
    } catch (error: any) {
      throw new Error(`Failed to manage plugin: ${error.message}`);
    }
  }

  async getPluginConfig(args: any) {
    const { pluginName } = args;

    try {
      const { stdout } = await execa("nvim", [
        "--headless",
        "-c",
        `lua print(vim.inspect(require('lazy').plugins()['${pluginName}']))`,
        "-c",
        "quit"
      ]);

      return {
        content: [
          {
            type: "text",
            text: stdout || `No configuration found for plugin: ${pluginName}`,
          },
        ],
      };
    } catch (error: any) {
      throw new Error(`Failed to get plugin config: ${error.message}`);
    }
  }
}
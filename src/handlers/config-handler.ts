import * as fs from "fs/promises";
import * as path from "path";
import * as os from "os";

export class ConfigHandler {
  private configDir: string;

  constructor() {
    this.configDir = path.join(os.homedir(), ".config", "nvim");
  }

  async getConfig(args: any) {
    const { configType = "all", filePath } = args;

    try {
      let configData: any = {};

      if (filePath) {
        const content = await fs.readFile(filePath, "utf-8");
        configData = { [filePath]: content };
      } else {
        switch (configType) {
          case "init":
            configData.init = await this.readConfigFile("init.lua");
            break;
          case "plugins":
            configData.plugins = await this.readConfigFile("lua/plugins/init.lua");
            break;
          case "mappings":
            configData.mappings = await this.readConfigFile("lua/mappings.lua");
            break;
          case "options":
            configData.options = await this.readConfigFile("lua/options.lua");
            break;
          case "all":
            configData = {
              init: await this.readConfigFile("init.lua"),
              plugins: await this.readConfigFile("lua/plugins/init.lua"),
              mappings: await this.readConfigFile("lua/mappings.lua"),
              options: await this.readConfigFile("lua/options.lua"),
            };
            break;
        }
      }

      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(configData, null, 2),
          },
        ],
      };
    } catch (error: any) {
      throw new Error(`Failed to get config: ${error.message}`);
    }
  }

  async setConfig(args: any) {
    const { configType, content, filePath, backup = true } = args;

    try {
      const targetPath = filePath || this.getConfigPath(configType);

      if (backup) {
        await this.createBackup(targetPath);
      }

      await fs.writeFile(targetPath, content, "utf-8");

      return {
        content: [
          {
            type: "text",
            text: `Configuration updated successfully at ${targetPath}`,
          },
        ],
      };
    } catch (error: any) {
      throw new Error(`Failed to set config: ${error.message}`);
    }
  }

  private async readConfigFile(relativePath: string): Promise<string> {
    const fullPath = path.join(this.configDir, relativePath);
    try {
      return await fs.readFile(fullPath, "utf-8");
    } catch (error) {
      return `// File not found: ${relativePath}`;
    }
  }

  private getConfigPath(configType: string): string {
    const paths: Record<string, string> = {
      init: "init.lua",
      plugins: "lua/plugins/init.lua",
      mappings: "lua/mappings.lua",
      options: "lua/options.lua",
    };
    return path.join(this.configDir, paths[configType] || "init.lua");
  }

  private async createBackup(filePath: string): Promise<void> {
    try {
      const content = await fs.readFile(filePath, "utf-8");
      const backupPath = `${filePath}.backup.${Date.now()}`;
      await fs.writeFile(backupPath, content, "utf-8");
    } catch (error) {
      // File might not exist, that's okay
    }
  }
}
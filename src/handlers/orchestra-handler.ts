import * as fs from "fs/promises";
import * as path from "path";
import { execa } from "execa";

export class OrchestraHandler {
  private scriptsDir: string;
  private orchestraStateFile: string;

  constructor() {
    this.scriptsDir = path.join(__dirname, "..", "..", "scripts");
    this.orchestraStateFile = "/tmp/nvim-orchestra-state.json";
  }

  async runScript(args: any) {
    const { scriptName, args: scriptArgs = [], async = false } = args;

    try {
      const scriptPath = path.join(this.scriptsDir, `${scriptName}.sh`);
      
      if (!await this.fileExists(scriptPath)) {
        throw new Error(`Script not found: ${scriptName}`);
      }

      const result = async ? 
        this.runScriptAsync(scriptPath, scriptArgs) :
        await this.runScriptSync(scriptPath, scriptArgs);

      return {
        content: [
          {
            type: "text",
            text: JSON.stringify({
              script: scriptName,
              async,
              result: async ? "Script started in background" : result,
              timestamp: new Date().toISOString()
            }, null, 2)
          }
        ]
      };
    } catch (error: any) {
      throw new Error(`Failed to run script: ${error.message}`);
    }
  }

  async broadcastMessage(args: any) {
    const { message, messageType = 'info' } = args;

    try {
      // Find all running nvim instances
      const { stdout: instances } = await execa("bash", ["-c", "lsof -t -i:7777-7779 | sort -u"]);
      const ports = instances.split('\n').filter(Boolean);

      const results = [];
      
      // Send message to each instance
      for (const port of [7777, 7778, 7779]) {
        try {
          await execa("nvim", [
            "--server",
            `127.0.0.1:${port}`,
            "--remote-send",
            `:echo '[${messageType.toUpperCase()}] ${message}'<CR>`
          ]);
          results.push(`Port ${port}: Success`);
        } catch (error) {
          results.push(`Port ${port}: Not running`);
        }
      }

      // Update orchestra state
      await this.updateOrchestraState({
        lastBroadcast: {
          message,
          messageType,
          timestamp: new Date().toISOString(),
          results
        }
      });

      return {
        content: [
          {
            type: "text",
            text: JSON.stringify({
              action: 'broadcast',
              message,
              messageType,
              results
            }, null, 2)
          }
        ]
      };
    } catch (error: any) {
      throw new Error(`Failed to broadcast message: ${error.message}`);
    }
  }

  async syncInstances(args: any) {
    const { syncType } = args;

    try {
      let syncCommand = "";
      
      switch (syncType) {
        case "config":
          syncCommand = ":source $MYVIMRC";
          break;
        case "session":
          syncCommand = ":SessionSave<CR>:SessionRestore";
          break;
        case "buffers":
          syncCommand = ":bufdo e!";
          break;
        case "all":
          syncCommand = ":source $MYVIMRC<CR>:bufdo e!";
          break;
      }

      const results = [];
      
      for (const port of [7777, 7778, 7779]) {
        try {
          await execa("nvim", [
            "--server",
            `127.0.0.1:${port}`,
            "--remote-send",
            syncCommand + "<CR>"
          ]);
          results.push(`Port ${port}: Synced`);
        } catch (error) {
          results.push(`Port ${port}: Failed`);
        }
      }

      return {
        content: [
          {
            type: "text",
            text: JSON.stringify({
              action: 'sync',
              syncType,
              results
            }, null, 2)
          }
        ]
      };
    } catch (error: any) {
      throw new Error(`Failed to sync instances: ${error.message}`);
    }
  }

  private async fileExists(filePath: string): Promise<boolean> {
    try {
      await fs.access(filePath);
      return true;
    } catch {
      return false;
    }
  }

  private async runScriptSync(scriptPath: string, args: string[]): Promise<string> {
    const { stdout, stderr } = await execa("bash", [scriptPath, ...args]);
    return stdout || stderr || "Script executed successfully";
  }

  private runScriptAsync(scriptPath: string, args: string[]): void {
    execa("bash", [scriptPath, ...args], { detached: true });
  }

  private async updateOrchestraState(update: any): Promise<void> {
    try {
      let state = {};
      
      if (await this.fileExists(this.orchestraStateFile)) {
        const content = await fs.readFile(this.orchestraStateFile, 'utf-8');
        state = JSON.parse(content);
      }
      
      state = { ...state, ...update };
      await fs.writeFile(this.orchestraStateFile, JSON.stringify(state, null, 2));
    } catch (error) {
      // Ignore state update errors
    }
  }
}
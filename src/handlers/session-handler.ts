import { execa } from "execa";
import * as fs from "fs/promises";
import * as path from "path";
import * as os from "os";

export class SessionHandler {
  private sessionsDir: string;

  constructor() {
    this.sessionsDir = path.join(os.homedir(), ".local", "share", "nvim", "sessions");
  }

  async manageSession(args: any) {
    const { action, sessionName, autoSave = true } = args;

    try {
      await this.ensureSessionsDir();

      switch (action) {
        case "create":
          return await this.createSession(sessionName, autoSave);
        case "restore":
          return await this.restoreSession(sessionName);
        case "list":
          return await this.listSessions();
        case "delete":
          return await this.deleteSession(sessionName);
        default:
          throw new Error(`Unknown session action: ${action}`);
      }
    } catch (error: any) {
      throw new Error(`Failed to manage session: ${error.message}`);
    }
  }

  private async createSession(sessionName: string, autoSave: boolean) {
    if (!sessionName) {
      throw new Error("Session name is required for create action");
    }

    const sessionPath = path.join(this.sessionsDir, `${sessionName}.vim`);
    
    // Create session using Neovim
    const { stdout, stderr } = await execa("nvim", [
      "--headless",
      "-c",
      `mksession! ${sessionPath}`,
      "-c",
      "quit"
    ]);

    // Save metadata
    const metadata = {
      name: sessionName,
      created: new Date().toISOString(),
      autoSave,
      cwd: process.cwd()
    };
    
    await fs.writeFile(
      path.join(this.sessionsDir, `${sessionName}.json`),
      JSON.stringify(metadata, null, 2)
    );

    return {
      content: [
        {
          type: "text",
          text: `Session '${sessionName}' created successfully at ${sessionPath}`,
        },
      ],
    };
  }

  private async restoreSession(sessionName: string) {
    if (!sessionName) {
      throw new Error("Session name is required for restore action");
    }

    const sessionPath = path.join(this.sessionsDir, `${sessionName}.vim`);
    
    // Check if session exists
    try {
      await fs.access(sessionPath);
    } catch {
      throw new Error(`Session '${sessionName}' not found`);
    }

    // Restore session in running Neovim instances
    const ports = [7001, 7002, 7777];
    const results = [];

    for (const port of ports) {
      try {
        await execa("nvim", [
          "--server",
          `127.0.0.1:${port}`,
          "--remote-send",
          `:source ${sessionPath}<CR>`
        ]);
        results.push(`Port ${port}: Session restored`);
      } catch {
        results.push(`Port ${port}: Not running`);
      }
    }

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify({
            action: "restore",
            session: sessionName,
            results
          }, null, 2),
        },
      ],
    };
  }

  private async listSessions() {
    const sessions = [];
    
    try {
      const files = await fs.readdir(this.sessionsDir);
      
      for (const file of files) {
        if (file.endsWith('.vim')) {
          const name = file.slice(0, -4);
          const metadataPath = path.join(this.sessionsDir, `${name}.json`);
          
          let metadata = {
            name,
            created: "Unknown",
            autoSave: false,
            cwd: "Unknown"
          };
          
          try {
            const metadataContent = await fs.readFile(metadataPath, 'utf-8');
            metadata = JSON.parse(metadataContent);
          } catch {
            // No metadata file
          }
          
          sessions.push(metadata);
        }
      }
    } catch (error) {
      // Sessions directory might not exist
    }

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(sessions, null, 2),
        },
      ],
    };
  }

  private async deleteSession(sessionName: string) {
    if (!sessionName) {
      throw new Error("Session name is required for delete action");
    }

    const sessionPath = path.join(this.sessionsDir, `${sessionName}.vim`);
    const metadataPath = path.join(this.sessionsDir, `${sessionName}.json`);

    try {
      await fs.unlink(sessionPath);
    } catch {
      throw new Error(`Session '${sessionName}' not found`);
    }

    // Try to delete metadata too
    try {
      await fs.unlink(metadataPath);
    } catch {
      // Metadata might not exist
    }

    return {
      content: [
        {
          type: "text",
          text: `Session '${sessionName}' deleted successfully`,
        },
      ],
    };
  }

  private async ensureSessionsDir() {
    try {
      await fs.mkdir(this.sessionsDir, { recursive: true });
    } catch {
      // Directory might already exist
    }
  }
}
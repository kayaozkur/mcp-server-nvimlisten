import which from "which";
import { execa } from "execa";
import * as fs from "fs/promises";
import * as path from "path";
import * as os from "os";

interface HealthCheckResult {
  category: string;
  items: Array<{
    name: string;
    status: "ok" | "warning" | "error";
    message: string;
    version?: string;
  }>;
}

export class HealthHandler {
  async checkHealth(args: any) {
    const results: HealthCheckResult[] = [];

    // Check required dependencies
    results.push(await this.checkRequiredDependencies());
    
    // Check optional dependencies
    results.push(await this.checkOptionalDependencies());
    
    // Check configurations
    results.push(await this.checkConfigurations());
    
    // Check running services
    results.push(await this.checkRunningServices());

    return {
      content: [
        {
          type: "text",
          text: this.formatHealthReport(results),
        },
      ],
    };
  }

  private async checkRequiredDependencies(): Promise<HealthCheckResult> {
    const required = ["nvim", "node", "npm"];
    const items = [];

    for (const cmd of required) {
      try {
        const path = await which(cmd);
        let version = "unknown";
        
        try {
          if (cmd === "nvim") {
            const { stdout } = await execa("nvim", ["--version"]);
            version = stdout.split('\n')[0].replace("NVIM ", "");
          } else if (cmd === "node") {
            const { stdout } = await execa("node", ["--version"]);
            version = stdout.trim();
          } else if (cmd === "npm") {
            const { stdout } = await execa("npm", ["--version"]);
            version = stdout.trim();
          }
        } catch {
          // Version check failed
        }

        items.push({
          name: cmd,
          status: "ok" as const,
          message: `Found at ${path}`,
          version,
        });
      } catch {
        items.push({
          name: cmd,
          status: "error" as const,
          message: "Not found in PATH",
        });
      }
    }

    return {
      category: "Required Dependencies",
      items,
    };
  }

  private async checkOptionalDependencies(): Promise<HealthCheckResult> {
    const optional = [
      { cmd: "zellij", desc: "Terminal multiplexer" },
      { cmd: "tmux", desc: "Alternative terminal multiplexer" },
      { cmd: "python3", desc: "Python runtime" },
      { cmd: "fzf", desc: "Fuzzy finder" },
      { cmd: "rg", desc: "Ripgrep search" },
      { cmd: "fd", desc: "Fast file finder" },
      { cmd: "lsd", desc: "Enhanced ls" },
      { cmd: "bat", desc: "Enhanced cat" },
      { cmd: "btop", desc: "System monitor" },
      { cmd: "emacs", desc: "Emacs editor" },
      { cmd: "atuin", desc: "Shell history" },
    ];

    const items = [];

    for (const { cmd, desc } of optional) {
      try {
        await which(cmd);
        items.push({
          name: `${cmd} (${desc})`,
          status: "ok" as const,
          message: "Installed",
        });
      } catch {
        items.push({
          name: `${cmd} (${desc})`,
          status: "warning" as const,
          message: "Not installed - some features may not work",
        });
      }
    }

    // Check Python packages
    try {
      await execa("python3", ["-c", "import pynvim"]);
      items.push({
        name: "pynvim (Python package)",
        status: "ok" as const,
        message: "Installed",
      });
    } catch {
      items.push({
        name: "pynvim (Python package)",
        status: "warning" as const,
        message: "Not installed - Python integration unavailable",
      });
    }

    return {
      category: "Optional Dependencies",
      items,
    };
  }

  private async checkConfigurations(): Promise<HealthCheckResult> {
    const configs = [
      { path: "~/.config/nvim", name: "Neovim config" },
      { path: "~/.config/zellij", name: "Zellij config" },
      { path: "~/.emacs.d", name: "Emacs config" },
    ];

    const items = [];

    for (const { path: configPath, name } of configs) {
      const fullPath = configPath.replace("~", os.homedir());
      
      try {
        const stats = await fs.stat(fullPath);
        if (stats.isDirectory()) {
          items.push({
            name,
            status: "ok" as const,
            message: `Found at ${fullPath}`,
          });
        }
      } catch {
        items.push({
          name,
          status: "warning" as const,
          message: `Not found at ${fullPath}`,
        });
      }
    }

    return {
      category: "Configuration Files",
      items,
    };
  }

  private async checkRunningServices(): Promise<HealthCheckResult> {
    const items = [];
    const ports = [7001, 7002, 7003, 7004, 7777, 7778, 7779];

    // Check Neovim instances
    for (const port of ports) {
      try {
        await execa("nvim", [
          "--server",
          `127.0.0.1:${port}`,
          "--remote-expr",
          "1"
        ]);
        items.push({
          name: `Neovim on port ${port}`,
          status: "ok" as const,
          message: "Running and responsive",
        });
      } catch {
        // Not running, which is fine
      }
    }

    // Check Emacs daemon
    try {
      await execa("emacsclient", ["-s", "claude-server", "-e", "t"]);
      items.push({
        name: "Emacs daemon (claude-server)",
        status: "ok" as const,
        message: "Running",
      });
    } catch {
      // Not running
    }

    // Check Zellij session
    try {
      const { stdout } = await execa("zellij", ["list-sessions"]);
      if (stdout.includes("claude-dev-enhanced")) {
        items.push({
          name: "Zellij session",
          status: "ok" as const,
          message: "claude-dev-enhanced session found",
        });
      }
    } catch {
      // Zellij not running or not installed
    }

    if (items.length === 0) {
      items.push({
        name: "No services",
        status: "warning" as const,
        message: "No services are currently running",
      });
    }

    return {
      category: "Running Services",
      items,
    };
  }

  private formatHealthReport(results: HealthCheckResult[]): string {
    let report = "# MCP Neovim Listen Server - Health Check Report\n\n";

    for (const category of results) {
      report += `## ${category.category}\n\n`;
      
      for (const item of category.items) {
        const icon = item.status === "ok" ? "✅" : 
                    item.status === "warning" ? "⚠️" : "❌";
        
        report += `${icon} **${item.name}**\n`;
        report += `   ${item.message}`;
        if (item.version) {
          report += ` (version: ${item.version})`;
        }
        report += "\n\n";
      }
    }

    // Add recommendations
    report += "## Recommendations\n\n";
    
    const hasErrors = results.some(r => 
      r.items.some(i => i.status === "error")
    );
    
    if (hasErrors) {
      report += "❌ **Critical issues found!**\n";
      report += "- Install missing required dependencies using:\n";
      report += "  ```bash\n";
      report += "  ./scripts/installers/install-dependencies.sh\n";
      report += "  ```\n\n";
    }

    const hasWarnings = results.some(r => 
      r.items.some(i => i.status === "warning")
    );
    
    if (hasWarnings) {
      report += "⚠️ **Optional components missing**\n";
      report += "- Some features may not work without optional dependencies\n";
      report += "- Run the installer with `--all` flag for full functionality:\n";
      report += "  ```bash\n";
      report += "  ./scripts/installers/install-dependencies.sh --all\n";
      report += "  ```\n\n";
    }

    if (!hasErrors && !hasWarnings) {
      report += "✅ **All systems operational!**\n";
      report += "- Your environment is fully configured\n";
      report += "- Start the environment with:\n";
      report += "  ```javascript\n";
      report += "  await use_mcp_tool(\"nvimlisten\", \"start-environment\", {});\n";
      report += "  ```\n";
    }

    return report;
  }
}
# Competitive Intelligence Workflow Example

This guide demonstrates how to use AgentQL + Memory servers with Neovim Listen for competitive analysis.

## 🎯 Scenario: Analyzing Competitor's Pricing Strategy

Let's say you're building a SaaS product and want to analyze how competitors structure their pricing.

### Step 1: Scrape Competitor Pricing Data

```javascript
// Scrape multiple competitor pricing pages
const competitors = [
  { name: "CompetitorA", url: "https://competitora.com/pricing" },
  { name: "CompetitorB", url: "https://competitorb.com/pricing" },
  { name: "CompetitorC", url: "https://competitorc.com/pricing" }
];

const pricingData = [];

for (const competitor of competitors) {
  // Use AgentQL to intelligently scrape pricing structure
  const data = await use_mcp_tool("agentql", "query", {
    "url": competitor.url,
    "query": `{
      pricingTiers {
        name
        price
        billing_cycle
        features[]
        highlighted_features[]
        limitations {
          users
          storage
          api_calls
        }
        cta_button {
          text
          action
        }
      }
      enterprise {
        available
        contact_sales
        custom_pricing
      }
      free_trial {
        available
        duration
        credit_card_required
      }
      discounts {
        annual_discount
        startup_program
        education_discount
      }
    }`
  });

  pricingData.push({
    competitor: competitor.name,
    url: competitor.url,
    data: data.data,
    scrapedAt: new Date().toISOString()
  });
}
```

### Step 2: Open Analysis Workspace in Neovim

```javascript
// Create a dedicated workspace for competitive analysis
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "analysis/competitive-pricing-analysis.md"
});

// Open your pricing component for comparison
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "src/components/PricingTable.tsx"
});
```

### Step 3: Analyze and Extract Insights

```javascript
// Process the scraped data to find patterns
const analysis = {
  priceRanges: analyzePriceRanges(pricingData),
  commonFeatures: findCommonFeatures(pricingData),
  pricingModels: categorizePricingModels(pricingData),
  uniqueSellingPoints: findUSPs(pricingData)
};

// Helper functions for analysis
function analyzePriceRanges(data) {
  const allPrices = data.flatMap(c => 
    c.data.pricingTiers.map(tier => ({
      competitor: c.competitor,
      tier: tier.name,
      price: parseFloat(tier.price.replace(/[^0-9.]/g, '')),
      isMonthly: tier.billing_cycle.includes('month')
    }))
  );

  return {
    lowestPrice: Math.min(...allPrices.map(p => p.price)),
    highestPrice: Math.max(...allPrices.map(p => p.price)),
    averagePrice: allPrices.reduce((sum, p) => sum + p.price, 0) / allPrices.length,
    priceDistribution: allPrices
  };
}

function findCommonFeatures(data) {
  const allFeatures = data.flatMap(c => 
    c.data.pricingTiers.flatMap(tier => tier.features)
  );
  
  // Count feature frequency
  const featureCount = {};
  allFeatures.forEach(feature => {
    featureCount[feature] = (featureCount[feature] || 0) + 1;
  });

  // Find features that appear in multiple competitors
  return Object.entries(featureCount)
    .filter(([_, count]) => count >= 2)
    .sort(([_, a], [__, b]) => b - a)
    .map(([feature, count]) => ({ feature, frequency: count }));
}
```

### Step 4: Generate Visual Comparison

```javascript
// Create a markdown report with insights
const report = `# Competitive Pricing Analysis
Generated: ${new Date().toISOString()}

## 📊 Price Range Analysis
- **Lowest Price**: $${analysis.priceRanges.lowestPrice}/month
- **Highest Price**: $${analysis.priceRanges.highestPrice}/month
- **Average Price**: $${analysis.priceRanges.averagePrice.toFixed(2)}/month

## 🎯 Common Features Across Competitors
${analysis.commonFeatures.map(f => 
  `- ${f.feature} (found in ${f.frequency} competitors)`
).join('\n')}

## 💡 Key Insights
${generateInsights(analysis)}

## 📈 Pricing Strategy Recommendations
${generateRecommendations(analysis, pricingData)}
`;

// Display the report in Neovim
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": `:normal! ggdG<CR>i${report.replace(/\n/g, '<CR>')}<CR>`
});
```

### Step 5: Save Analysis to Memory

```javascript
// Save the complete analysis for future reference
await use_mcp_tool("memory", "create-memory", {
  "key": "competitive-pricing-analysis-" + Date.now(),
  "value": {
    timestamp: new Date().toISOString(),
    competitors: competitors.map(c => c.name),
    rawData: pricingData,
    analysis: analysis,
    insights: {
      marketPositioning: determineMarketPosition(analysis),
      pricingGaps: findPricingGaps(analysis),
      featureGaps: findFeatureGaps(analysis),
      opportunities: identifyOpportunities(analysis, pricingData)
    },
    recommendations: {
      pricing: suggestPricingStrategy(analysis),
      features: suggestFeatures(analysis),
      positioning: suggestPositioning(analysis)
    }
  }
});

// Create a tracking entry for this analysis session
await use_mcp_tool("memory", "create-memory", {
  "key": "competitive-intel-session",
  "value": {
    date: new Date().toISOString(),
    focus: "pricing",
    competitorsAnalyzed: competitors.length,
    keyFindings: [
      `Average market price: $${analysis.priceRanges.averagePrice.toFixed(2)}`,
      `${analysis.commonFeatures.length} common features identified`,
      `${findPricingGaps(analysis).length} pricing gaps found`
    ]
  }
});
```

### Step 6: Monitor Competitor Changes

```javascript
// Set up monitoring for competitor pricing changes
async function setupCompetitorMonitoring() {
  // Schedule weekly checks
  await use_mcp_tool("time", "set-timer", {
    "duration": 604800, // 1 week in seconds
    "message": "Time to check competitor pricing changes!"
  });

  // Retrieve previous analysis
  const previousAnalysis = await use_mcp_tool("memory", "search-memories", {
    "query": "competitive-pricing-analysis"
  });

  if (previousAnalysis.memories.length > 0) {
    // Compare with previous data
    const lastAnalysis = previousAnalysis.memories[0].value;
    const changes = detectPricingChanges(lastAnalysis.rawData, pricingData);
    
    if (changes.length > 0) {
      // Alert about changes
      await use_mcp_tool("nvimlisten", "broadcast-message", {
        "message": `🚨 Competitor pricing changes detected: ${changes.length} updates`,
        "messageType": "warning"
      });

      // Document changes
      await use_mcp_tool("memory", "create-memory", {
        "key": "competitor-pricing-changes-" + Date.now(),
        "value": {
          detectedAt: new Date().toISOString(),
          changes: changes,
          impact: assessImpact(changes)
        }
      });
    }
  }
}
```

### Step 7: Generate Actionable Tasks

```javascript
// Based on analysis, create actionable tasks
const tasks = generateActionableTasks(analysis, pricingData);

// Open TODO file
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7777,
  "filepath": "TODO-competitive-response.md"
});

// Add tasks
const taskContent = `# Competitive Response Action Items
Generated from analysis on ${new Date().toISOString()}

## 🎯 Immediate Actions
${tasks.immediate.map(t => `- [ ] ${t}`).join('\n')}

## 📅 Short-term (This Sprint)
${tasks.shortTerm.map(t => `- [ ] ${t}`).join('\n')}

## 🗓️ Long-term Strategy
${tasks.longTerm.map(t => `- [ ] ${t}`).join('\n')}
`;

await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7777,
  "command": `:normal! Go<CR>${taskContent.replace(/\n/g, '<CR>')}<CR>`
});

// Helper function to generate tasks
function generateActionableTasks(analysis, pricingData) {
  const tasks = {
    immediate: [],
    shortTerm: [],
    longTerm: []
  };

  // Price positioning tasks
  if (analysis.priceRanges.averagePrice > 50) {
    tasks.immediate.push("Review our pricing against market average");
    tasks.shortTerm.push("A/B test new pricing tiers");
  }

  // Feature gap tasks
  const missingFeatures = analysis.commonFeatures
    .filter(f => f.frequency >= competitors.length - 1);
  
  missingFeatures.forEach(f => {
    tasks.shortTerm.push(`Implement feature: ${f.feature}`);
  });

  // Strategic tasks
  tasks.longTerm.push("Develop unique features not offered by competitors");
  tasks.longTerm.push("Create pricing calculator tool for website");

  return tasks;
}
```

## 🎯 Complete Working Example

Here's how to run the entire competitive intelligence workflow:

```javascript
async function runCompetitiveIntelligence() {
  console.log("🕵️ Starting competitive intelligence gathering...");

  try {
    // 1. Gather data
    const intelligenceData = await gatherCompetitorData();
    
    // 2. Analyze
    const insights = await analyzeCompetitorData(intelligenceData);
    
    // 3. Visualize in Neovim
    await displayAnalysisInNeovim(insights);
    
    // 4. Save to memory
    await saveIntelligence(insights);
    
    // 5. Generate action items
    await createActionPlan(insights);
    
    // 6. Set up monitoring
    await setupMonitoring();

    console.log("✅ Competitive intelligence workflow complete!");
    
  } catch (error) {
    console.error("❌ Error in competitive intelligence:", error);
    
    // Save error for debugging
    await use_mcp_tool("memory", "create-memory", {
      "key": "competitive-intel-error-" + Date.now(),
      "value": {
        error: error.message,
        timestamp: new Date().toISOString()
      }
    });
  }
}

// Run the workflow
await runCompetitiveIntelligence();
```

## 💡 Key Benefits

1. **Automated Data Collection**: No manual copying from competitor sites
2. **Intelligent Extraction**: AgentQL understands page structure
3. **Historical Tracking**: Memory server maintains analysis history
4. **Change Detection**: Monitor competitors over time
5. **Actionable Insights**: Generate specific tasks from analysis
6. **Integrated Workflow**: Everything happens within your development environment

## 🚀 Advanced Tips

- Schedule regular competitive analysis (weekly/monthly)
- Track competitor feature releases and announcements
- Monitor pricing A/B tests by checking periodically
- Build a competitive intelligence dashboard
- Share insights with team through memory server

This workflow transforms competitive analysis from a manual, time-consuming task into an automated, intelligent system that helps you stay ahead of the competition!
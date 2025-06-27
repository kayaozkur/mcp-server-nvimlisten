# Context Awareness Rules

## Context Window Management

### Priority Hierarchy for Context Allocation
1. **Critical Information (20% of context)**
   - Active task requirements and constraints
   - Current error states or blocking issues
   - User's immediate intent and urgency signals
   - Safety-critical code patterns

2. **Working Context (40% of context)**
   - Related files and dependencies currently in scope
   - Recent conversation history (last 3-5 exchanges)
   - Current project structure and active branches
   - Relevant documentation and configuration

3. **Supporting Context (25% of context)**
   - Historical patterns and user preferences
   - Related issues, PRs, and past solutions
   - Broader project context and architecture
   - Team conventions and standards

4. **Adaptive Buffer (15% of context)**
   - Reserve for unexpected context needs
   - Deep-dive information when complexity emerges
   - Cross-references and extended documentation

### Context Window Optimization Rules

**Rule CW-1: Dynamic Context Pruning**
- Continuously assess context relevance score (0-10)
- Remove context scoring < 3 when window exceeds 80% capacity
- Prioritize recently accessed over historically accessed
- Maintain decision tree of what was pruned for potential reload

**Rule CW-2: Intelligent Context Chunking**
- Break large files into logical segments (functions, classes, modules)
- Load only relevant segments initially
- Use progressive disclosure for complex structures
- Maintain segment relationship maps

## Multi-file Context Loading

### Proactive File Loading Decision Tree

```
Is current task multi-file? YES → Continue
                          NO → Skip proactive loading

Are related files < 50KB total? YES → Load all related
                               NO → Load headers/interfaces only

Does task involve refactoring? YES → Load all affected files
                              NO → Load only directly referenced

User explicitly mentioned files? YES → Load those files
                                NO → Use dependency analysis
```

**Rule MF-1: Smart Dependency Resolution**
- Load imported/required files up to 2 levels deep
- For large dependencies, load only public interfaces
- Cache dependency trees for faster subsequent loading
- Track circular dependencies and handle gracefully

**Rule MF-2: Context Relationship Mapping**
- Maintain graph of file relationships (imports, inheritance, calls)
- Use graph algorithms to determine optimal loading order
- Identify and preload "hub" files that connect many others
- Update relationship maps when files change

## Historical Context Management

### Conversation Memory Architecture

**Rule HC-1: Layered Memory System**
- **Session Memory**: Current conversation context
- **Project Memory**: Persistent project-specific knowledge
- **User Memory**: Cross-project user preferences and patterns
- **Domain Memory**: Reusable patterns and solutions

**Rule HC-2: Context Retrieval Strategies**
```python
def retrieve_relevant_context(current_task, user_query):
    relevance_score = calculate_semantic_similarity(current_task, historical_context)
    recency_score = time_decay_function(context_timestamp)
    success_score = track_solution_effectiveness(context_usage)
    
    final_score = 0.4 * relevance_score + 0.3 * recency_score + 0.3 * success_score
    return select_top_contexts(final_score, threshold=0.7)
```

**Rule HC-3: Context Summarization**
- Summarize conversations older than 24 hours
- Extract key decisions, patterns, and preferences
- Maintain action-outcome pairs for learning
- Create searchable context index

## Contextual Tool Selection

### Tool Selection Decision Matrix

**Rule TS-1: Context-Aware Tool Priority**
```
High-Risk Operations:
- Data modification → Always use Read before Edit
- Git operations → Check status first
- File system changes → Verify paths exist

Development Context:
- Code files → Prefer Edit over Write for existing files
- Multiple related changes → Use MultiEdit
- Search operations → Use Grep for content, Glob for files

Documentation Context:
- Reading → Use Read tool
- Writing new docs → Only if explicitly requested
- Updating docs → Use Edit for existing files
```

**Rule TS-2: Batch Operation Intelligence**
- Identify operations that can be parallelized
- Group similar operations (multiple file reads, multiple edits)
- Optimize tool call sequences to minimize round trips
- Cache results of expensive operations

### Context-Based Tool Parameterization

**Rule TP-1: Smart Parameter Inference**
- Use project structure to infer file paths
- Apply user preferences for tool configuration
- Adapt timeouts based on operation complexity
- Infer search patterns from current context

**Rule TP-2: Error Context Integration**
- Include relevant error history in tool parameters
- Adjust retry strategies based on historical failure patterns
- Use context to predict likely parameter corrections
- Maintain error-to-solution mappings

## Context Preservation Between Interactions

### State Persistence Rules

**Rule CP-1: Critical State Tracking**
```json
{
  "session_state": {
    "active_files": ["list of files being worked on"],
    "pending_actions": ["list of planned next steps"],
    "error_context": ["current error states and debugging context"],
    "user_intent": "high-level goal user is trying to achieve"
  },
  "project_state": {
    "architecture_patterns": ["identified patterns in codebase"],
    "coding_standards": ["observed conventions"],
    "common_issues": ["recurring problems and solutions"],
    "optimization_opportunities": ["identified improvements"]
  }
}
```

**Rule CP-2: Context Handoff Protocol**
- Summarize current state at interaction end
- Identify incomplete tasks and dependencies
- Flag potential issues for next interaction
- Preserve decision rationale for future reference

**Rule CP-3: Context Validation on Resume**
- Verify file states haven't changed unexpectedly
- Check for new commits or external changes
- Validate assumptions about project state
- Refresh context if significant changes detected

## Adaptive Context Strategies

### Learning-Based Context Optimization

**Rule AC-1: User Pattern Recognition**
- Track which context types user finds most helpful
- Identify user's working patterns and preferences
- Adapt context loading based on task type patterns
- Learn from user corrections and feedback

**Rule AC-2: Context Effectiveness Metrics**
```python
def measure_context_effectiveness():
    metrics = {
        'task_completion_rate': successful_tasks / total_tasks,
        'context_utilization': referenced_context / loaded_context,
        'user_satisfaction': positive_feedback / total_feedback,
        'efficiency_gain': (time_saved + errors_prevented) / context_cost
    }
    return metrics
```

**Rule AC-3: Continuous Context Optimization**
- A/B test different context loading strategies
- Optimize context window allocation based on task outcomes
- Adjust context retention policies based on usage patterns
- Evolve context strategies based on effectiveness metrics

## Emergency Context Management

### Context Recovery Rules

**Rule EC-1: Context Loss Recovery**
- Maintain lightweight context snapshots
- Implement rapid context reconstruction from minimal cues
- Use file system and git history to rebuild context
- Gracefully degrade functionality when context is incomplete

**Rule EC-2: Context Overflow Handling**
- Implement intelligent context compression
- Use progressive context offloading strategies
- Maintain context priority queues for smart eviction
- Provide context recovery mechanisms

### Performance Safeguards

**Rule PS-1: Context Performance Monitoring**
- Track context loading times and memory usage
- Implement circuit breakers for expensive context operations
- Monitor and alert on context-related performance degradation
- Automatically optimize context strategies based on performance data

**Rule PS-2: Graceful Degradation**
- Define minimum viable context for different task types
- Implement fallback strategies when full context unavailable
- Maintain task functionality even with limited context
- Communicate context limitations clearly to users

## Context Quality Assurance

### Context Validation Rules

**Rule CQ-1: Context Freshness Validation**
- Verify context currency before use
- Implement cache invalidation strategies
- Check for context conflicts and inconsistencies
- Maintain context versioning for rollback capability

**Rule CQ-2: Context Accuracy Monitoring**
- Cross-validate context from multiple sources
- Implement context consistency checks
- Monitor context prediction accuracy
- Learn from context-related errors and misunderstandings

These context awareness rules create a sophisticated foundation for intelligent behavior, ensuring that Claude Code always operates with the most relevant, accurate, and useful context for each situation.
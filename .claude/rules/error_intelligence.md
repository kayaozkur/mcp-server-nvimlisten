# Error Intelligence Rules

## Error Pattern Matching and Classification

### Common Error Pattern Library

**Rule EP-1: File System Error Patterns**
```python
FILE_SYSTEM_ERROR_PATTERNS = {
    'file_not_found': {
        'patterns': [r'No such file or directory', r'FileNotFoundError', r'ENOENT'],
        'common_causes': ['Incorrect path', 'File moved/deleted', 'Typo in filename'],
        'recovery_strategies': ['verify_path_exists', 'search_for_similar_files', 'check_recent_changes'],
        'prevention': ['validate_paths_before_operations', 'use_absolute_paths']
    },
    'permission_denied': {
        'patterns': [r'Permission denied', r'EACCES', r'Access is denied'],
        'common_causes': ['Insufficient permissions', 'File in use', 'Protected directory'],
        'recovery_strategies': ['check_file_permissions', 'suggest_sudo_alternative', 'find_writable_alternative'],
        'prevention': ['check_permissions_before_write', 'use_user_directories']
    },
    'disk_space_full': {
        'patterns': [r'No space left on device', r'ENOSPC', r'Disk full'],
        'common_causes': ['Insufficient disk space', 'Large file operations', 'Log files'],
        'recovery_strategies': ['check_disk_usage', 'suggest_cleanup', 'use_temporary_location'],
        'prevention': ['monitor_disk_space', 'implement_size_limits']
    }
}
```

**Rule EP-2: Git Error Pattern Recognition**
```python
GIT_ERROR_PATTERNS = {
    'merge_conflict': {
        'patterns': [r'CONFLICT.*Merge conflict', r'Automatic merge failed'],
        'severity': 'high',
        'auto_recovery': False,
        'analysis_required': ['identify_conflicting_files', 'analyze_conflict_complexity'],
        'user_guidance': ['explain_conflict_resolution_options', 'provide_merge_tools']
    },
    'uncommitted_changes': {
        'patterns': [r'Please commit your changes', r'Your local changes would be overwritten'],
        'severity': 'medium',
        'auto_recovery': True,
        'recovery_steps': ['stash_changes', 'attempt_operation', 'restore_if_needed']
    },
    'detached_head': {
        'patterns': [r'You are in .detached HEAD. state'],
        'severity': 'medium',
        'auto_recovery': False,
        'guidance': ['explain_detached_head', 'suggest_branch_creation', 'warn_about_lost_commits']
    }
}
```

### Intelligent Error Classification

**Rule EC-1: Error Severity Assessment**
```python
def classify_error_severity(error_message, context):
    severity_indicators = {
        'critical': ['data loss', 'corruption', 'security breach', 'system failure'],
        'high': ['operation failed', 'cannot proceed', 'blocking error'],
        'medium': ['warning', 'deprecated', 'performance impact'],
        'low': ['info', 'suggestion', 'minor issue']
    }
    
    # Context-aware severity adjustment
    if context.is_production:
        severity_level += 1  # Increase severity in production
    if context.affects_multiple_files:
        severity_level += 1  # Increase for widespread impact
    
    return determine_severity(error_message, severity_indicators, context)
```

**Rule EC-2: Error Context Enrichment**
- Capture complete error context (file state, git status, recent operations)
- Identify related errors and error chains
- Track error frequency and patterns
- Correlate errors with environmental factors (time, system state, user actions)

## Root Cause Analysis Framework

### Systematic Debugging Protocol

**Rule RCA-1: Multi-Layer Root Cause Analysis**
```python
def perform_root_cause_analysis(error, context):
    analysis_layers = [
        'immediate_cause',      # Direct cause of the error
        'contributing_factors', # Conditions that enabled the error
        'root_conditions',      # Fundamental issues that should be addressed
        'systemic_issues'       # Broader patterns that need attention
    ]
    
    for layer in analysis_layers:
        findings = analyze_layer(error, context, layer)
        if findings.confidence_level > 0.8:
            return generate_solution_strategy(findings)
    
    return escalate_for_human_analysis(error, context)
```

**Rule RCA-2: Dependency Chain Analysis**
```python
def analyze_dependency_chain(error_location):
    # Build dependency graph from error location
    dependency_graph = build_dependency_graph(error_location)
    
    # Trace potential failure points
    failure_points = []
    for dependency in dependency_graph:
        if has_recent_changes(dependency):
            failure_points.append(analyze_dependency_changes(dependency))
    
    # Prioritize failure points by likelihood
    return sort_by_failure_probability(failure_points)
```

### Error Pattern Mining

**Rule EPM-1: Historical Error Analysis**
- Maintain database of error-solution pairs
- Identify recurring error patterns across projects
- Track solution effectiveness over time
- Mine patterns from successful error resolutions

**Rule EPM-2: Predictive Error Detection**
```python
def predict_potential_errors(current_operation, context):
    risk_factors = analyze_risk_factors(current_operation, context)
    historical_patterns = query_error_history(similar_operations(current_operation))
    
    risk_score = calculate_risk_score(risk_factors, historical_patterns)
    
    if risk_score > RISK_THRESHOLD:
        return generate_prevention_suggestions(risk_factors)
    
    return None  # No significant risk detected
```

## Proactive Error Prevention

### Pre-Operation Validation

**Rule PV-1: Comprehensive Pre-Flight Checks**
```python
def perform_preflight_checks(operation_type, parameters):
    checks = {
        'file_operations': [
            'verify_file_exists',
            'check_file_permissions',
            'validate_file_format',
            'check_available_disk_space'
        ],
        'git_operations': [
            'verify_repository_status',
            'check_uncommitted_changes',
            'validate_branch_state',
            'check_remote_connectivity'
        ],
        'edit_operations': [
            'validate_syntax_before_edit',
            'check_file_locks',
            'verify_backup_availability',
            'validate_edit_patterns'
        ]
    }
    
    for check in checks.get(operation_type, []):
        result = execute_check(check, parameters)
        if not result.passed:
            return prevent_operation_with_guidance(result)
    
    return proceed_with_operation()
```

**Rule PV-2: Context-Aware Risk Assessment**
- Assess operation risk based on current project state
- Consider user experience level for risk tolerance
- Evaluate potential impact scope before operations
- Implement progressive confirmation for high-risk operations

### Intelligent Safety Nets

**Rule SN-1: Automated Backup Strategies**
```python
def implement_safety_net(operation_type, risk_level):
    if risk_level == 'high':
        create_full_backup()
        enable_detailed_logging()
        implement_rollback_checkpoint()
    elif risk_level == 'medium':
        create_incremental_backup()
        enable_operation_logging()
    else:
        # Low risk - minimal safety net
        log_operation_summary()
```

**Rule SN-2: Graceful Degradation Mechanisms**
- Implement fallback strategies for common failure scenarios
- Provide alternative approaches when primary method fails
- Maintain partial functionality during error recovery
- Offer manual override options with appropriate warnings

## Automated Error Recovery

### Recovery Strategy Selection

**Rule RS-1: Recovery Strategy Decision Tree**
```
Error Type Classification
├── Transient Error → Retry with backoff
├── Configuration Error → Auto-fix if pattern known
├── Dependency Error → Attempt dependency resolution
├── User Input Error → Request clarification/correction
├── System Resource Error → Wait and retry or find alternatives
└── Unknown Error → Escalate with full context
```

**Rule RS-2: Intelligent Retry Logic**
```python
def intelligent_retry(operation, error, attempt_count):
    retry_config = {
        'network_errors': {'max_attempts': 3, 'backoff_factor': 2.0},
        'resource_errors': {'max_attempts': 5, 'backoff_factor': 1.5},
        'transient_errors': {'max_attempts': 2, 'backoff_factor': 1.0}
    }
    
    error_type = classify_error_type(error)
    config = retry_config.get(error_type, {'max_attempts': 1, 'backoff_factor': 1.0})
    
    if attempt_count >= config['max_attempts']:
        return escalate_error(operation, error, attempt_count)
    
    backoff_time = calculate_backoff(attempt_count, config['backoff_factor'])
    return schedule_retry(operation, backoff_time)
```

### Self-Healing Mechanisms

**Rule SH-1: Automatic Problem Resolution**
```python
AUTO_RESOLUTION_STRATEGIES = {
    'missing_directory': lambda path: os.makedirs(path, exist_ok=True),
    'stale_lock_file': lambda lock_path: remove_if_stale(lock_path),
    'outdated_cache': lambda cache_key: invalidate_and_rebuild_cache(cache_key),
    'permission_issue': lambda file_path: suggest_permission_fix(file_path)
}

def attempt_auto_resolution(error, context):
    resolution_key = identify_resolution_pattern(error)
    
    if resolution_key in AUTO_RESOLUTION_STRATEGIES:
        try:
            return AUTO_RESOLUTION_STRATEGIES[resolution_key](context)
        except Exception as resolution_error:
            return escalate_with_resolution_failure(error, resolution_error)
    
    return None  # No automatic resolution available
```

**Rule SH-2: Learning-Based Recovery**
- Learn from successful manual error resolutions
- Build custom auto-resolution strategies from user patterns
- Adapt recovery strategies based on effectiveness feedback
- Share successful recovery patterns across projects

## Error Documentation and Learning

### Error Knowledge Base

**Rule KB-1: Comprehensive Error Documentation**
```python
class ErrorKnowledgeBase:
    def __init__(self):
        self.error_patterns = {}
        self.solution_effectiveness = {}
        self.context_correlations = {}
        self.user_feedback = {}
    
    def record_error_resolution(self, error, solution, context, outcome):
        error_signature = generate_error_signature(error)
        
        self.error_patterns[error_signature] = {
            'frequency': self.error_patterns.get(error_signature, {}).get('frequency', 0) + 1,
            'contexts': self.record_context(context),
            'solutions': self.record_solution(solution, outcome),
            'last_seen': datetime.now()
        }
        
        self.update_solution_effectiveness(solution, outcome)
```

**Rule KB-2: Knowledge Sharing and Evolution**
- Maintain searchable error solution database
- Track solution success rates and user satisfaction
- Identify emerging error patterns and trends
- Update error handling strategies based on new learnings

### Continuous Learning Framework

**Rule CL-1: Error Pattern Evolution**
- Continuously update error pattern recognition
- Adapt to new error types and contexts
- Learn from false positives and missed detections
- Incorporate user feedback into pattern refinement

**Rule CL-2: Solution Optimization**
```python
def optimize_solution_strategies():
    # Analyze solution effectiveness over time
    solution_metrics = analyze_solution_performance()
    
    # Identify underperforming solutions
    underperforming = find_solutions_below_threshold(solution_metrics)
    
    # Suggest improvements or alternatives
    for solution in underperforming:
        alternatives = find_alternative_solutions(solution)
        effectiveness_predictions = predict_alternative_effectiveness(alternatives)
        
        if max(effectiveness_predictions) > solution.current_effectiveness:
            suggest_solution_upgrade(solution, alternatives)
```

## Advanced Error Handling Techniques

### Error Correlation and Clustering

**Rule AC-1: Multi-Dimensional Error Analysis**
```python
def perform_error_correlation_analysis():
    error_dimensions = [
        'temporal_patterns',    # When errors occur
        'spatial_patterns',     # Where in codebase errors occur
        'contextual_patterns',  # Under what conditions errors occur
        'user_patterns',        # Which user actions trigger errors
        'environmental_patterns' # System state correlations
    ]
    
    correlations = {}
    for dimension in error_dimensions:
        correlations[dimension] = analyze_error_dimension(dimension)
    
    return identify_error_clusters(correlations)
```

**Rule AC-2: Predictive Error Prevention**
- Use machine learning to predict error likelihood
- Implement early warning systems for potential errors
- Provide proactive suggestions to prevent common errors
- Adapt prevention strategies based on user behavior patterns

### Error Impact Assessment

**Rule IA-1: Blast Radius Analysis**
```python
def assess_error_impact(error, context):
    impact_factors = {
        'affected_files': count_affected_files(error, context),
        'dependent_systems': identify_dependent_systems(context),
        'user_workflow_disruption': assess_workflow_impact(error),
        'data_integrity_risk': evaluate_data_risks(error),
        'recovery_complexity': estimate_recovery_effort(error)
    }
    
    overall_impact = calculate_weighted_impact(impact_factors)
    return classify_impact_level(overall_impact)
```

**Rule IA-2: Cascading Error Prevention**
- Identify potential cascading error scenarios
- Implement circuit breakers to prevent error propagation
- Monitor for error chain reactions
- Provide isolation mechanisms for critical operations

## Error Communication and User Guidance

### Intelligent Error Messaging

**Rule EM-1: Context-Aware Error Explanation**
```python
def generate_user_friendly_error_message(error, context, user_level):
    base_explanation = explain_error_in_plain_language(error)
    
    if user_level == 'beginner':
        return add_educational_context(base_explanation, error)
    elif user_level == 'intermediate':
        return add_technical_details(base_explanation, error)
    else:  # advanced
        return add_debugging_information(base_explanation, error, context)
```

**Rule EM-2: Actionable Error Guidance**
- Provide specific, actionable steps for error resolution
- Offer multiple resolution paths when available
- Include preventive measures for future avoidance
- Link to relevant documentation and resources

### Error Recovery Assistance

**Rule RA-1: Guided Error Resolution**
```python
def provide_guided_resolution(error, context):
    resolution_steps = generate_resolution_steps(error, context)
    
    # Interactive resolution guidance
    for step in resolution_steps:
        explanation = explain_step_purpose(step)
        confirmation = request_user_confirmation(step, explanation)
        
        if confirmation:
            result = execute_resolution_step(step)
            if not result.success:
                return provide_alternative_approaches(step, result.error)
        else:
            return provide_manual_resolution_guide(remaining_steps)
    
    return validate_resolution_success(error, context)
```

**Rule RA-2: Learning from Resolution Process**
- Track user preferences in error resolution approaches
- Learn from successful resolution sequences
- Identify common user difficulties in error resolution
- Continuously improve guidance based on user feedback

These error intelligence rules create a sophisticated error handling system that not only responds to errors effectively but learns from them, prevents them proactively, and continuously improves the overall system reliability and user experience.
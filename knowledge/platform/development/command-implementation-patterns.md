# Claude Code Command Implementation Guide

## Overview

This guide provides comprehensive patterns for creating new Claude Code commands within the DA Agent Hub platform. It covers the complete workflow from command concept to integration with the Analytics Development Lifecycle (ADLC).

## Context

Claude Code commands provide the primary interface for developers to interact with the DA Agent Hub platform. Commands must be:
- **Intuitive**: Easy to understand and use
- **Reliable**: Consistent behavior and error handling
- **Integrated**: Seamlessly connected to ADLC workflows
- **Documented**: Clear protocols and usage examples

## Architecture Pattern

### Dual-Component Design

Every Claude Code command follows a two-part architecture:

#### 1. Command Protocol File
**Location**: `.claude/commands/[command-name].md`
**Purpose**: Documentation and protocol specification for Claude

```markdown
# /[command] Command Protocol

## Purpose
[Single-sentence command purpose]

## Usage
```bash
claude /[command] [parameters]
```

## Protocol
[Step-by-step workflow]

## Claude Instructions
[Specific execution instructions for Claude]

## Integration with ADLC
[Connection to Analytics Development Lifecycle]

## Success Criteria
[Measurable completion indicators]
```

#### 2. Implementation Script
**Location**: `scripts/[command-name].sh`
**Purpose**: Technical execution and automation

```bash
#!/bin/bash

# [command-name].sh - [Purpose description]
# Usage: ./scripts/[command-name].sh [parameters]
#
# This script provides [detailed workflow]:
# 1. [Step description]
# 2. [Integration points]
# 3. [Output expectations]

set -e  # Exit on error

# [Implementation functions and main logic]
```

## Implementation Process

### Step 1: Command Concept Design

#### Define Command Purpose
- **Single Responsibility**: One clear, focused purpose
- **ADLC Integration**: How it fits into analytics development lifecycle
- **User Value**: Concrete benefit to developers
- **Workflow Integration**: Connection to existing 4-command system

#### Example Command Planning
```markdown
Command: /analyze
Purpose: Analyze data quality issues across the analytics stack
ADLC Phase: Observe/Discover
Integration: Works with existing monitoring and issue detection
Value: Automated cross-system investigation and recommendations
```

### Step 2: Protocol Documentation

#### Standard Protocol Template
**File**: `.claude/commands/[command].md`

```markdown
# /[command] Command Protocol

## Purpose
[One clear sentence describing what the command does]

## Usage
```bash
claude /[command] [required-param] [optional-param]
```

## Protocol

### 1. Execute [command].sh Script
```bash
./scripts/[command].sh [parameters]
```

### 2. Complete [Workflow] Process
The script automatically handles:
- **[Key functionality 1]**: [Description]
- **[Key functionality 2]**: [Description]
- **[Key functionality 3]**: [Description]

## Claude Instructions

When user runs `/[command] [parameters]`:

1. **Execute the script**: Run `./scripts/[command].sh [parameters]`
2. **Monitor workflow steps**: Display each phase
3. **Validate completion**: Confirm successful execution
4. **Provide guidance**: Explain next steps

### Response Format
```
🔄 Executing [command] workflow...
✅ [Step 1] completed successfully
✅ [Step 2] completed successfully
✅ [Step 3] completed successfully

💡 Next steps:
   1. [Follow-up action 1]
   2. [Follow-up action 2]

📁 Results: [Location/summary]
```

## Integration with ADLC
- **[ADLC Phase]**: [How command supports this phase]
- **Workflow Integration**: [Connection to other commands]
- **Output**: [What the command produces]

## Success Criteria
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] [Measurable outcome 3]

---

*[Brief summary of command value proposition]*
```

### Step 3: Script Implementation

#### Script Header Standards
```bash
#!/bin/bash

# [command-name].sh - [Single-line purpose description]
# Usage: ./scripts/[command-name].sh [param1] [param2]
#
# This script provides [detailed description]:
# 1. [Primary workflow step]
# 2. [Secondary workflow step]
# 3. [Integration and output]
#
# Environment Variables:
#   [VAR_NAME]: [Description of required environment variable]
#   [OPTIONAL_VAR]: [Description of optional variable]
#
# Examples:
#   $0 basic-usage
#   $0 advanced-usage --with-options

set -e  # Exit on any error

# Color definitions for consistent output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
```

#### Function Documentation Pattern
```bash
# Function to [specific purpose]
# Parameters:
#   $1: [parameter description]
#   $2: [parameter description] (optional)
# Returns:
#   0: Success
#   1: [Error condition]
#   2: [Different error condition]
# Example:
#   process_data "input.csv" "output.json"
process_data() {
    local input_file="$1"
    local output_file="$2"

    # Function implementation with error handling
    if [ ! -f "$input_file" ]; then
        print_error "Input file not found: $input_file"
        return 1
    fi

    # Core functionality
    # ...

    print_status "Data processing completed: $output_file"
    return 0
}
```

#### Error Handling Standards
```bash
# Consistent error handling patterns
validate_dependencies() {
    local missing_deps=()

    # Check for required tools
    command -v git >/dev/null 2>&1 || missing_deps+=("git")
    command -v jq >/dev/null 2>&1 || missing_deps+=("jq")

    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_info "Please install missing tools and try again"
        exit 1
    fi

    print_status "All dependencies verified"
}

# Cleanup on exit
cleanup() {
    local exit_code=$?

    # Remove temporary files
    [ -n "$TEMP_DIR" ] && rm -rf "$TEMP_DIR"

    # Report completion status
    if [ $exit_code -eq 0 ]; then
        print_status "Command completed successfully"
    else
        print_error "Command failed with exit code: $exit_code"
    fi

    exit $exit_code
}

# Set up cleanup trap
trap cleanup EXIT
```

### Step 4: Integration Testing

#### Command Testing Framework
```bash
# test-[command].sh - Testing script for command validation
#!/bin/bash

# Test scenarios for [command]
test_basic_usage() {
    echo "Testing basic usage..."

    # Set up test environment
    setup_test_environment

    # Execute command
    if ./scripts/[command].sh test-param; then
        echo "✅ Basic usage test passed"
        return 0
    else
        echo "❌ Basic usage test failed"
        return 1
    fi
}

test_error_handling() {
    echo "Testing error handling..."

    # Test with invalid parameters
    if ./scripts/[command].sh invalid-param 2>/dev/null; then
        echo "❌ Error handling test failed - should have failed"
        return 1
    else
        echo "✅ Error handling test passed"
        return 0
    fi
}

# Run all tests
main() {
    local failed_tests=0

    test_basic_usage || ((failed_tests++))
    test_error_handling || ((failed_tests++))

    if [ $failed_tests -eq 0 ]; then
        echo "✅ All tests passed"
        exit 0
    else
        echo "❌ $failed_tests test(s) failed"
        exit 1
    fi
}

main "$@"
```

#### Manual Testing Checklist
- [ ] Command executes without errors
- [ ] Help/usage information is clear
- [ ] Error messages are helpful
- [ ] Integration with existing workflows works
- [ ] Output format is consistent with other commands
- [ ] Documentation matches actual behavior

### Step 5: ADLC Integration

#### 4-Command Workflow Integration
Update `CLAUDE.md` to include new command in appropriate workflow section:

```markdown
#### **Enhanced Commands:** *(If command extends core workflow)*
5. **`./scripts/[command].sh [params]`** or **`/[command] [params]`** - [Purpose]
   - [Key benefit 1]
   - [Key benefit 2]
   - ADLC [Phase]: [Description of phase support]
```

#### Agent Coordination
If command requires specialist agent coordination:

```markdown
### Specialist Agent Integration
- **[agent-expert]**: [How agent supports this command]
- **[another-agent]**: [Coordination pattern]
- **da-architect**: [System-level oversight and coordination]
```

## Common Implementation Patterns

### Pattern 1: Data Processing Command
**Use Case**: Commands that analyze or transform data
```bash
# Core pattern for data processing
main() {
    local input_source="$1"
    local output_format="${2:-json}"

    validate_inputs "$input_source"
    setup_processing_environment
    process_data "$input_source" "$output_format"
    generate_report
    cleanup_environment
}
```

### Pattern 2: Integration Command
**Use Case**: Commands that coordinate across multiple systems
```bash
# Core pattern for system integration
main() {
    local system_a="$1"
    local system_b="$2"

    check_system_connectivity
    gather_system_states
    perform_integration_analysis
    generate_recommendations
    create_action_plan
}
```

### Pattern 3: Workflow Command
**Use Case**: Commands that orchestrate complex workflows
```bash
# Core pattern for workflow orchestration
main() {
    local workflow_type="$1"

    load_workflow_configuration
    validate_workflow_requirements
    execute_workflow_steps
    monitor_workflow_progress
    handle_workflow_completion
}
```

## Command Categories

### Core ADLC Commands
**Purpose**: Direct support for Analytics Development Lifecycle
- **Planning**: `/capture`, `/roadmap`, `/organize`
- **Development**: `/build`, `/develop`, `/coordinate`
- **Operations**: `/monitor`, `/analyze`, `/optimize`
- **Completion**: `/complete`, `/archive`, `/switch`

### Utility Commands
**Purpose**: Supporting functionality for development workflow
- **Navigation**: `/status`, `/list`, `/find`
- **Configuration**: `/setup`, `/config`, `/auth`
- **Maintenance**: `/clean`, `/sync`, `/backup`

### Integration Commands
**Purpose**: Cross-system coordination and analysis
- **Data Quality**: `/validate`, `/audit`, `/reconcile`
- **Performance**: `/profile`, `/benchmark`, `/tune`
- **Coordination**: `/deploy`, `/coordinate`, `/synchronize`

## Quality Standards

### Documentation Quality
- [ ] **Purpose**: Single, clear sentence describing command function
- [ ] **Usage**: Complete usage examples with parameters
- [ ] **Protocol**: Step-by-step workflow documentation
- [ ] **Integration**: Clear ADLC phase alignment
- [ ] **Examples**: Multiple usage scenarios with expected outcomes

### Implementation Quality
- [ ] **Error Handling**: Comprehensive error detection and user guidance
- [ ] **Validation**: Input validation and dependency checking
- [ ] **Logging**: Consistent status reporting and progress indicators
- [ ] **Cleanup**: Proper resource cleanup and exit handling
- [ ] **Testing**: Automated testing framework and manual validation

### Integration Quality
- [ ] **ADLC Alignment**: Clear connection to analytics development lifecycle
- [ ] **Workflow Integration**: Seamless interaction with existing commands
- [ ] **Agent Coordination**: Proper specialist agent integration when needed
- [ ] **Git Integration**: Follows da-agent-hub git workflow standards

## Success Metrics

### Command Effectiveness
- **Usage Adoption**: Frequency of command usage across team
- **Error Rates**: Percentage of successful command executions
- **User Satisfaction**: Developer feedback on command usefulness
- **Integration Success**: Seamless workflow integration measurement

### Development Efficiency
- **Implementation Time**: Time from concept to working command
- **Maintenance Overhead**: Time required for command updates and fixes
- **Documentation Quality**: Clarity and completeness of command documentation
- **Testing Coverage**: Percentage of command functionality under test

## References

### Implementation Examples
- [Switch Command](../.claude/commands/switch.md) - Complete context switching workflow
- [Complete Command](../.claude/commands/complete.md) - Project completion with knowledge extraction
- [Build Command](../scripts/build.sh) - Project initialization and setup

### Related Documentation
- [4-Command Workflow](../CLAUDE.md#simplified-analytics-development-commands) - Core workflow integration
- [Agent Coordination](../CLAUDE.md#agent-coordination-strategy) - Specialist agent patterns
- [Git Workflow](../CLAUDE.md#general-git-workflow) - Version control integration standards

---

*Comprehensive guide for creating robust, integrated Claude Code commands that enhance the Analytics Development Lifecycle.*
# Proactive Agent Skill

## Description
Transforms the agent from reactive to proactive by maintaining session state, predicting user needs, and automatically recovering context after restarts.

## When to Use
- For long-running projects that span multiple sessions
- When you want the agent to remember context without repeating
- When working on complex tasks requiring continuity
- When you need the agent to anticipate next steps

## Key Features

### 1. WAL Protocol (Write-Ahead Logging)
Every important message is first written to SESSION-STATE.md before responding to the user.

### 2. Working Memory Buffers
When context approaches limits, automatically saves all interactions to a buffer file.

### 3. Compression & Recovery
On session restart, automatically decompresses and restores working state from buffers.

## Usage

The agent will automatically:
- Save key decisions to SESSION-STATE.md
- Maintain memory/YYYY-MM-DD.md files
- Search past memories when relevant
- Proactively suggest next steps based on history

## Best Practices
1. Review SESSION-STATE.md periodically
2. Allow the agent to maintain its own memory files
3. Reference past context instead of repeating it

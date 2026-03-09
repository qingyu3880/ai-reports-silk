---
name: project-mgmt
description: Simple project management with task tracking and status reports.
metadata:
  {
    "openclaw":
      {
        "emoji": "📊",
        "requires": { "bins": ["python3"] }
      }
  }
---

# Project Management Skill

Track tasks and project status.

## Usage

Add task:
```python
python3 scripts/task_manager.py add --title "Task name" --priority high
```

List tasks:
```python
python3 scripts/task_manager.py list
```

Update status:
```python
python3 scripts/task_manager.py update --id 1 --status done
```

Generate report:
```python
python3 scripts/generate_report.py
```

## Features

- Task tracking
- Priority management
- Status updates
- Progress reports

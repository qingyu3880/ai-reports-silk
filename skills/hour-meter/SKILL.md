---
name: hour-meter
description: Track elapsed time from a set epoch with tamper-evident locking. Useful for tracking project duration, habits, or time-based metrics.
metadata:
  { "openclaw": { "emoji": "⏱️" } }
---

# Hour Meter Skill

Track elapsed time from a set epoch with tamper-evident locking.

## Use Cases

- Project duration tracking
- Habit streak monitoring  
- Time-based metrics
- Deadline countdown

## Commands

```bash
# Set an epoch (start time)
hour-meter set <name> [timestamp]

# Check elapsed time
hour-meter check <name>

# List all tracked epochs
hour-meter list

# Reset an epoch
hour-meter reset <name>
```

## Storage

All timestamps stored in `~/.openclaw/workspace/hour-meter-data.json` with tamper-evident checksums.

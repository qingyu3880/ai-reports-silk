---
name: email-manager
description: Email management skill for sending, reading, and organizing emails via IMAP/SMTP.
metadata:
  {
    "openclaw":
      {
        "emoji": "📧",
        "requires": { "env": ["EMAIL_IMAP_HOST", "EMAIL_SMTP_HOST", "EMAIL_USER", "EMAIL_PASS"] }
      }
  }
---

# Email Manager Skill

Manage emails via IMAP/SMTP protocols.

## Setup

Configure environment variables:
```bash
export EMAIL_IMAP_HOST="imap.example.com"
export EMAIL_SMTP_HOST="smtp.example.com"
export EMAIL_USER="your@email.com"
export EMAIL_PASS="your-password"
```

## Usage

Send email:
```python
python3 scripts/send_email.py --to recipient@example.com --subject "Subject" --body "Body"
```

Read inbox:
```python
python3 scripts/read_inbox.py --limit 10
```

## Features

- Send emails via SMTP
- Read emails via IMAP
- List inbox messages
- Search emails

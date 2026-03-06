# Skill: Error Documentation System

## Purpose
Document every mistake as a searchable, actionable skill to prevent repetition and build institutional knowledge.

## Error Entry Template

```markdown
### Error #[ID]: [Brief Title]
**Date**: YYYY-MM-DD
**Severity**: 🔴 Critical / 🟡 Warning / 🟢 Minor
**Category**: [Tool/Concept/Process]

#### What Happened
[Clear description of the error]

#### Root Cause
[Why did this happen? Technical or conceptual reason]

#### The Fix
[How was it resolved?]

#### Prevention
[How to avoid this in the future - specific checks, commands, or patterns]

#### Related Errors
- Link to similar errors
- Link to related skills

#### Tags
#error-type #tool-name #concept #date
```

## Example Entry

```markdown
### Error #001: Missing path parameter in write tool
**Date**: 2026-03-06
**Severity**: 🟡 Warning
**Category**: Tool Usage

#### What Happened
Attempted to use `write` tool without specifying `path` or `file_path` parameter, causing the operation to fail.

#### Root Cause
Confusion between `path` and `file_path` parameter names. The tool accepts either, but one must be provided.

#### The Fix
Always use `path` parameter explicitly:
```python
write({
    "path": "/root/.openclaw/workspace/filename.md",
    "content": "..."
})
```

#### Prevention
- [ ] Before calling `write`, verify `path` is set
- [ ] Use consistent parameter naming (`path` preferred)
- [ ] Test file operations in non-critical contexts first

#### Related Errors
- Error #002: File not found due to relative path issues

#### Tags
#write-tool #file-operations #parameter-validation
```

## Search Strategy

When encountering an error:
1. Search `skills/errors/` for similar patterns
2. Check `memory/` for recent related issues
3. Update this document with new error patterns
4. Cross-reference with SKILL.md files

## Maintenance

- Review monthly for patterns
- Consolidate similar errors
- Update prevention checklists
- Archive resolved error categories

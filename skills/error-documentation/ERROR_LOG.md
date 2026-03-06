# Error Log: Tool Usage Mistakes

## Error #001: Missing path parameter in write tool
**Date**: 2026-03-06
**Severity**: 🟡 Warning
**Category**: Tool Usage - File Operations

### What Happened
Attempted to use `write` tool without specifying `path` or `file_path` parameter, causing multiple failed operations. The tool calls returned errors like:
```
Missing required parameter: path (path or file_path)
```

### Root Cause
Confusion between `path` and `file_path` parameter names in the `write` tool. While the tool accepts either parameter name, at least one must be provided. I incorrectly assumed the parameter was optional or had a default value.

### The Fix
Always explicitly specify the `path` parameter:
```python
write({
    "path": "/root/.openclaw/workspace/filename.md",
    "content": "content here"
})
```

### Prevention Checklist
- [ ] Before calling `write`, verify `path` parameter is set
- [ ] Prefer `path` over `file_path` for consistency
- [ ] Verify the full absolute path is correct
- [ ] Test file operations in isolated contexts when possible

### Related Patterns
- Always check tool schemas before use
- Required parameters are truly required
- Don't assume parameter defaults exist

### Tags
#write-tool #file-operations #parameter-validation #hallucination

---

## Error #002: Assuming GitHub repository exists without verification
**Date**: 2026-03-06
**Severity**: 🟡 Warning
**Category**: Process - External Services

### What Happened
Attempted to push code to `github.com/ai-reports/ai-reports-silk.git` without first verifying the repository existed. This caused authentication errors that were initially misinterpreted as token issues.

### Root Cause
Made assumptions about infrastructure state without verification. The error message "Repository not found" was clear, but I initially suspected token permissions instead of checking repository existence.

### The Fix
Always verify repository existence before operations:
```bash
# Check if repo exists
curl -s -H "Authorization: token $TOKEN" \
  https://api.github.com/repos/OWNER/REPO | grep -q '"id"'

# Or check via git
git ls-remote https://github.com/OWNER/REPO.git 2>&1 | head -1
```

### Prevention Checklist
- [ ] Verify external resources exist before using them
- [ ] Read error messages carefully - they're usually accurate
- [ ] Distinguish between "not found" and "permission denied"
- [ ] Create resources explicitly when they don't exist

### Related Patterns
- Don't assume infrastructure is pre-configured
- External service errors: check existence before auth
- API error messages are usually correct

### Tags
#github #repository #assumption #verification

---

## Error #003: Session timeout during long-running git push
**Date**: 2026-03-06
**Severity**: 🟢 Minor
**Category**: Process - Long Operations

### What Happened
Git push operations were timing out or appearing to hang. Multiple sessions were killed due to lack of visible output, when the push was actually progressing slowly.

### Root Cause
Network latency to GitHub + large repository size caused slow push operations. The lack of immediate output led to premature session termination.

### The Fix
- Use `timeout` command with generous limits
- Allow background processes to complete
- Check process status before assuming failure
- Use `git push` with progress flags: `git push -v`

### Prevention Checklist
- [ ] Set appropriate timeouts for network operations (60-120s minimum)
- [ ] Use verbose flags to see progress
- [ ] Check process status with `process poll` before killing
- [ ] Consider async operations for long-running tasks

### Related Patterns
- Network operations are unpredictable
- Don't kill processes prematurely
- Progress visibility prevents false negatives

### Tags
#git #timeout #network #process-management

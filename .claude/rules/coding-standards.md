# Coding Standards — Universal Rules

**Purpose**: Consistent code quality across all projects

---

## General Principles

### 1. Code Quality
- Write self-documenting code (clear variable/function names)
- Keep functions small and focused (single responsibility)
- Add comments only for complex logic, not obvious code
- Follow project's existing patterns and conventions

### 2. Error Handling
- Always handle errors gracefully
- Provide meaningful error messages
- Log errors with context (timestamp, operation, details)
- Never swallow errors silently

### 3. File Organization
- Group related functionality together
- Keep file sizes reasonable (< 500 lines ideal)
- Use consistent naming conventions
- Follow project structure from project-structure.json

### 4. Testing
- Write tests for new features
- Update tests when changing functionality
- Aim for meaningful coverage, not just numbers
- Test edge cases and error conditions

---

## Language-Specific

### JavaScript/TypeScript
- Use modern ES6+ syntax
- Prefer `const` over `let`, avoid `var`
- Use async/await over callbacks
- Type everything in TypeScript

### Python
- Follow PEP 8 style guide
- Use type hints for function signatures
- Prefer list comprehensions when readable
- Use virtual environments

### Shell Scripts
- Always use `set -euo pipefail`
- Quote all variables: `"$var"`
- Check file existence before operations
- Provide meaningful exit codes

---

## Database

### Migrations
- Never modify existing migrations
- Always create new migration for changes
- Test migrations both up and down
- Document breaking changes

### Queries
- Use parameterized queries (prevent SQL injection)
- Index frequently queried columns
- Avoid N+1 queries
- Optimize for read performance

---

## Security

### Never Commit
- API keys, secrets, passwords
- Environment-specific config
- Personal information
- Debug logs with sensitive data

### Always
- Validate all user input
- Sanitize output to prevent XSS
- Use HTTPS for external requests
- Keep dependencies updated

---

**Reference**: Read when writing code, don't inject in every prompt! 📚

# Anti-Patterns — What NOT to Do

**Purpose**: Banned behaviors and common mistakes to avoid

**Token Cost**: 0 (read on-demand only)

---

## 🚫 CRITICAL: Context Duplication Anti-Patterns

### ❌ BANNED: Re-Reading Memory Files Every Turn

**The Problem**:
```
Turn 1: Load all 5 memory files (3000 lines)
Turn 2: Re-read productContext.md (600 lines) ← WASTE
Turn 3: Re-read systemPatterns.md (500 lines) ← WASTE
Turn 4: Re-read activeContext.md (400 lines) ← WASTE
Result: 4500 WASTED lines, "Prompt too long" error
```

**The Solution**:
```
Turn 1: Load all 5 memory files (3000 lines)
Turn 2: Use conversation history (0 new lines)
Turn 3: Use conversation history (0 new lines)
Turn 4: Use conversation history (0 new lines)
Result: 3000 lines total, 79.9% token reduction
```

**Rule**: Memory files are loaded ONCE at session start and persist in conversation history. NEVER re-read unless user explicitly updated a file.

---

## 🚫 Asking Questions Context Already Answers

### ❌ BANNED QUESTIONS LIST

**Framework/Tech Stack Questions**:
```
❌ "What framework are you using?"
❌ "Are you using React or Vue?"
❌ "What database are you using?"
❌ "What's your backend stack?"
✅ CHECK productContext.md → Technology Stack section
```

**File Location Questions**:
```
❌ "Where is the User model located?"
❌ "Which file has the authentication logic?"
❌ "Where should I put this component?"
❌ "What's your project structure?"
✅ CHECK codebase-map.json or project-structure.json
```

**Coding Style Questions**:
```
❌ "What's your preferred coding style?"
❌ "Should I use tabs or spaces?"
❌ "What naming convention do you use?"
❌ "How do you organize imports?"
✅ CHECK systemPatterns.md → Coding conventions
```

**Testing Questions**:
```
❌ "Should I write tests for this?"
❌ "What testing framework do you use?"
❌ "Where do tests go?"
❌ "What's your test coverage requirement?"
✅ CHECK systemPatterns.md → Testing patterns
```

**Git/Commit Questions**:
```
❌ "What commit message format do you use?"
❌ "Should I create a PR?"
❌ "What branching strategy?"
✅ CHECK systemPatterns.md → Development workflow
```

**Recent Work Questions**:
```
❌ "What did we do last session?"
❌ "What were we working on?"
❌ "What's our current focus?"
❌ "What are the active blockers?"
✅ CHECK activeContext.md → Session updates
```

---

## 🚫 Verbose Output Anti-Patterns

### ❌ BANNED: Multi-Paragraph Session Start

**Bad Example** (Token Waste):
```
[MINI-CODER-BRAIN: ACTIVE]

Welcome back to Mini-CoderBrain v2.0! I've loaded all your project context
and I'm ready to help you with your development tasks today.

Let me give you a comprehensive overview of where we are in the project...

[5 more paragraphs of verbose status...]

Your current sprint is focused on authentication, and here's what we've
accomplished so far...

[Another 3 paragraphs...]
```
**Token Cost**: ~500 tokens

**Good Example** (Efficient):
```
[MINI-CODER-BRAIN: ACTIVE]

🎯 Focus: Authentication implementation
✅ Recent: User registration, password hashing
🚀 Next: Token refresh, RBAC, integration tests
🔒 Blocker: JWT library version conflict
```
**Token Cost**: ~50 tokens (90% reduction)

---

### ❌ BANNED: Explaining Obvious Things

**Bad Example**:
```
User: "Add a comment to this function"

AI: "Certainly! I'll add a comment to explain what this function does.
     Comments are important for code documentation and help other
     developers understand the purpose and functionality of the code.
     Let me add a descriptive comment that explains the function's
     parameters, return value, and overall behavior..."
```

**Good Example**:
```
User: "Add a comment to this function"

AI: [Uses Edit tool to add comment]
```

**Rule**: Just do the task. Don't explain unless asked.

---

## 🚫 Over-Engineering Anti-Patterns

### ❌ BANNED: Suggesting Features User Didn't Ask For

**Bad Example**:
```
User: "Add user login endpoint"

AI: "I'll create the login endpoint. While I'm at it, should I also add:
     - Password reset flow?
     - Two-factor authentication?
     - OAuth integration with Google/GitHub?
     - Rate limiting for failed login attempts?
     - Session management with Redis?
     - Email verification system?"
```

**Good Example**:
```
User: "Add user login endpoint"

AI: [Creates login endpoint as requested]
    "Login endpoint complete. Should I add tests?"
```

**Rule**: Do what's asked. Suggest related work ONLY if directly relevant and simple.

---

### ❌ BANNED: Perfect-World Solutions for Simple Tasks

**Bad Example**:
```
User: "Store user's theme preference"

AI: "Let me design a comprehensive configuration management system with:
     - Database table for user preferences
     - Redis caching layer
     - Real-time WebSocket updates
     - Audit logging for preference changes
     - A/B testing framework
     - Analytics tracking"
```

**Good Example**:
```
User: "Store user's theme preference"

AI: "I'll add a 'theme' field to the users table and update the profile endpoint."
```

**Rule**: Simple requests deserve simple solutions. Don't over-engineer.

---

## 🚫 Proactive Behavior Anti-Patterns

### ❌ BANNED: Suggesting After EVERY Action

**Bad Example**:
```
Turn 1: "Fixed bug. Should I update documentation?"
Turn 2: "Updated docs. Should I write tests?"
Turn 3: "Wrote tests. Should I commit?"
Turn 4: "Committed. Should I create PR?"
Turn 5: "Created PR. Should I notify team?"
```

**Good Example**:
```
Turn 1-4: [Do the work]
Turn 5: "Bug fixed, documented, tested, and committed. Ready for PR?"
```

**Rule**: Bundle suggestions. Don't interrupt after every step.

---

### ❌ BANNED: Pushy Suggestions

**Bad Example**:
```
AI: "You should really update your memory bank now."
User: "Not right now"
AI: "Are you sure? It's been 50 operations."
User: "I'll do it later"
AI: "But the context might be lost. I strongly recommend..."
```

**Good Example**:
```
AI: "Consider: /update-memory-bank (50 ops)"
User: "Not right now"
AI: [Continues with next task, doesn't repeat]
```

**Rule**: Suggest once, accept "no" gracefully, never repeat ignored suggestions.

---

## 🚫 File Operation Anti-Patterns

### ❌ BANNED: Creating Unnecessary Files

**Bad Example**:
```
User: "Explain how authentication works"

AI: [Creates AUTH_EXPLANATION.md, AUTHENTICATION_GUIDE.md, SECURITY_NOTES.md]
```

**Good Example**:
```
User: "Explain how authentication works"

AI: [Explains in response text, no files created]
```

**Rule**: NEVER create documentation files unless explicitly requested.

---

### ❌ BANNED: Writing When You Should Edit

**Bad Example**:
```
# Existing file: src/utils.ts (500 lines)
User: "Add a new utility function"

AI: [Uses Write tool to overwrite entire file with 501 lines]
```

**Good Example**:
```
# Existing file: src/utils.ts (500 lines)
User: "Add a new utility function"

AI: [Uses Edit tool to add just the new function]
```

**Rule**: ALWAYS prefer Edit over Write for existing files.

---

## 🚫 Testing Anti-Patterns

### ❌ BANNED: No Testing

**Bad Example**:
```
User: "Add payment processing endpoint"

AI: [Creates endpoint, no tests]
     "Payment endpoint complete!"
```

**Good Example**:
```
User: "Add payment processing endpoint"

AI: [Creates endpoint AND tests]
     "Payment endpoint complete with unit and integration tests."
```

**Rule**: Critical features ALWAYS need tests. Check systemPatterns.md for testing standards.

---

### ❌ BANNED: Testing for Coverage Numbers Only

**Bad Example**:
```typescript
// Just to hit 100% coverage
test('constructor exists', () => {
  expect(new UserService()).toBeDefined();
});

test('method exists', () => {
  expect(typeof service.createUser).toBe('function');
});
```

**Good Example**:
```typescript
test('createUser validates email format', async () => {
  await expect(service.createUser({ email: 'invalid' }))
    .rejects.toThrow('Invalid email format');
});

test('createUser hashes password', async () => {
  const user = await service.createUser({ password: 'plain123' });
  expect(user.password).not.toBe('plain123');
  expect(user.password).toMatch(/^\$2[aby]\$/); // bcrypt format
});
```

**Rule**: Write tests that validate behavior, not just existence.

---

## 🚫 Git/Commit Anti-Patterns

### ❌ BANNED: Co-Author Attribution

**Bad Example**:
```bash
git commit -m "Add authentication

Co-Authored-By: Claude <noreply@anthropic.com>"
```

**Good Example**:
```bash
git commit -m "Add authentication with JWT tokens"
```

**Rule**: NEVER add co-author attribution to commits.

---

### ❌ BANNED: Vague Commit Messages

**Bad Example**:
```
"Update code"
"Fix stuff"
"Changes"
"WIP"
```

**Good Example**:
```
"Add JWT token refresh mechanism"
"Fix race condition in user registration"
"Refactor database connection pooling"
```

**Rule**: Commit messages should explain WHY and WHAT, not just "update".

---

## 🚫 Security Anti-Patterns

### ❌ BANNED: Storing Secrets in Code

**Bad Example**:
```typescript
const API_KEY = 'sk_live_abc123xyz';
const DB_PASSWORD = 'mypassword123';
```

**Good Example**:
```typescript
const API_KEY = process.env.API_KEY;
const DB_PASSWORD = process.env.DB_PASSWORD;

if (!API_KEY) throw new Error('API_KEY not configured');
```

**Rule**: ALWAYS use environment variables for secrets.

---

### ❌ BANNED: SQL Injection Vulnerability

**Bad Example**:
```typescript
const query = `SELECT * FROM users WHERE email = '${email}'`;
db.execute(query);
```

**Good Example**:
```typescript
const query = 'SELECT * FROM users WHERE email = ?';
db.execute(query, [email]);
```

**Rule**: ALWAYS use parameterized queries.

---

## 🚫 Error Handling Anti-Patterns

### ❌ BANNED: Silent Failures

**Bad Example**:
```typescript
try {
  await processPayment(amount);
} catch (error) {
  // Empty catch - error swallowed
}
```

**Good Example**:
```typescript
try {
  await processPayment(amount);
} catch (error) {
  logger.error('Payment processing failed', { amount, error });
  throw new PaymentError('Unable to process payment', { cause: error });
}
```

**Rule**: NEVER swallow errors silently. Log and/or rethrow.

---

### ❌ BANNED: Generic Error Messages

**Bad Example**:
```typescript
throw new Error('Something went wrong');
```

**Good Example**:
```typescript
throw new Error(`Failed to create user: email "${email}" already exists`);
```

**Rule**: Error messages should be specific and actionable.

---

## 🚫 Documentation Anti-Patterns

### ❌ BANNED: Obvious Comments

**Bad Example**:
```typescript
// Increment counter by 1
counter++;

// Check if user is null
if (user === null) {
  // Return false
  return false;
}
```

**Good Example**:
```typescript
counter++;

if (user === null) {
  return false;
}

// Complex algorithm explaining WHY
// Using binary search here because dataset is sorted and can exceed 10M records
// Linear search would cause O(n) performance degradation
const index = binarySearch(sortedData, target);
```

**Rule**: Comment WHY, not WHAT. Code should be self-documenting for simple logic.

---

### ❌ BANNED: Outdated Documentation

**Bad Example**:
```typescript
/**
 * Authenticates user with username and password
 * @param username - User's username
 * @param password - User's password
 */
function authenticate(email: string, token: string) { // Changed to email/token
  // Implementation using JWT, not password
}
```

**Good Example**:
```typescript
/**
 * Authenticates user with email and JWT token
 * @param email - User's email address
 * @param token - JWT authentication token
 */
function authenticate(email: string, token: string) {
  // Implementation
}
```

**Rule**: Update docs when you change code. Outdated docs are worse than no docs.

---

## 🎯 Key Principles

### DO
✅ Check context before asking
✅ Be concise in all output
✅ Edit existing files, don't overwrite
✅ Write meaningful tests
✅ Handle errors properly
✅ Use environment variables for secrets
✅ Write clear commit messages

### DON'T
❌ Re-read memory files every turn
❌ Ask questions context answers
❌ Create unnecessary files
❌ Suggest features not requested
❌ Over-engineer simple tasks
❌ Add co-author attribution
❌ Swallow errors silently

---

**Remember**: These anti-patterns cause token bloat, context loss, security issues, or bad user experience. Avoid them at all costs! 🚫

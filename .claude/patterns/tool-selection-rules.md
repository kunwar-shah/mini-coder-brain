# Tool Selection Rules — Which Tool to Use When

**Purpose**: Smart tool selection to maximize efficiency and minimize errors

**Token Cost**: 0 (read on-demand only)

---

## 🎯 Core Principle

**RULE**: Use the RIGHT tool for each task. Wrong tool = wasted operations + errors.

---

## 📖 Read vs Glob vs Grep

### Use **Read** When:
✅ You know the EXACT file path
✅ You need to see file contents
✅ Reading configuration files
✅ Analyzing specific code files
✅ Reading memory bank files

**Examples**:
```
✅ Read /home/boss/project/src/auth/login.ts
✅ Read .claude/memory/activeContext.md
✅ Read package.json
```

**DON'T use Read for**:
❌ Finding files ("Where is the User model?")
❌ Searching for code patterns
❌ Exploring project structure

---

### Use **Glob** When:
✅ Finding files by name pattern
✅ Finding files by extension
✅ Exploring project structure
✅ Locating specific files

**Examples**:
```
✅ Glob pattern="**/User.ts" (find User model)
✅ Glob pattern="**/*.test.ts" (find all test files)
✅ Glob pattern="**/auth/**/*.ts" (find auth-related files)
✅ Glob pattern="package.json" (find in any subdirectory)
```

**DON'T use Glob for**:
❌ Reading file contents
❌ Searching for code inside files
❌ When you already know the exact path

---

### Use **Grep** When:
✅ Searching for code patterns
✅ Finding function/class definitions
✅ Finding imports or usage
✅ Finding TODO comments
✅ Finding error messages

**Examples**:
```
✅ Grep pattern="class User" (find User class definition)
✅ Grep pattern="import.*express" (find Express imports)
✅ Grep pattern="TODO:" (find TODO comments)
✅ Grep pattern="throw new.*Error" (find error throws)
```

**Grep Options**:
```bash
# Case insensitive search
Grep pattern="user" -i=true

# Show line numbers
Grep pattern="function auth" -n=true output_mode="content"

# Context lines (before/after)
Grep pattern="async function" output_mode="content" -A=3 -B=2

# Filter by file type
Grep pattern="useState" type="js"
Grep pattern="def main" type="py"

# Output modes
output_mode="files_with_matches"  # Just file paths (default, fastest)
output_mode="content"             # Show matching lines
output_mode="count"               # Count matches per file
```

**DON'T use Grep for**:
❌ Finding files by name (use Glob)
❌ Reading entire files (use Read)
❌ Searching binary files

---

## 🔨 Edit vs Write

### Use **Edit** When:
✅ Modifying existing files
✅ Adding functions to existing code
✅ Updating configuration
✅ Fixing bugs in existing code
✅ 99% of code changes

**Why Edit?**:
- Surgical precision (change only what's needed)
- Preserves file structure
- Less error-prone
- Faster for small changes

**Example**:
```typescript
// File: src/user.ts (500 lines)
Edit old_string="export class User {"
     new_string="export class User implements IUser {"
```

**DON'T use Edit for**:
❌ Creating new files (use Write)
❌ When file doesn't exist yet

---

### Use **Write** When:
✅ Creating NEW files only
✅ File doesn't exist yet

**CRITICAL**: ALWAYS Read file FIRST before using Write on existing files!

**Example**:
```typescript
// Creating new file
Write file_path="/home/boss/project/src/models/Product.ts"
      content="export class Product { ... }"
```

**DON'T use Write for**:
❌ Modifying existing files (use Edit instead)
❌ Small changes to large files (very inefficient)

**Rule**: Write is for NEW files only. Edit is for EXISTING files.

---

## 💻 Bash vs Specialized Tools

### Use **Bash** When:
✅ Git operations (commit, push, status, diff)
✅ Package management (npm install, pip install)
✅ Running tests (npm test, pytest)
✅ Running builds (npm run build)
✅ Docker operations (docker build, docker-compose)
✅ Creating directories (mkdir)
✅ Moving/copying files (mv, cp)
✅ System commands (terminal operations)

**Examples**:
```bash
✅ Bash: git status
✅ Bash: npm install express
✅ Bash: docker-compose up -d
✅ Bash: pytest tests/
✅ Bash: mkdir -p src/components
```

**DON'T use Bash for**:
❌ Reading files (use Read)
❌ Searching files (use Glob/Grep)
❌ Editing files (use Edit)
❌ Writing files (use Write)
❌ Communication with user (use text output)

---

### ❌ BANNED Bash Commands

These have specialized tools - USE THEM:

```bash
❌ cat file.txt           → Use Read tool
❌ head -n 20 file.txt    → Use Read tool with limit
❌ tail -n 50 file.txt    → Use Read tool with offset
❌ grep "pattern" file    → Use Grep tool
❌ find . -name "*.ts"    → Use Glob tool
❌ ls -R                  → Use Glob tool
❌ sed 's/old/new/' file  → Use Edit tool
❌ echo "content" > file  → Use Write tool
❌ echo "message"         → Use text output directly
```

**Why?** Specialized tools are:
- Faster
- More reliable
- Better formatted output
- Integrated with IDE

---

## 🔍 Task vs Direct Tools

### Use **Task (Agent)** When:
✅ Open-ended research requiring multiple searches
✅ Complex multi-step tasks
✅ Uncertain search requiring multiple attempts
✅ Codebase exploration (many files)
✅ Finding patterns across many files

**Examples**:
```
✅ "Find all authentication implementations in codebase"
✅ "Research how error handling is done across project"
✅ "Find all database query patterns"
✅ "Locate all API endpoints"
```

**Task Parameters**:
```typescript
Task(
  description: "Find auth implementations",
  prompt: "Search codebase for authentication logic...",
  subagent_type: "general-purpose"
)
```

**DON'T use Task for**:
❌ Reading a specific known file (use Read)
❌ Simple single grep (use Grep)
❌ Finding one specific file (use Glob)
❌ Quick file edits (use Edit)

---

### Use **Direct Tools** When:
✅ You know exactly what to do
✅ Single operation needed
✅ Specific file path known
✅ Simple search pattern

**Rule**: Try direct tools FIRST. Use Task only if direct approach would require many iterations.

---

## 📝 TodoWrite Usage

### Use **TodoWrite** When:
✅ Task has 3+ distinct steps
✅ User provides multiple tasks (numbered or comma-separated)
✅ Complex non-trivial tasks requiring planning
✅ User explicitly requests todo list
✅ Multi-step feature implementation

**Examples**:
```
✅ User: "Add authentication, tests, and documentation"
   → Use TodoWrite (3 distinct tasks)

✅ User: "Implement dark mode toggle, update settings, run tests"
   → Use TodoWrite (multiple tasks)

✅ User: "Build payment integration"
   → Use TodoWrite (complex, multi-step)
```

**DON'T use TodoWrite for**:
❌ Single simple tasks ("add a comment")
❌ Trivial operations ("rename variable")
❌ Tasks with < 3 steps
❌ Purely informational requests

---

### TodoWrite Rules

**Task States**:
- `pending`: Not started yet
- `in_progress`: Currently working on (ONLY ONE at a time)
- `completed`: Finished successfully

**CRITICAL**:
- Exactly ONE task must be in_progress at any time
- Mark tasks completed IMMEDIATELY after finishing
- Update status in real-time as you work

**Example**:
```typescript
TodoWrite({
  todos: [
    {
      content: "Create authentication endpoint",
      activeForm: "Creating authentication endpoint",
      status: "in_progress"
    },
    {
      content: "Write tests for authentication",
      activeForm: "Writing tests for authentication",
      status: "pending"
    },
    {
      content: "Update documentation",
      activeForm: "Updating documentation",
      status: "pending"
    }
  ]
})
```

---

## 🌐 WebFetch vs WebSearch

### Use **WebFetch** When:
✅ You have a specific URL
✅ Need to read documentation page
✅ Fetching API documentation
✅ Reading specific article/guide
✅ Getting content from known source

**Example**:
```typescript
WebFetch(
  url: "https://docs.example.com/api/authentication",
  prompt: "Extract authentication methods and examples"
)
```

---

### Use **WebSearch** When:
✅ Need to find information (don't have URL)
✅ Looking for latest documentation
✅ Searching for solutions/tutorials
✅ Finding current best practices
✅ Researching technologies

**Example**:
```typescript
WebSearch(
  query: "Next.js 14 authentication best practices 2025"
)
```

**Search Tips**:
- Include year for latest docs (2025)
- Be specific ("Next.js 14" not just "Next.js")
- Filter domains if needed: `allowed_domains: ["docs.nextjs.org"]`

---

## 🎯 Decision Tree

### "I need to find a file"
```
Do you know the exact path?
├─ YES → Read
└─ NO → Do you know the filename?
    ├─ YES → Glob (pattern="**/filename.ts")
    └─ NO → Do you know what's inside?
        ├─ YES → Grep (search for code pattern)
        └─ NO → Task (agent to explore codebase)
```

### "I need to modify code"
```
Does the file exist?
├─ NO → Write (create new file)
└─ YES → Have you read it in this session?
    ├─ NO → Read first, then Edit
    └─ YES → Edit directly
```

### "I need to search for something"
```
Searching for what?
├─ File by name → Glob
├─ Code inside files → Grep
├─ General research → WebSearch or Task
└─ Specific URL → WebFetch
```

### "I need to run a command"
```
What type of command?
├─ Git/npm/docker/system → Bash
├─ Read file → Read tool (NOT cat)
├─ Search files → Grep tool (NOT grep command)
├─ Find files → Glob tool (NOT find)
└─ Edit file → Edit tool (NOT sed)
```

---

## 🚀 Parallel vs Sequential

### Run in **Parallel** When:
✅ Operations are independent
✅ Don't need results from each other
✅ Can execute simultaneously

**Example**:
```typescript
// Single message with multiple tools
Read file_path="package.json"
Read file_path="tsconfig.json"
Grep pattern="import.*express"
Glob pattern="**/*.test.ts"
```

---

### Run **Sequentially** When:
✅ Operations depend on previous results
✅ Need output from one to inform next
✅ Order matters

**Example**:
```typescript
// Must be sequential
1. Read file (need to see current content)
2. Edit file (based on what we read)
3. Bash: git add file && git commit (depends on edit completing)
```

**Rule**: Use `&&` in Bash to chain dependent commands:
```bash
✅ git add . && git commit -m "..." && git push
❌ git add . ; git commit -m "..." ; git push
```

---

## 📊 Tool Selection Cheat Sheet

| Task | First Choice | Fallback | Never Use |
|------|-------------|----------|-----------|
| Read known file | Read | - | cat, head, tail |
| Find file by name | Glob | Task | find, ls |
| Search code | Grep | Task | grep, rg |
| Create new file | Write | - | echo >, cat <<EOF |
| Modify existing file | Edit | Read + Write | sed, awk |
| Git operations | Bash | - | Manual file edits |
| Install packages | Bash | - | Manual downloads |
| Run tests | Bash | - | Manual execution |
| Find files + search code | Grep + Glob | Task | find + grep |
| Multi-step research | Task | Multiple tools | Single Grep |
| Communicate with user | Text output | - | echo, printf |

---

## 🎯 Key Principles

1. **Right Tool for Right Job**: Each tool has a purpose
2. **Specialized > Generic**: Use Read not cat, Grep not grep command
3. **Parallel When Possible**: Run independent operations together
4. **Sequential When Necessary**: Chain dependent operations with &&
5. **Read Before Edit**: Always read existing files before editing
6. **Edit Over Write**: Edit existing files, Write only for new files
7. **Glob Before Grep**: Find files first, then search contents
8. **Direct Before Task**: Try simple tools first, agent as fallback

---

**Remember**: Choosing the right tool makes you faster, more reliable, and more efficient! 🚀

# Placeholder Filling Guide

**Purpose**: Complete reference for all placeholders in Mini-CoderBrain and how they get filled

---

## 📋 All Placeholders Reference

### productContext.md

| Placeholder | Example Value | How It Gets Filled | When |
|-------------|---------------|-------------------|------|
| `[PROJECT_NAME]` | "TaskMaster Pro" | `/init-memory-bank` prompts user | Day 1 setup |
| `[AUTO_GENERATED]` | "2025-10-17 09:30:00 UTC" | `/init-memory-bank` inserts timestamp | Day 1 setup |
| `[AUTO_DETECTED]` | "Full-Stack Web Application" | `/init-memory-bank` scans files | Day 1 setup |
| `[ONE_LINE_DESCRIPTION]` | "Advanced task management SaaS" | User provides during init | Day 1 setup |
| `[FEATURE_1]` | "Real-time collaborative boards" | User provides during init | Day 1 setup |
| `[FEATURE_2]` | "AI-powered prioritization" | User provides during init | Day 1 setup |
| `[FEATURE_3]` | "Team analytics" | User provides during init | Day 1 setup |
| `[FRAMEWORK/LIBRARY]` | "Next.js 14 + TypeScript" | Auto-detected from package.json | Day 1 setup |
| `[DATABASE]` | "PostgreSQL 15" | Auto-detected from dependencies | Day 1 setup |
| `[INFRASTRUCTURE]` | "Vercel + Supabase" | User provides or auto-detected | Day 1 setup |
| `[PROJECT_ROOT]` | "taskmaster-pro/" | Auto-detected from git root | Day 1 setup |
| `[DETECTED_FRONTEND_PATH]` | "src/app/" | Auto-detected by scanning | Day 1 setup |
| `[DETECTED_BACKEND_PATH]` | "src/api/" | Auto-detected by scanning | Day 1 setup |
| `[DETECTED_DATABASE_PATH]` | "prisma/" | Auto-detected by scanning | Day 1 setup |
| `[DETECTED_TESTS_PATH]` | "src/__tests__/" | Auto-detected by scanning | Day 1 setup |
| `[DETECTED_DOCS_PATH]` | "docs/" | Auto-detected by scanning | Day 1 setup |
| `[CURRENT_DEVELOPMENT_PHASE]` | "MVP Development" | User provides during init | Day 1 setup |
| `[METRIC_1]` | "80% test coverage" | User provides during init | Day 1 setup |
| `[METRIC_2]` | "< 2s page load time" | User provides during init | Day 1 setup |
| `[METRIC_3]` | "95% uptime" | User provides during init | Day 1 setup |
| `[ADDITIONAL_CONTEXT_AND_NOTES]` | Custom notes | User provides during init | Day 1 setup |

---

### activeContext.md

| Placeholder | Example Value | How It Gets Filled | When |
|-------------|---------------|-------------------|------|
| `[PROJECT_NAME]` | "TaskMaster Pro" | Copied from productContext | Day 1 setup |
| `[AUTO_GENERATED]` | "2025-10-17 14:30:00 UTC" | Updated by hooks | Every session |
| `[SPRINT_NAME]` | "Sprint 12 - Authentication" | User updates manually | Start of sprint |
| `[INSIGHT_1]` | "JWT tokens better than sessions" | Added during development | As learned |
| `[INSIGHT_2]` | "Prisma migrations are fast" | Added during development | As learned |
| `[INSIGHT_3]` | "Tailwind speeds up styling" | Added during development | As learned |
| `[TASK_1]` | "Add token refresh endpoint" | Added during development | As needed |
| `[TASK_2]` | "Write auth integration tests" | Added during development | As needed |
| `[TASK_3]` | "Document API endpoints" | Added during development | As needed |
| `[TASK_4]` | "Deploy to staging" | Added during development | As needed |

---

### systemPatterns.md

| Placeholder | Example Value | How It Gets Filled | When |
|-------------|---------------|-------------------|------|
| `[PROJECT_NAME]` | "TaskMaster Pro" | Copied from productContext | Day 1 setup |
| `[AUTO_GENERATED]` | "2025-10-17 09:30:00 UTC" | `/init-memory-bank` | Day 1 setup |
| `[PRINCIPLE_1]` | "API-First Design" | User documents | Day 1-7 |
| `[PRINCIPLE_2]` | "Mobile-First UI" | User documents | Day 1-7 |
| `[PRINCIPLE_3]` | "Test-Driven Development" | User documents | Day 1-7 |
| `[STRUCTURE_PATTERN]` | "Feature-based folders" | Auto-detected or user provides | Day 1 setup |
| `[CONVENTION]` | "Co-located tests" | Auto-detected from tests | Day 1 setup |
| `[STANDARDS]` | "camelCase for variables" | User documents | Day 1-7 |
| `[STACK_DETAILS]` | "Next.js 14 App Router" | Auto-detected | Day 1 setup |
| `[TOOLS]` | "Turbopack, SWC" | Auto-detected from config | Day 1 setup |
| `[MANAGER]` | "pnpm" | Auto-detected from lockfile | Day 1 setup |
| `[FRAMEWORK]` | "Vitest + React Testing Library" | Auto-detected from devDeps | Day 1 setup |
| `[ORGANIZATION]` | "Co-located __tests__/" | Auto-detected by scanning | Day 1 setup |
| `[PERCENTAGE]` | "80%" | User provides or default | Day 1 setup |
| `[ERROR_HANDLING_STRATEGY]` | "try-catch with custom errors" | User documents | Week 1 |
| `[LOGGING_APPROACH]` | "Winston + structured logs" | Auto-detected or user provides | Day 1 setup |
| `[MONITORING_TOOLS]` | "Sentry + Vercel Analytics" | User documents | Week 1 |
| `[IMPLEMENTATION]` | "JWT tokens" | User documents | Week 1 |
| `[APPROACH]` | "HTTPS + helmet middleware" | User documents | Week 1 |
| `[GIT_STRATEGY]` | "Feature branches + PR reviews" | User provides | Day 1 setup |
| `[BRANCHING_MODEL]` | "feature/*, fix/*" | User provides | Day 1 setup |
| `[PROCESS]` | "2 approvals required" | User provides | Day 1 setup |
| `[TOOL_AND_PROCESS]` | "GitHub Actions + Vercel" | Auto-detected or user provides | Day 1 setup |
| `[STRATEGY]` | "Preview on PR, auto-deploy main" | User documents | Week 1 |
| `[FUTURE_PATTERN_1]` | "Move to microservices" | User adds as project evolves | Month 1+ |
| `[FUTURE_PATTERN_2]` | "Add GraphQL layer" | User adds as project evolves | Month 1+ |

---

### progress.md

| Placeholder | Example Value | How It Gets Filled | When |
|-------------|---------------|-------------------|------|
| `[PROJECT_NAME]` | "TaskMaster Pro" | Copied from productContext | Day 1 setup |
| `[AUTO_GENERATED]` | "2025-10-17 14:30:00 UTC" | Updated by hooks | Every session |
| `[DEVELOPMENT_PHASE]` | "MVP Development" | User provides | Day 1 setup |
| `[NEXT_SPRINT_GOALS]` | "Sprint 13 - Payments" | User updates | End of sprint |
| `[SPRINT_OBJECTIVE]` | "Stripe integration" | User updates | Start of sprint |
| `[MAJOR_ACHIEVEMENT_1]` | "Auth system complete" | Added when done | As achieved |
| `[MAJOR_ACHIEVEMENT_2]` | "Database optimized" | Added when done | As achieved |
| `[INFRASTRUCTURE_WORK_1]` | "CI/CD pipeline setup" | Added when done | As achieved |
| `[INFRASTRUCTURE_WORK_2]` | "Monitoring configured" | Added when done | As achieved |
| `[RESOLVED_BLOCKER_1]` | "JWT library bug" | Added when resolved | As resolved |
| `[RESOLUTION]` | "Upgraded to v5.0.1" | Added when resolved | As resolved |
| `[ACTIVE_BLOCKER_1]` | "Redis connection issues" | Added when encountered | As encountered |
| `[STATUS]` | "Investigating timeout settings" | Updated as progress made | Ongoing |
| `[METRIC_1]` | "Test coverage: 82%" | Updated regularly | Weekly |
| `[METRIC_2]` | "Build time: 45s" | Updated regularly | Weekly |
| `[METRIC_3]` | "Lighthouse score: 92" | Updated regularly | Weekly |
| `[VELOCITY_METRIC]` | "15 story points completed" | Updated end of sprint | Sprint end |
| `[LOW/MEDIUM/HIGH]` | "LOW" | User assesses | Weekly |
| `[DESCRIPTION]` | "On track for Q1 launch" | User provides | Weekly |
| `[HIGH_LEVEL_PROJECT_STATUS]` | "MVP 80% complete" | User updates | Monthly |

---

### decisionLog.md

| Placeholder | Example Value | How It Gets Filled | When |
|-------------|---------------|-------------------|------|
| `[PROJECT_NAME]` | "TaskMaster Pro" | Copied from productContext | Day 1 setup |
| `[YYYY-MM-DD HH:MM:SS UTC]` | "2025-10-17 09:30:00 UTC" | Added when decision made | As decided |
| `[ADR-YYYYMMDD-NN]` | "ADR-20251017-01" | Auto-generated format | As decided |
| `[DECISION_TITLE]` | "Switch from REST to GraphQL" | User or Claude writes | As decided |
| `[WHAT_WAS_DECIDED]` | "Adopt GraphQL for API layer" | User or Claude writes | As decided |
| `[WHY_THIS_DECISION_WAS_MADE]` | "Better frontend flexibility" | User or Claude writes | As decided |
| `[EXPECTED_IMPACT]` | "Reduced overfetching, faster UI" | User or Claude writes | As decided |
| `[HOW_TO_IMPLEMENT]` | "Apollo Server + Client setup" | User or Claude writes | As decided |
| `[REQUIRED_FOLLOW_UP_ACTIONS]` | "Migrate all REST endpoints" | User or Claude writes | As decided |

---

## 🔧 Automatic Detection Logic

### Technology Stack Detection

```bash
# package.json present → Node.js project
if [ -f "package.json" ]; then
    # Check dependencies
    if grep -q "next" package.json; then FRAMEWORK="Next.js"; fi
    if grep -q "react" package.json; then FRAMEWORK="React"; fi
    if grep -q "vue" package.json; then FRAMEWORK="Vue"; fi

    # Check testing
    if grep -q "vitest" package.json; then TESTING="Vitest"; fi
    if grep -q "jest" package.json; then TESTING="Jest"; fi

    # Check database
    if grep -q "prisma" package.json; then DATABASE="Prisma + PostgreSQL"; fi
    if grep -q "mongoose" package.json; then DATABASE="MongoDB + Mongoose"; fi
fi

# requirements.txt present → Python project
if [ -f "requirements.txt" ]; then
    if grep -q "django" requirements.txt; then FRAMEWORK="Django"; fi
    if grep -q "flask" requirements.txt; then FRAMEWORK="Flask"; fi
    if grep -q "fastapi" requirements.txt; then FRAMEWORK="FastAPI"; fi
fi

# Cargo.toml present → Rust project
if [ -f "Cargo.toml" ]; then
    FRAMEWORK="Rust"
    if grep -q "actix-web" Cargo.toml; then FRAMEWORK="Actix Web"; fi
    if grep -q "rocket" Cargo.toml; then FRAMEWORK="Rocket"; fi
fi
```

### Project Structure Detection

```bash
# Find frontend path
for dir in src/app src/pages src/components app frontend client; do
    if [ -d "$dir" ]; then
        FRONTEND_PATH="$dir"
        break
    fi
done

# Find backend path
for dir in src/api src/server api backend server; do
    if [ -d "$dir" ]; then
        BACKEND_PATH="$dir"
        break
    fi
done

# Find database path
for dir in prisma migrations database db; do
    if [ -d "$dir" ]; then
        DATABASE_PATH="$dir"
        break
    fi
done

# Find tests path
for dir in tests __tests__ test spec; do
    if [ -d "$dir" ]; then
        TESTS_PATH="$dir"
        break
    fi
done
```

---

## 📝 User Input Collection

### Interactive Prompts (During `/init-memory-bank`)

```bash
# Prompt 1: Project Name
echo "What's your project name?"
read -r PROJECT_NAME

# Prompt 2: Description
echo "Describe your project in one sentence:"
read -r PROJECT_DESCRIPTION

# Prompt 3: Core Features
echo "List 3-5 core features (comma-separated):"
read -r FEATURES
# Convert to array: IFS=',' read -ra FEATURES_ARRAY <<< "$FEATURES"

# Prompt 4: Development Phase
echo "Current development phase (e.g., MVP, Beta, Production):"
read -r DEV_PHASE

# Prompt 5: Success Metrics
echo "What metrics define success? (comma-separated)"
read -r METRICS
```

---

## 🎯 Mini-CoderBrain's Own Placeholders

### Should We Fill Them?

**YES!** Here's what they should be:

| Placeholder | Mini-CoderBrain Value |
|-------------|----------------------|
| `[PROJECT_NAME]` | "Mini-CoderBrain" |
| `[PROJECT_TYPE]` | "Developer Tool / Claude Code Extension" |
| `[ONE_LINE_DESCRIPTION]` | "Universal AI context awareness system for Claude Code" |
| `[FEATURE_1]` | "Persistent memory across sessions" |
| `[FEATURE_2]` | "Zero-token behavioral pattern library" |
| `[FEATURE_3]` | "Smart memory cleanup & optimization" |
| `[FRAMEWORK/LIBRARY]` | "Bash scripts + Markdown templates" |
| `[DATABASE]` | "File-based (memory bank in .claude/memory/)" |
| `[INFRASTRUCTURE]` | "Git + GitHub + GitHub Pages" |
| `[CURRENT_DEVELOPMENT_PHASE]` | "v2.1 Testing & v2.2 Development" |

---

## ✅ Filling Process Summary

### Timeline

**Day 0**: Installation
- Copy `.claude/` folder
- Copy `CLAUDE.md`
- All files have placeholders ❌

**Day 1**: Initialization
- Run `/init-memory-bank`
- Automatic detection runs
- User provides missing info
- Memory files populated ✅

**Day 2-7**: Active Development
- Claude uses filled memory files
- Updates activeContext.md automatically
- Adds to decisionLog.md as decisions made
- User documents patterns in systemPatterns.md

**Week 2+**: Maintenance
- Run `/memory-sync` after major work
- Run `/memory-cleanup` when bloated
- Update progress.md with milestones
- Refine systemPatterns.md as conventions solidify

---

## 🚀 Best Practices

### 1. Fill Placeholders ASAP
Don't leave placeholders - run `/init-memory-bank` immediately after installation

### 2. Keep Updating
Memory files are LIVING DOCUMENTS:
- Update activeContext when focus changes
- Add to decisionLog when making technical decisions
- Refine systemPatterns as conventions emerge

### 3. Be Specific
Instead of:
```markdown
[FEATURE_1] → "User management"  ❌ Too vague
```

Do this:
```markdown
[FEATURE_1] → "Role-based user authentication with JWT + OAuth2"  ✅ Specific
```

### 4. Use Real Examples
Instead of:
```markdown
[PRINCIPLE_1] → "Write good code"  ❌ Generic
```

Do this:
```markdown
[PRINCIPLE_1] → "API-First: All features exposed via REST API before UI implementation"  ✅ Actionable
```

---

## 📚 Next Steps for Mini-CoderBrain

1. **Fill our own placeholders** - Run `/init-memory-bank` on mini-coder-brain
2. **Test the flow** - Verify placeholders get filled correctly
3. **Document in README** - Add "Quick Start" guide with `/init-memory-bank`
4. **Improve detection** - Make auto-detection smarter (more frameworks, better scanning)

---

**Key Takeaway**: Placeholders are TEMPORARY - they exist ONLY until `/init-memory-bank` runs. In production use, users should NEVER see placeholders!

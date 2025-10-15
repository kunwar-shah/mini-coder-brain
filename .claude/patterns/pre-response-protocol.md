# Pre-Response Protocol

**Purpose**: Mandatory checklist before every response to ensure context-aware behavior

**Token Cost**: 0 (read on-demand only)

---

## 🧠 MANDATORY 5-STEP CHECKLIST

Before responding to ANY user request, you MUST complete these steps:

### 1. ✅ CHECK productContext.md
**Look for**: Project name, tech stack, architecture, core features

### 2. ✅ CHECK systemPatterns.md
**Look for**: Coding patterns, conventions, testing standards, commit formats

### 3. ✅ CHECK activeContext.md
**Look for**: Current focus, recent achievements, what we just did last session

### 4. ✅ CHECK project-structure.json
**Look for**: File locations (frontend, backend, database, tests paths)

### 5. ✅ CHECK codebase-map.json (if exists)
**Look for**: Specific file locations for models, components, utilities

---

## 🚫 BANNED QUESTIONS

Context already has these answers - NEVER ask:

| ❌ Banned Question | ✅ Correct Action |
|-------------------|-------------------|
| "What framework are you using?" | CHECK productContext.md |
| "Where is the User model?" | CHECK codebase-map.json |
| "What's your coding style?" | CHECK systemPatterns.md |
| "What did we do last session?" | CHECK activeContext.md |
| "Should I create tests?" | CHECK systemPatterns.md |
| "What commit format?" | CHECK systemPatterns.md |

---

## 📋 ZERO ASSUMPTION RULE

**Decision Tree**:
```
Question arises
    ↓
Is answer in loaded context files?
    ↓ YES → USE IT IMMEDIATELY
    ↓ NO  → Search conversation history
    ↓ STILL NO → Ask user (genuinely missing)
```

---

## ✅ CORRECT BEHAVIOR EXAMPLES

### Example 1: Add Authentication
```
User: "Add authentication"

WRONG ❌:
You: "What framework are you using?"

CORRECT ✅:
You: [CHECK productContext.md → "Next.js 14 + Prisma"]
You: [CHECK systemPatterns.md → "Uses Zod validation"]
You: [Implement Next.js auth with Prisma + Zod, no questions]
```

### Example 2: Update Model
```
User: "Update the User model"

WRONG ❌:
You: "Where is your User model located?"

CORRECT ✅:
You: [CHECK codebase-map.json → "src/lib/db/schema/user.ts"]
You: [Open file, make changes, no questions]
```

### Example 3: Write Tests
```
User: "Write tests for this function"

WRONG ❌:
You: "What testing framework do you prefer?"

CORRECT ✅:
You: [CHECK systemPatterns.md → "Vitest, colocated __tests__/"]
You: [Create tests following that pattern, no questions]
```

---

## ⚡ KEY PRINCIPLE

**ONLY AFTER completing all 5 checks** → Respond to user

**NEVER ask for information that's in loaded context**

---

**This pattern is the CORE of Mini-CoderBrain's intelligence.**

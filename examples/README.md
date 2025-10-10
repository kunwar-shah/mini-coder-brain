# Mini-CoderBrain Examples

Example integrations showing Mini-CoderBrain in action across different project types.

---

## 📂 Available Examples

### 1. [React App](react-app/)
- **Project Type**: Frontend (React + TypeScript)
- **Features**: Component development, state management, routing
- **Shows**: Auto-detection of frontend structure, instant codebase mapping

### 2. [Python Django](python-django/)
- **Project Type**: Backend (Python Django)
- **Features**: REST API, database models, authentication
- **Shows**: Backend path detection, database awareness, API development flow

### 3. [Rust CLI](rust-cli/)
- **Project Type**: CLI Tool (Rust)
- **Features**: Command-line parsing, file operations
- **Shows**: Rust project detection, cargo integration, module navigation

---

## 🚀 How to Use Examples

### Quick Start

```bash
# Clone Mini-CoderBrain
git clone https://github.com/yourusername/mini-coder-brain.git
cd mini-coder-brain

# Install to an example project
./install.sh examples/react-app
# or
./install.sh examples/python-django
# or
./install.sh examples/rust-cli

# Open in Claude Code
# Navigate to the example directory and start Claude Code
```

### What Each Example Demonstrates

#### React App Example
```bash
cd examples/react-app

# After Mini-CoderBrain installation:
# - Auto-detects: src/, components/, pages/, public/
# - Maps: Component hierarchy, state flow, routing structure
# - Commands ready: /map-codebase for instant component access
```

#### Python Django Example
```bash
cd examples/python-django

# After Mini-CoderBrain installation:
# - Auto-detects: models/, views/, api/, migrations/, admin/
# - Maps: Database schema, API endpoints, admin interface
# - Commands ready: /map-database for schema awareness
```

#### Rust CLI Example
```bash
cd examples/rust-cli

# After Mini-CoderBrain installation:
# - Auto-detects: src/, Cargo.toml, modules
# - Maps: Module structure, dependencies, build config
# - Commands ready: /map-codebase for module navigation
```

---

## 📊 Performance Comparison

### Without Mini-CoderBrain
```
❌ Manual context loading every session
❌ "Prompt is too long" after 15-20 minutes
❌ No project structure awareness
❌ Degraded AI responses over time
```

### With Mini-CoderBrain
```
✅ Auto-context loading (once per session)
✅ 100+ turn conversations (no errors)
✅ Full project structure mapped
✅ Consistent AI quality throughout
```

---

## 🧪 Testing the Examples

### Step 1: Install
```bash
./install.sh examples/react-app
```

### Step 2: Open in Claude Code
```bash
cd examples/react-app
# Open Claude Code here
```

### Step 3: Verify Installation
Look for:
```
🧠 [CODERBRAIN: ACTIVE] - react-app
🎯 Focus: [Current development focus]
📂 Context: .claude/memory/ (loaded)
⚡ Ready for development
```

### Step 4: Test Commands
```
/memory-sync
/context-update focus "Testing Mini-CoderBrain example"
/map-codebase --rebuild
/memory-cleanup --dry-run
```

### Step 5: Test Multi-Turn Conversation
Ask Claude 10+ questions about the project:
- "Show me the project structure"
- "Where are the React components?"
- "Explain the state management approach"
- etc.

**Expected**: No "Prompt is too long" errors, consistent quality

---

## 📝 Example Project Structures

### React App
```
react-app/
├── .claude/              # Mini-CoderBrain system
├── CLAUDE.md            # Controller
├── src/
│   ├── components/
│   ├── pages/
│   ├── hooks/
│   ├── utils/
│   └── App.tsx
├── public/
└── package.json
```

### Python Django
```
python-django/
├── .claude/              # Mini-CoderBrain system
├── CLAUDE.md            # Controller
├── myproject/
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── myapp/
│   ├── models.py
│   ├── views.py
│   ├── admin.py
│   └── urls.py
├── manage.py
└── requirements.txt
```

### Rust CLI
```
rust-cli/
├── .claude/              # Mini-CoderBrain system
├── CLAUDE.md            # Controller
├── src/
│   ├── main.rs
│   ├── cli.rs
│   ├── commands/
│   └── utils/
├── Cargo.toml
└── Cargo.lock
```

---

## 🎯 Learning Path

**Beginner**: Start with React App
- Familiar structure for most developers
- Clear component hierarchy
- Easy to understand context flow

**Intermediate**: Try Python Django
- Backend development patterns
- Database awareness features
- API development workflow

**Advanced**: Explore Rust CLI
- Systems programming context
- Module system navigation
- Performance-critical codebase

---

## 🤝 Contributing Examples

Want to add an example? We'd love to see:
- Vue.js / Svelte apps
- FastAPI / Flask backends
- Go microservices
- Mobile apps (React Native / Flutter)
- Monorepo setups

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

---

## 📚 Additional Resources

- [Installation Guide](../INSTALLATION.md)
- [System Documentation](../docs/CLAUDE.md)
- [Performance Metrics](../README.md#performance)

---

**Examples maintained by the Mini-CoderBrain community** 🚀

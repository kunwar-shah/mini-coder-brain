# React App Example - Mini-CoderBrain

Example React + TypeScript application with Mini-CoderBrain integration.

## 🚀 Quick Start

```bash
# From mini-coder-brain root:
./install.sh examples/react-app

# Open in Claude Code:
cd examples/react-app
```

## 📋 What's Demonstrated

- ✅ **Auto-Detection**: Frontend structure (src/, components/, pages/)
- ✅ **Component Mapping**: Instant access to all React components
- ✅ **State Management**: Context API / Redux detection
- ✅ **Routing**: React Router navigation structure
- ✅ **TypeScript Integration**: Type-aware development

## 🎯 Features to Try

### 1. Component Development
Ask Claude:
- "Create a new Button component with TypeScript props"
- "Add dark mode support to the theme"
- "Build a modal component with accessibility"

### 2. State Management
Ask Claude:
- "Show me the global state structure"
- "Add a new user context"
- "Explain the data flow in the app"

### 3. Codebase Navigation
Use commands:
```
/map-codebase --rebuild
/map-codebase          # Instant access to all files
```

## 📊 Expected Performance

- **Context Loading**: < 1 second
- **Conversation Length**: 100+ turns without errors
- **Memory Usage**: Optimized with auto-cleanup

## 🧪 Testing Mini-CoderBrain

1. Start conversation
2. Ask 10+ questions about the codebase
3. Verify no "Prompt is too long" errors
4. Check consistent AI quality

## 📂 Project Structure

```
react-app/
├── .claude/              # Mini-CoderBrain (installed via install.sh)
├── CLAUDE.md            # Controller (installed via install.sh)
├── src/
│   ├── components/
│   │   ├── Button.tsx
│   │   ├── Header.tsx
│   │   └── Modal.tsx
│   ├── pages/
│   │   ├── Home.tsx
│   │   └── About.tsx
│   ├── hooks/
│   │   └── useTheme.ts
│   ├── utils/
│   │   └── helpers.ts
│   ├── App.tsx
│   └── index.tsx
├── public/
│   └── index.html
├── package.json
└── tsconfig.json
```

## 📝 Note

This is a placeholder example structure.

For a full working example:
1. Create a React app: `npx create-react-app my-app --template typescript`
2. Install Mini-CoderBrain: `./install.sh path/to/my-app`
3. Experience the difference!

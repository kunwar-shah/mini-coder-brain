# Rust CLI Tool Example - Mini-CoderBrain

Example Rust CLI application with Mini-CoderBrain integration.

## 🚀 Quick Start

```bash
# From mini-coder-brain root:
./install.sh examples/rust-cli

# Open in Claude Code:
cd examples/rust-cli
```

## 📋 What's Demonstrated

- ✅ **Auto-Detection**: Rust project structure (src/, Cargo.toml)
- ✅ **Module Mapping**: Cargo workspace and module hierarchy
- ✅ **Dependency Tracking**: Crate dependencies and features
- ✅ **Build System**: Cargo integration and build targets

## 🎯 Features to Try

### 1. CLI Development
Ask Claude:
- "Add a new subcommand for file processing"
- "Implement argument parsing with clap"
- "Add progress bar for long operations"

### 2. Module Organization
Ask Claude:
- "Refactor into separate modules"
- "Create a new utils module"
- "Organize code into commands/"

### 3. Codebase Navigation
Use commands:
```
/map-codebase --rebuild
/map-codebase          # Instant module access
```

## 📊 Expected Performance

- **Context Loading**: < 1 second
- **Conversation Length**: 100+ turns without errors
- **Rust-Specific**: Lifetime and borrow checker awareness

## 🧪 Testing Mini-CoderBrain

1. Start conversation
2. Ask about module structure
3. Request new feature implementation
4. Verify Rust-specific context maintained

## 📂 Project Structure

```
rust-cli/
├── .claude/              # Mini-CoderBrain (installed via install.sh)
├── CLAUDE.md            # Controller (installed via install.sh)
├── src/
│   ├── main.rs
│   ├── cli.rs
│   ├── commands/
│   │   ├── mod.rs
│   │   ├── init.rs
│   │   └── run.rs
│   └── utils/
│       ├── mod.rs
│       ├── config.rs
│       └── logger.rs
├── Cargo.toml
├── Cargo.lock
└── README.md
```

## 📝 Note

This is a placeholder example structure.

For a full working example:
1. Create Rust project: `cargo new my-cli`
2. Add dependencies to Cargo.toml
3. Install Mini-CoderBrain: `./install.sh path/to/my-cli`
4. Experience the difference!

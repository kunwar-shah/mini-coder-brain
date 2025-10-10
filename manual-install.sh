#!/usr/bin/env bash
# Mini-CoderBrain - Simple Manual Installer
# Use this if the main installer fails

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_PATH="${1:-}"

if [ -z "$TARGET_PATH" ]; then
    echo "Usage: ./manual-install.sh /path/to/your/project"
    exit 1
fi

echo "📦 Installing Mini-CoderBrain to: $TARGET_PATH"
echo ""

# Step 1: Copy .claude folder
echo "1️⃣  Copying .claude folder..."
cp -r "$SCRIPT_DIR/.claude" "$TARGET_PATH/"
echo "   ✅ Done"

# Step 2: Copy CLAUDE.md
echo "2️⃣  Copying CLAUDE.md..."
cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET_PATH/"
echo "   ✅ Done"

# Step 3: Initialize memory from templates
echo "3️⃣  Initializing memory bank from templates..."
for template in "$TARGET_PATH/.claude/memory/templates"/*-template.md; do
    if [ -f "$template" ]; then
        filename=$(basename "$template" | sed 's/-template//')
        cp "$template" "$TARGET_PATH/.claude/memory/$filename"
        echo "   ✅ Created $filename"
    fi
done

# Step 4: Make hooks executable
echo "4️⃣  Making hooks executable..."
chmod +x "$TARGET_PATH/.claude/hooks"/*.sh
echo "   ✅ Done"

# Step 5: Create required directories
echo "5️⃣  Creating required directories..."
mkdir -p "$TARGET_PATH/.claude/tmp"
mkdir -p "$TARGET_PATH/.claude/cache"
mkdir -p "$TARGET_PATH/.claude/archive"
echo "   ✅ Done"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Mini-CoderBrain installed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "  1. Open your project in Claude Code"
echo "  2. Start a new chat"
echo "  3. You should see: 🧠 [MINI-CODERBRAIN: ACTIVE]"
echo ""
echo "Available commands:"
echo "  /map-codebase     - Enable instant file access"
echo "  /memory-sync      - Sync memory bank"
echo "  /memory-cleanup   - Clean bloated memory"
echo "  /init-memory-bank - Auto-populate from project"
echo ""

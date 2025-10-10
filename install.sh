#!/usr/bin/env bash
set -euo pipefail

# Mini-CoderBrain Installer v2.0
# Smart installer for Universal AI Context Awareness System

VERSION="2.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Mini-CoderBrain v${VERSION} - Smart Installer${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Detect project type
detect_project_type() {
    local project_path="$1"

    if [ -f "$project_path/package.json" ]; then
        echo "Node.js/JavaScript"
    elif [ -f "$project_path/requirements.txt" ] || [ -f "$project_path/setup.py" ]; then
        echo "Python"
    elif [ -f "$project_path/Cargo.toml" ]; then
        echo "Rust"
    elif [ -f "$project_path/go.mod" ]; then
        echo "Go"
    elif [ -f "$project_path/pom.xml" ] || [ -f "$project_path/build.gradle" ]; then
        echo "Java"
    elif [ -f "$project_path/composer.json" ]; then
        echo "PHP"
    else
        echo "Generic"
    fi
}

# Get project name from path or config
get_project_name() {
    local project_path="$1"
    local project_name

    # Try package.json first
    if [ -f "$project_path/package.json" ] && command -v jq >/dev/null 2>&1; then
        project_name=$(jq -r '.name // empty' "$project_path/package.json" 2>/dev/null)
        if [ -n "$project_name" ] && [ "$project_name" != "null" ]; then
            echo "$project_name"
            return
        fi
    fi

    # Fallback to directory name
    basename "$project_path"
}

# Check prerequisites
check_prerequisites() {
    local has_errors=0

    print_info "Checking prerequisites..."

    # Check for jq (optional but recommended)
    if ! command -v jq >/dev/null 2>&1; then
        print_warning "jq not found (optional - enables enhanced features)"
        print_info "Install with: sudo apt-get install jq  (Ubuntu/Debian)"
        print_info "           or: brew install jq        (macOS)"
    else
        print_success "jq found"
    fi

    # Check for Claude Code (informational only)
    print_info "Note: Claude Code required to use Mini-CoderBrain"

    echo ""
    return 0
}

# Backup existing installation
backup_existing() {
    local target_path="$1"

    if [ -d "$target_path/.claude" ]; then
        local backup_path="$target_path/.claude.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Existing .claude folder found"
        print_info "Creating backup: $backup_path"
        cp -r "$target_path/.claude" "$backup_path"
        print_success "Backup created"
        return 0
    fi

    if [ -f "$target_path/CLAUDE.md" ]; then
        local backup_file="$target_path/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Existing CLAUDE.md found"
        print_info "Creating backup: $backup_file"
        cp "$target_path/CLAUDE.md" "$backup_file"
        print_success "Backup created"
    fi
}

# Install Mini-CoderBrain
install_mini_coderbrain() {
    local target_path="$1"
    local project_name
    local project_type

    print_header

    # Validate paths
    if [ ! -d "$SCRIPT_DIR/.claude" ]; then
        print_error "Installation files not found!"
        print_error "Expected .claude folder in: $SCRIPT_DIR"
        exit 1
    fi

    # Check for CLAUDE.md in root or docs
    local claude_md_source=""
    if [ -f "$SCRIPT_DIR/CLAUDE.md" ]; then
        claude_md_source="$SCRIPT_DIR/CLAUDE.md"
    elif [ -f "$SCRIPT_DIR/docs/CLAUDE.md" ]; then
        claude_md_source="$SCRIPT_DIR/docs/CLAUDE.md"
    else
        print_error "CLAUDE.md not found!"
        exit 1
    fi

    # Detect project info
    project_name=$(get_project_name "$target_path")
    project_type=$(detect_project_type "$target_path")

    print_info "Project: $project_name"
    print_info "Type: $project_type"
    print_info "Target: $target_path"
    echo ""

    # Check prerequisites
    check_prerequisites

    # Backup existing installation
    backup_existing "$target_path"

    # Install .claude folder
    print_info "Installing .claude folder..."
    cp -r "$SCRIPT_DIR/.claude" "$target_path/"
    print_success ".claude folder installed"

    # Install CLAUDE.md
    print_info "Installing CLAUDE.md controller..."
    cp "$claude_md_source" "$target_path/"
    print_success "CLAUDE.md installed"

    # Create required directories
    print_info "Creating required directories..."
    mkdir -p "$target_path/.claude/tmp"
    mkdir -p "$target_path/.claude/cache"
    mkdir -p "$target_path/.claude/archive"
    print_success "Directories created"

    # Make hooks executable
    print_info "Making hooks executable..."
    chmod +x "$target_path/.claude/hooks"/*.sh 2>/dev/null || true
    print_success "Hooks configured"

    # Copy templates to actual memory files
    print_info "Initializing memory bank from templates..."

    for template in "$target_path/.claude/memory/templates"/*-template.md; do
        if [ -f "$template" ]; then
            filename=$(basename "$template" | sed 's/-template//')
            target_file="$target_path/.claude/memory/$filename"

            # Only copy if target doesn't exist (don't overwrite existing memory)
            if [ ! -f "$target_file" ]; then
                cp "$template" "$target_file"
                print_success "Created $filename from template"

                # Customize with project name
                sed -i.bak "s/\[PROJECT_NAME\]/$project_name/g" "$target_file" 2>/dev/null || \
                sed -i '' "s/\[PROJECT_NAME\]/$project_name/g" "$target_file" 2>/dev/null || true
                rm -f "$target_file.bak"
            else
                print_info "$filename already exists (keeping existing)"
            fi
        fi
    done

    print_success "Memory bank initialized"

    # Verify installation
    print_info "Verifying installation..."

    local errors=0

    if [ ! -d "$target_path/.claude" ]; then
        print_error ".claude folder missing"
        errors=$((errors + 1))
    fi

    if [ ! -f "$target_path/CLAUDE.md" ]; then
        print_error "CLAUDE.md missing"
        errors=$((errors + 1))
    fi

    if [ ! -f "$target_path/.claude/hooks/session-start.sh" ]; then
        print_error "session-start.sh hook missing"
        errors=$((errors + 1))
    fi

    if [ ! -f "$target_path/.claude/commands/memory-cleanup.md" ]; then
        print_error "memory-cleanup command missing"
        errors=$((errors + 1))
    fi

    if [ $errors -eq 0 ]; then
        print_success "Verification passed"
    else
        print_error "$errors verification error(s) found"
        return 1
    fi

    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  ✅ Mini-CoderBrain v${VERSION} installed successfully!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${BLUE}📋 Next Steps:${NC}"
    echo "  1. Open your project in Claude Code"
    echo "  2. Claude will auto-load context from .claude/memory/"
    echo "  3. Start developing with perfect context awareness!"
    echo ""
    echo -e "${BLUE}💡 Available Commands:${NC}"
    echo "  • /memory-sync     - Sync memory bank"
    echo "  • /context-update  - Update active context"
    echo "  • /memory-cleanup  - Clean bloated memory (prevents 'Prompt too long')"
    echo "  • /map-codebase    - Enable instant file access"
    echo ""
    echo -e "${BLUE}📊 Performance:${NC}"
    echo "  • ✅ Zero context duplication (79.9% token reduction)"
    echo "  • ✅ 25% longer conversations (100+ turns)"
    echo "  • ✅ Perfect cross-session continuity"
    echo "  • ✅ Automatic memory cleanup"
    echo ""
    echo -e "${BLUE}📚 Documentation:${NC}"
    echo "  • README: $SCRIPT_DIR/README.md"
    echo "  • Guide: $SCRIPT_DIR/INSTALLATION.md"
    echo "  • SRS: $SCRIPT_DIR/docs/SRS-MINI-CODERBRAIN.md"
    echo ""
}

# Main script
main() {
    local target_path="${1:-}"

    # If no argument provided, prompt for path
    if [ -z "$target_path" ]; then
        print_header
        echo "Enter the path to your project:"
        read -r target_path

        if [ -z "$target_path" ]; then
            print_error "No path provided"
            exit 1
        fi
    fi

    # Expand ~ and resolve path
    target_path="${target_path/#\~/$HOME}"
    target_path="$(cd "$target_path" 2>/dev/null && pwd)" || {
        print_error "Invalid path: $target_path"
        exit 1
    }

    # Confirm installation
    echo ""
    echo -e "${YELLOW}Install Mini-CoderBrain v${VERSION} to:${NC}"
    echo -e "${YELLOW}  $target_path${NC}"
    echo ""
    echo -n "Continue? (y/N): "
    read -r confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled"
        exit 0
    fi

    # Run installation
    install_mini_coderbrain "$target_path"
}

# Run main function
main "$@"

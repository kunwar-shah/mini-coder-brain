#!/usr/bin/env bash
set -eu

# Universal Project Structure Detector
# Detects common project patterns and populates {detected_*_path} variables
# Used by CoderBrain commands for universal project compatibility

# Find project root more reliably
if [[ -n "${CLAUDE_PROJECT_DIR:-}" ]]; then
  ROOT="$CLAUDE_PROJECT_DIR"
else
  ROOT="$(pwd)"
fi

CLAUDE_MEMORY="$ROOT/.claude/memory"
PROJECT_STRUCTURE_FILE="$CLAUDE_MEMORY/project-structure.json"

# Ensure directories exist
mkdir -p "$CLAUDE_MEMORY"

# Initialize project structure detection
detect_project_structure() {
  local detected_project_type="unknown"
  local detected_frontend_path=""
  local detected_backend_path=""
  local detected_database_path=""
  local detected_migration_path=""
  local detected_admin_path=""
  local detected_customer_path=""
  local detected_landing_path=""
  local detected_mobile_path=""
  local detected_tests_path=""
  local detected_docs_path=""

  # Detect project type from package.json, requirements.txt, etc.
  if [ -f "$ROOT/package.json" ]; then
    if grep -q "next\|react\|vue\|angular" "$ROOT/package.json" 2>/dev/null; then
      detected_project_type="frontend"
    elif grep -q "express\|fastify\|koa" "$ROOT/package.json" 2>/dev/null; then
      detected_project_type="node_backend"
    else
      detected_project_type="javascript"
    fi
  elif [ -f "$ROOT/requirements.txt" ] || [ -f "$ROOT/pyproject.toml" ]; then
    detected_project_type="python"
  elif [ -f "$ROOT/Cargo.toml" ]; then
    detected_project_type="rust"
  elif [ -f "$ROOT/go.mod" ]; then
    detected_project_type="go"
  elif [ -f "$ROOT/composer.json" ]; then
    detected_project_type="php"
  fi

  # Frontend detection patterns
  for path in "frontend" "client" "web" "app" "ui" "src" "www" "public" "."; do
    if [ -d "$ROOT/$path" ]; then
      if [ -f "$ROOT/$path/package.json" ] || [ -f "$ROOT/$path/index.html" ] || [ -f "$ROOT/$path/src/App.tsx" ] || [ -f "$ROOT/$path/src/App.jsx" ]; then
        detected_frontend_path="$path"
        break
      fi
    fi
  done

  # Backend detection patterns
  for path in "backend" "server" "api" "app" "src" "apps/backend" "."; do
    if [ -d "$ROOT/$path" ]; then
      if [ -f "$ROOT/$path/package.json" ] || [ -f "$ROOT/$path/requirements.txt" ] || [ -f "$ROOT/$path/main.py" ] || [ -f "$ROOT/$path/app.py" ] || [ -f "$ROOT/$path/server.js" ]; then
        detected_backend_path="$path"
        break
      fi
    fi
  done

  # Database/Migration detection patterns
  for path in "migrations" "db/migrate" "database/migrations" "prisma/migrations" "backend/migrations" "app/migrations" "src/migrations"; do
    if [ -d "$ROOT/$path" ]; then
      detected_migration_path="$path"
      detected_database_path="$(dirname "$path")"
      break
    fi
  done

  # Platform-specific paths (multi-app architecture)
  for path in "admin" "dashboard" "backoffice" "apps/admin"; do
    if [ -d "$ROOT/$path" ]; then
      detected_admin_path="$path"
      break
    fi
  done

  for path in "customer" "portal" "client-portal" "apps/customer"; do
    if [ -d "$ROOT/$path" ]; then
      detected_customer_path="$path"
      break
    fi
  done

  for path in "landing" "website" "www" "marketing" "apps/landing"; do
    if [ -d "$ROOT/$path" ]; then
      detected_landing_path="$path"
      break
    fi
  done

  for path in "mobile" "app" "react-native" "flutter" "ios" "android"; do
    if [ -d "$ROOT/$path" ]; then
      detected_mobile_path="$path"
      break
    fi
  done

  # Tests detection
  for path in "tests" "test" "__tests__" "spec" "cypress" "e2e"; do
    if [ -d "$ROOT/$path" ]; then
      detected_tests_path="$path"
      break
    fi
  done

  # Documentation detection
  for path in "docs" "documentation" "wiki" ".github"; do
    if [ -d "$ROOT/$path" ]; then
      detected_docs_path="$path"
      break
    fi
  done

  # Fallback defaults if nothing detected
  [ -z "$detected_frontend_path" ] && detected_frontend_path="src"
  [ -z "$detected_backend_path" ] && detected_backend_path="src"
  [ -z "$detected_database_path" ] && detected_database_path="database"
  [ -z "$detected_migration_path" ] && detected_migration_path="migrations"
  [ -z "$detected_tests_path" ] && detected_tests_path="tests"
  [ -z "$detected_docs_path" ] && detected_docs_path="docs"

  # Generate project structure JSON
  cat > "$PROJECT_STRUCTURE_FILE" <<EOF
{
  "detection_timestamp": "$(date --iso-8601=seconds)",
  "project_root": "$ROOT",
  "project_type": "$detected_project_type",
  "detected_paths": {
    "frontend": "$detected_frontend_path",
    "backend": "$detected_backend_path",
    "database": "$detected_database_path",
    "migrations": "$detected_migration_path",
    "admin": "$detected_admin_path",
    "customer": "$detected_customer_path",
    "landing": "$detected_landing_path",
    "mobile": "$detected_mobile_path",
    "tests": "$detected_tests_path",
    "docs": "$detected_docs_path"
  },
  "detected_structure": {
    "frontend_path": "$detected_frontend_path",
    "backend_path": "$detected_backend_path",
    "database_path": "$detected_database_path",
    "migration_path": "$detected_migration_path",
    "admin_path": "$detected_admin_path",
    "customer_path": "$detected_customer_path",
    "landing_path": "$detected_landing_path",
    "mobile_path": "$detected_mobile_path",
    "tests_path": "$detected_tests_path",
    "docs_path": "$detected_docs_path"
  }
}
EOF

  echo "Project structure detected and saved to $PROJECT_STRUCTURE_FILE"
}

# Run detection
detect_project_structure

# Output success JSON for Claude Code hook
echo '{"decision": "approve", "reason": "Project structure detected successfully"}'
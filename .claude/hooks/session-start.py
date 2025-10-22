#!/usr/bin/env python3
"""
Mini-CoderBrain Session Start Hook (Python)
Loads project context at session start (once per session).
"""

import json
import sys
import subprocess
from pathlib import Path
from datetime import datetime

def log_session_start(input_data):
    """Log session start event to logs directory."""
    try:
        log_dir = Path("logs")
        log_dir.mkdir(parents=True, exist_ok=True)
        log_file = log_dir / 'session_start.json'

        # Read existing log data
        if log_file.exists():
            with open(log_file, 'r') as f:
                try:
                    log_data = json.load(f)
                except (json.JSONDecodeError, ValueError):
                    log_data = []
        else:
            log_data = []

        # Append new log entry
        log_data.append({
            "timestamp": datetime.now().isoformat(),
            "session_id": input_data.get('session_id', 'unknown'),
            "source": input_data.get('source', 'unknown')
        })

        # Write back
        with open(log_file, 'w') as f:
            json.dump(log_data, f, indent=2)
    except Exception:
        pass  # Fail silently

def read_memory_file(file_path):
    """Read memory bank file with error handling."""
    try:
        if Path(file_path).exists():
            with open(file_path, 'r') as f:
                return f.read()
    except Exception:
        pass
    return None

def load_core_context_only(mb_dir):
    """Load ONLY core sections from activeContext.md (exclude session history)."""
    try:
        ac_path = Path(mb_dir) / "activeContext.md"
        if not ac_path.exists():
            return None

        with open(ac_path, 'r') as f:
            lines = f.readlines()

        # Find "## Session Updates" marker
        core_lines = []
        for line in lines:
            if line.strip().startswith("## Session Updates") or line.strip().startswith("## 📜 Session Updates"):
                break
            core_lines.append(line)

        return ''.join(core_lines).strip()
    except Exception:
        return None

def get_git_status():
    """Get current git branch."""
    try:
        result = subprocess.run(
            ['git', 'rev-parse', '--abbrev-ref', 'HEAD'],
            capture_output=True,
            text=True,
            timeout=3
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except Exception:
        pass
    return None

def create_session_start_time():
    """Create session start timestamp."""
    try:
        tmp_dir = Path(".claude/tmp")
        tmp_dir.mkdir(parents=True, exist_ok=True)

        start_time = int(datetime.now().timestamp())
        with open(tmp_dir / "session-start-time", 'w') as f:
            f.write(str(start_time))
    except Exception:
        pass

def check_memory_health():
    """Check memory bank health and return status."""
    try:
        mb_dir = Path(".claude/memory")
        ac_path = mb_dir / "activeContext.md"

        if not ac_path.exists():
            return "Unknown", 0

        # Count session updates
        with open(ac_path, 'r') as f:
            content = f.read()
            session_updates = content.count("## Session Update") + content.count("## 🗓️ Session Update")

        if session_updates > 15:
            return "🚨 Critical", session_updates
        elif session_updates > 10:
            return "⚠️ Needs Cleanup", session_updates
        elif session_updates > 8:
            return "💡 Monitor", session_updates
        else:
            return "✅ Healthy", session_updates
    except Exception:
        return "Unknown", 0

def main():
    try:
        # Read JSON input
        input_data = json.loads(sys.stdin.read())
        session_id = input_data.get('session_id', 'unknown')
        source = input_data.get('source', 'unknown')

        # Log the session start
        log_session_start(input_data)

        # Create session start time
        create_session_start_time()

        # Memory bank directory
        mb_dir = Path(".claude/memory")

        # Check memory health
        memory_health, session_updates = check_memory_health()

        # Build boot status
        boot_parts = []
        boot_parts.append(f"[MINI-CODER-BRAIN: SESSION START - {source.upper()}]\n")

        # Git branch
        branch = get_git_status()
        if branch:
            boot_parts.append(f"📍 Branch: {branch}")

        # Memory health
        boot_parts.append(f"💾 Memory: {memory_health}")
        if session_updates > 10:
            boot_parts.append(f"    💡 Consider running /memory-cleanup ({session_updates} session updates)")

        # Load core context files (if exist)
        context_data = {}

        # 1. Product Context (full)
        pc_content = read_memory_file(mb_dir / "productContext.md")
        if pc_content:
            context_data['productContext'] = pc_content

        # 2. Active Context (core only - exclude session history)
        ac_core = load_core_context_only(mb_dir)
        if ac_core:
            context_data['activeContext'] = ac_core

        # 3. System Patterns (full)
        sp_content = read_memory_file(mb_dir / "systemPatterns.md")
        if sp_content:
            context_data['systemPatterns'] = sp_content

        # Build output with context injection
        if context_data:
            boot_parts.append("\n📚 Loaded context files:")
            if 'productContext' in context_data:
                boot_parts.append("   ✅ productContext.md")
            if 'activeContext' in context_data:
                boot_parts.append("   ✅ activeContext.md (core only)")
            if 'systemPatterns' in context_data:
                boot_parts.append("   ✅ systemPatterns.md")

        boot_status = "\n".join(boot_parts)

        # Build context injection
        full_context = boot_status + "\n\n"

        if context_data:
            full_context += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
            full_context += "📂 MEMORY BANK CONTEXT (Loaded once, persists in history)\n"
            full_context += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"

            for name, content in context_data.items():
                full_context += f"### {name}\n\n{content}\n\n"

        # Output JSON with additionalContext
        output = {
            "hookSpecificOutput": {
                "hookEventName": "SessionStart",
                "additionalContext": full_context
            }
        }

        print(json.dumps(output))
        sys.exit(0)

    except json.JSONDecodeError:
        sys.exit(0)
    except Exception:
        sys.exit(0)

if __name__ == '__main__':
    main()

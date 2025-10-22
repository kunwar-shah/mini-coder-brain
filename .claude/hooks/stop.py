#!/usr/bin/env python3
"""
Mini-CoderBrain Stop Hook (Python)
Updates memory bank at session end.
"""

import json
import sys
import subprocess
from pathlib import Path
from datetime import datetime

def log_stop_event(input_data):
    """Log stop event to logs directory."""
    try:
        log_dir = Path("logs")
        log_dir.mkdir(parents=True, exist_ok=True)
        log_file = log_dir / 'stop.json'

        # Read existing log data
        if log_file.exists():
            with open(log_file, 'r') as f:
                try:
                    log_data = json.load(f)
                except (json.JSONDecodeError, ValueError):
                    log_data = []
        else:
            log_data = []

        # Append new entry
        log_data.append({
            "timestamp": datetime.now().isoformat(),
            "session_id": input_data.get('session_id', 'unknown')
        })

        # Write back
        with open(log_file, 'w') as f:
            json.dump(log_data, f, indent=2)
    except Exception:
        pass

def get_activity_count():
    """Get today's activity count."""
    try:
        today = datetime.now().strftime('%Y-%m-%d')
        tool_log = Path(f".claude/memory/conversations/tool-tracking/{today}-tools.log")
        if tool_log.exists():
            with open(tool_log, 'r') as f:
                return len(f.readlines())
    except Exception:
        pass
    return 0

def get_git_changes():
    """Get uncommitted git changes."""
    try:
        result = subprocess.run(
            ['git', 'status', '--porcelain'],
            capture_output=True,
            text=True,
            timeout=3
        )
        if result.returncode == 0:
            lines = result.stdout.strip().split('\n') if result.stdout.strip() else []
            return len(lines)
    except Exception:
        pass
    return 0

def get_session_duration():
    """Calculate session duration in minutes."""
    try:
        start_file = Path(".claude/tmp/session-start-time")
        if start_file.exists():
            with open(start_file, 'r') as f:
                start_time = int(f.read().strip())
                current_time = int(datetime.now().timestamp())
                return (current_time - start_time) // 60
    except Exception:
        pass
    return 0

def update_active_context(ops, duration_min, git_changes):
    """Append session update to activeContext.md."""
    try:
        ac_path = Path(".claude/memory/activeContext.md")
        if not ac_path.exists():
            return

        # Read current content
        with open(ac_path, 'r') as f:
            content = f.read()

        # Build session update
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S UTC')
        session_update = f"\n## 🗓️ Session Update - {timestamp}\n"
        session_update += f"- Activity: {ops} operations\n"
        session_update += f"- Duration: {duration_min} minutes\n"
        if git_changes > 0:
            session_update += f"- Git: {git_changes} uncommitted changes\n"

        # Check if "## Session Updates" section exists
        if "## Session Updates" in content or "## 📜 Session Updates" in content:
            # Append to existing section
            content += session_update
        else:
            # Create new section
            content += "\n\n## 📜 Session Updates\n" + session_update

        # Write back
        with open(ac_path, 'w') as f:
            f.write(content)

    except Exception:
        pass

def main():
    try:
        # Read JSON input
        input_data = json.loads(sys.stdin.read())

        # Log the stop event
        log_stop_event(input_data)

        # Get session metrics
        ops = get_activity_count()
        duration_min = get_session_duration()
        git_changes = get_git_changes()

        # Update activeContext.md if activity threshold met (>5 ops)
        if ops >= 5:
            update_active_context(ops, duration_min, git_changes)

        sys.exit(0)

    except json.JSONDecodeError:
        sys.exit(0)
    except Exception:
        sys.exit(0)

if __name__ == '__main__':
    main()

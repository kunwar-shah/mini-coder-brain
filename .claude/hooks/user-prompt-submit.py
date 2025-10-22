#!/usr/bin/env python3
"""
Mini-CoderBrain UserPromptSubmit Hook (Python)
Tracks tool usage and injects footer requirements.
"""

import json
import sys
import subprocess
from pathlib import Path
from datetime import datetime

def log_user_prompt(session_id, input_data):
    """Log user prompt to logs directory."""
    try:
        log_dir = Path("logs")
        log_dir.mkdir(parents=True, exist_ok=True)
        log_file = log_dir / 'user_prompt_submit.json'

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
            "session_id": session_id,
            "prompt": input_data.get('prompt', '')[:100]  # First 100 chars
        })

        # Write back
        with open(log_file, 'w') as f:
            json.dump(log_data, f, indent=2)
    except Exception:
        pass

def track_tool_usage():
    """Track tool invocation in today's log."""
    try:
        today = datetime.now().strftime('%Y-%m-%d')
        tool_dir = Path(".claude/memory/conversations/tool-tracking")
        tool_dir.mkdir(parents=True, exist_ok=True)

        tool_log = tool_dir / f"{today}-tools.log"
        timestamp = datetime.now().isoformat()

        with open(tool_log, 'a') as f:
            f.write(f"{timestamp}\n")
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

def get_session_duration():
    """Calculate session duration."""
    try:
        start_file = Path(".claude/tmp/session-start-time")
        if start_file.exists():
            with open(start_file, 'r') as f:
                start_time = int(f.read().strip())
                current_time = int(datetime.now().timestamp())
                total_minutes = (current_time - start_time) // 60

                if total_minutes < 60:
                    return f"{total_minutes}m"
                elif total_minutes < 1440:
                    hours = total_minutes // 60
                    mins = total_minutes % 60
                    return f"{hours}h {mins}m"
                else:
                    days = total_minutes // 1440
                    remaining = total_minutes % 1440
                    hours = remaining // 60
                    return f"{days}d {hours}h"
    except Exception:
        pass
    return "Unknown"

def get_last_sync():
    """Get last memory sync time."""
    try:
        sync_file = Path(".claude/tmp/last-memory-sync")
        if sync_file.exists():
            with open(sync_file, 'r') as f:
                last_sync_time = int(f.read().strip())
                current_time = int(datetime.now().timestamp())
                min_ago = (current_time - last_sync_time) // 60

                if min_ago == 0:
                    return "Just now", min_ago
                elif min_ago < 60:
                    return f"{min_ago}m ago", min_ago
                elif min_ago < 1440:
                    hours = min_ago // 60
                    return f"{hours}h ago", min_ago
                else:
                    days = min_ago // 1440
                    return f"{days}d ago", min_ago
    except Exception:
        pass
    return "Never", 99999

def get_memory_health():
    """Check memory health."""
    try:
        ac_path = Path(".claude/memory/activeContext.md")
        if ac_path.exists():
            with open(ac_path, 'r') as f:
                content = f.read()
                session_updates = content.count("## Session Update") + content.count("## 🗓️ Session Update")

            if session_updates > 15:
                return "Critical", session_updates
            elif session_updates > 10:
                return "Needs Cleanup", session_updates
            elif session_updates > 8:
                return "Monitor", session_updates
            else:
                return "Healthy", session_updates
    except Exception:
        pass
    return "Unknown", 0

def get_current_profile():
    """Get current behavior profile."""
    try:
        profile_file = Path(".claude/tmp/current-profile")
        if profile_file.exists():
            with open(profile_file, 'r') as f:
                return f.read().strip()
    except Exception:
        pass
    return "default"

def get_current_focus():
    """Get current focus from activeContext."""
    try:
        ac_path = Path(".claude/memory/activeContext.md")
        if ac_path.exists():
            with open(ac_path, 'r') as f:
                lines = f.readlines()
                in_focus = False
                for line in lines:
                    if "## 🎯 Current Focus" in line or "## Current Focus" in line:
                        in_focus = True
                        continue
                    if in_focus and line.strip() and not line.startswith('#'):
                        focus = line.strip()
                        return focus[:50]  # Max 50 chars
    except Exception:
        pass
    return "Development"

def check_map_status():
    """Check codebase map status."""
    try:
        map_file = Path(".claude/cache/codebase-map.json")
        if map_file.exists():
            age_seconds = datetime.now().timestamp() - map_file.stat().st_mtime
            age_hours = age_seconds / 3600
            if age_hours > 24:
                return "Stale"
            return "Fresh"
    except Exception:
        pass
    return "None"

def detect_notifications(ops, min_ago, memory_health, session_updates):
    """Detect if notifications are required."""
    notifications = []

    # CONDITION 1: Memory cleanup needed
    if session_updates > 10:
        notifications.append(
            f"💡 🧹 Memory cleanup recommended ({session_updates} session updates). Run /memory-cleanup."
        )

    # CONDITION 2: High activity without sync (takes priority)
    if ops >= 50 and min_ago >= 10:
        notifications.append(
            f"💡 🔄 High activity session ({ops} ops, {min_ago}m since sync). Consider: /memory-sync."
        )

    # Return first notification (prioritize high activity)
    if len(notifications) >= 2:
        return notifications[1]  # High activity takes priority
    elif len(notifications) == 1:
        return notifications[0]
    return None

def main():
    try:
        # Read JSON input
        input_data = json.loads(sys.stdin.read())
        session_id = input_data.get('session_id', 'unknown')

        # Log the prompt
        log_user_prompt(session_id, input_data)

        # Track tool usage
        track_tool_usage()

        # Gather footer data
        ops = get_activity_count()
        duration = get_session_duration()
        last_sync_display, min_ago = get_last_sync()
        memory_health, session_updates = get_memory_health()
        profile = get_current_profile()
        focus = get_current_focus()
        map_status = check_map_status()

        # Detect notifications
        notification = detect_notifications(ops, min_ago, memory_health, session_updates)

        # Build footer
        footer_lines = []
        footer_lines.append("\n🧠 MINI-CODER-BRAIN STATUS")
        footer_lines.append(f"📊 Activity: {ops} ops | 🗺️ Map: {map_status} | ⚡ Context: Active")
        footer_lines.append(f"🎭 Profile: {profile} | ⏱️ {duration} | 🎯 Focus: {focus}")
        footer_lines.append(f"💾 Memory: {memory_health} | 🔄 Last sync: {last_sync_display} | 🔧 Tools: N/A")

        if notification:
            footer_lines.append("\n" + notification)

        footer_text = "\n".join(footer_lines)

        # Build enhanced context with footer requirements
        enhanced_context = footer_text + "\n\n"
        enhanced_context += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
        enhanced_context += "🔒 MANDATORY FOOTER VALIDATION (v2.2 3-LAYER ENFORCEMENT)\n"
        enhanced_context += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
        enhanced_context += "BEFORE ENDING YOUR RESPONSE, YOU MUST:\n\n"
        enhanced_context += "1️⃣  DISPLAY the status footer shown above\n"
        enhanced_context += "2️⃣  DO NOT modify the format\n"
        enhanced_context += "3️⃣  DO NOT recalculate values\n"
        enhanced_context += "4️⃣  ALWAYS include at end of EVERY response\n\n"

        if notification:
            enhanced_context += "⚠️  NOTIFICATION DETECTED - You MUST include the 5th line:\n"
            enhanced_context += f"    {notification}\n\n"

        # Output JSON with additionalContext
        output = {
            "hookSpecificOutput": {
                "hookEventName": "UserPromptSubmit",
                "additionalContext": enhanced_context
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

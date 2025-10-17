# Screenshot Checklist - Mini-CoderBrain

**Purpose**: List of screenshots needed for marketing materials
**Status**: ✅ = Captured, ⏳ = Pending

---

## 🎯 Required Screenshots (5 Hero Shots)

### Screenshot 1: Session-Start Boot Status ⏳
**What to capture**: Session-start hook output showing context loaded

**Content should show**:
```
🧠 [MINI-CODERBRAIN: ACTIVE] - mini-coder-brain
🎯 Focus: [Current focus text]
📂 Context: .claude/memory/ (loaded)
🎭 Profile: default
⚡ Ready for development | Session: sessionstart-[ID]
```

**How to capture**:
1. Start new Claude Code session
2. Wait for session-start hook to display
3. Take screenshot of terminal/output
4. Should show clean boot status

**Dimensions**: Full terminal width, crop height to just the status output

**Annotation**: Add text overlay "Perfect memory loaded automatically"

**Use for**: ProductHunt #1 screenshot, Twitter posts, README hero

---

### Screenshot 2: Enhanced Status Footer ✅
**What to capture**: Your current response with full status footer

**Content should show**:
```
🧠 MINI-CODER-BRAIN STATUS
📊 Activity: X ops | 🗺️ Map: Status | ⚡ Context: Active
🎭 Profile: default | ⏱️ Xm | 🎯 Focus: [Current work]
💾 Memory: Healthy | 🔄 Last sync: time | 🔧 Tools: Top 3
```

**How to capture**:
1. Use current conversation (you already have this!)
2. Scroll to any response with status footer
3. Take screenshot showing full footer
4. Crop to just the footer section

**Dimensions**: Full width, ~150px height

**Annotation**: Add text overlay "9 real-time metrics - full transparency"

**Use for**: ProductHunt #2, feature showcase, v2.1 announcement

---

### Screenshot 3: 4 AI Behavior Profiles ⏳
**What to capture**: Profile switching demonstration

**How to create**:
1. Take 4 separate screenshots or create a composite:
   - Profile: default
   - Profile: focus
   - Profile: research
   - Profile: implementation

2. Show the command: `/context-update profile [mode]`

3. Show Claude's response style difference

**Option A - Composite Image**:
```
┌─────────────┬─────────────┐
│   Default   │    Focus    │
│  (balanced) │ (no inter.) │
├─────────────┼─────────────┤
│  Research   │ Implement   │
│  (explore)  │   (fast)    │
└─────────────┴─────────────┘
```

**Option B - Side-by-Side**:
Two terminal windows showing different profile behaviors

**Dimensions**: 1200×900px composite or 800×600 each

**Annotation**: "4 AI modes - match AI to your task"

**Use for**: ProductHunt #3, feature deep dive, LinkedIn

---

### Screenshot 4: Code Example (No Questions) ⏳
**What to capture**: Claude responding WITHOUT asking context questions

**Content should show**:
```
You: "Add password reset endpoint"

Claude: [Checks context files]
        [Immediately implements using Next.js + Prisma]
        [NO questions about framework/database/location]
        [Just does it]

Result: Endpoint created in correct location, following patterns
```

**How to create**:
1. Ask Claude to add a feature
2. Show that Claude doesn't ask "What framework?"
3. Show immediate, context-aware implementation
4. Crop to show the exchange

**Dimensions**: Full conversation width, 400-600px height

**Annotation**: "No more re-explaining your project"

**Use for**: ProductHunt #4, problem-solution demo, Reddit posts

---

### Screenshot 5: Test Suite Results ⏳
**What to capture**: Test suite passing with 85% rate

**How to create**:
```bash
bash .claude/tests/run-tests.sh
```

**Content should show**:
```
🧪 Running Mini-CoderBrain Test Suite
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ test-commands.sh        PASS (5/5)
✅ test-hooks.sh           PASS (6/6)
✅ test-memory-bank.sh     PASS (4/4)
⚠️  test-cleanup.sh        PASS (3/4)
✅ test-metrics.sh         PASS (5/5)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 OVERALL: 85% (23/27 tests passed)
✅ Production Ready
```

**How to capture**:
1. Run test suite in terminal
2. Capture full output with colors
3. Crop to show summary clearly

**Dimensions**: Terminal width, full test output visible

**Annotation**: "85% test coverage - production ready"

**Use for**: ProductHunt #5, quality proof, technical audience

---

## 🎨 Bonus Screenshots (Optional)

### Bonus 1: Memory Cleanup ⏳
**What**: `/memory-cleanup` command output

**Shows**:
```
🧹 Memory Bank Cleanup - Starting Analysis
...
✅ CLEANUP COMPLETE!
📊 Results: 103 → 69 lines (-34)
💰 Saved: ~1700 tokens
```

**Use for**: Feature showcase, token optimization proof

---

### Bonus 2: Metrics Dashboard ⏳
**What**: `/metrics` command output

**Shows**:
```
📊 Tool Usage (Last 7 Days):
   Read: 156 ops (42%)
   Edit: 89 ops (24%)
   ...
⏱️  Session Duration: Avg 47 min
```

**Use for**: Privacy-first metrics demo, productivity tracking

---

### Bonus 3: Project Structure Detection ⏳
**What**: Session start showing project structure auto-detected

**Shows**:
```
🔍 Detected: Next.js 14 project
📂 Frontend: src/app/
📂 Backend: src/api/
📂 Database: prisma/
```

**Use for**: Universal compatibility proof

---

## 📋 Screenshot Capture Instructions

### Tools You Can Use

**macOS**:
- Cmd+Shift+4 (region screenshot)
- Cmd+Shift+5 (screenshot with options)
- CleanShot X (paid, best for annotations)

**Linux**:
- Flameshot (`flameshot gui`)
- GNOME Screenshot
- Spectacle (KDE)

**Windows**:
- Snipping Tool
- Windows+Shift+S
- ShareX (free, powerful)

### Capture Best Practices

**1. Clean Environment**:
- Close unnecessary windows
- Hide desktop clutter
- Use dark theme for terminal (more professional)
- Clear terminal scrollback

**2. Timing**:
- Wait for full output to render
- Capture before content scrolls away
- For animations, use screen recording then extract frame

**3. Cropping**:
- Remove unnecessary whitespace
- Keep text readable (don't crop too tight)
- Maintain aspect ratio

**4. Quality**:
- Use Retina/HiDPI if available
- Save as PNG (not JPG - keeps text sharp)
- Don't resize (keep original resolution)

### Annotation Tools

**Free**:
- Excalidraw (web-based)
- draw.io (diagrams)
- GIMP (photo editing)

**Paid**:
- Figma (design tool)
- Sketch (macOS)
- Adobe Photoshop

**Annotations to Add**:
- Text overlays explaining feature
- Arrows pointing to key elements
- Highlight boxes around important text
- Brief captions (< 10 words)

---

## 🎯 Screenshot Usage Map

| Screenshot | ProductHunt | Twitter | Reddit | LinkedIn | Dev.to |
|------------|-------------|---------|--------|----------|--------|
| 1. Boot Status | ✅ Hero | ✅ | ✅ | ✅ | ✅ |
| 2. Status Footer | ✅ Feature | ✅ | ⚠️ | ✅ | ✅ |
| 3. 4 Profiles | ✅ Feature | ✅ | ✅ | ✅ | ✅ |
| 4. No Questions | ✅ Problem | ✅ | ✅ | ⚠️ | ✅ |
| 5. Test Results | ✅ Quality | ⚠️ | ✅ | ✅ | ✅ |

✅ = Essential
⚠️ = Optional

---

## 📁 File Organization

Save screenshots to:
```
.development/marketing/assets/screenshots/
├── 01-boot-status.png
├── 02-status-footer.png
├── 03-profiles-composite.png
├── 04-no-questions-demo.png
├── 05-test-results.png
├── bonus-memory-cleanup.png
├── bonus-metrics-dashboard.png
└── bonus-project-detection.png
```

**Naming convention**: `##-descriptive-name.png`

---

## ✅ Completion Checklist

- [ ] Screenshot 1: Boot Status (session-start hook output)
- [ ] Screenshot 2: Status Footer (9 metrics shown)
- [ ] Screenshot 3: 4 Profiles (composite or side-by-side)
- [ ] Screenshot 4: No Questions (context-aware response)
- [ ] Screenshot 5: Test Results (85% pass rate)
- [ ] Add annotations to all 5 screenshots
- [ ] Save in organized folder structure
- [ ] Export at correct dimensions
- [ ] Ready for use in marketing materials

**Once complete**: You'll have all screenshots needed for ProductHunt, social media, and documentation! 🎉

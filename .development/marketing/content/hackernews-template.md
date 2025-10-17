# Hacker News Post Template

**Platform**: Hacker News (news.ycombinator.com)
**Format**: Show HN
**Audience**: Technical, skeptical, high-quality discussions

---

## Show HN Template

**Title Format**: "Show HN: Mini-CoderBrain – AI Context Awareness for Claude Code"

**Title Guidelines**:
- Start with "Show HN:"
- Product name first
- Brief descriptor (< 60 chars total)
- No marketing speak
- Clear, specific, technical

**Good Titles**:
```
✅ Show HN: Mini-CoderBrain – Give Claude Code Perfect Memory
✅ Show HN: Mini-CoderBrain – Context Awareness System for Claude
✅ Show HN: Mini-CoderBrain – 79.9% Token Reduction for AI Coding
```

**Bad Titles**:
```
❌ Show HN: The Ultimate AI Tool You've Been Waiting For
❌ Show HN: Revolutionary Context System (marketing speak)
❌ Show HN: Check Out My New Project (not specific)
```

---

## Post Body (First Comment)

**Post immediately after submission**:

```
Author here.

I built Mini-CoderBrain to solve a problem I had: Claude Code forgetting everything about my project between sessions.

The Problem:
Every new session meant 5-10 minutes of re-explaining tech stack, project structure, coding conventions, and recent work. Claude would ask "What framework are you using?" for the 10th time.

The Solution:
Lightweight context awareness system that gives Claude persistent memory:

• Maintains 5 memory bank files (productContext, systemPatterns, activeContext, progress, decisionLog)
• Loads context once per session, persists naturally in conversation history
• 79.9% token reduction through load-once architecture
• 4 customizable AI behavior modes (default/focus/research/implementation)
• Privacy-first metrics (100% local, no external calls)

Technical Details:
• Pure Bash (POSIX compliant)
• Hook-based integration (session-start, user-prompt, stop)
• No dependencies
• Cross-platform (Linux + macOS)
• 85% test coverage (12 suites, 70+ tests)

Architecture Decision:
File-based system instead of database for transparency, version control, and zero overhead. Context files are human-readable markdown.

Key Innovation:
Load-once principle - context loaded at session start persists in conversation history. No re-injection needed. This mimics human conversation memory.

Open Source:
MIT licensed, no tracking, no data collection.

GitHub: https://github.com/kunwar-shah/mini-coder-brain
Docs: https://kunwar-shah.github.io/mini-coder-brain/

Happy to answer questions about architecture, implementation, or use cases!
```

---

## Response Templates

### When Asked About Alternatives

```
Good question. I evaluated several approaches:

1. Massive README: AI didn't read consistently, token waste
2. External databases: Complexity, overhead, not git-friendly
3. Cloud-based solutions: Privacy concerns, latency
4. Manual copying: Error-prone, tedious

File-based approach won because:
• Transparent (users can edit directly)
• Version controllable (git-friendly)
• Zero dependencies
• Fast (no database overhead)
• Privacy-first (all local)

Trade-off: Manual file editing vs automated. Chose manual for transparency and user control.
```

### When Asked About Performance

```
Performance metrics:

• Session start: < 1 second (load 5 files, ~3KB total)
• Memory sync: < 2 seconds (update timestamps, write files)
• Codebase mapping: < 30 seconds (one-time, optional)
• Token reduction: 79.9% (load once vs re-inject every turn)

Bottleneck: None currently. File I/O is negligible with small files.

Future optimization: Could cache parsed context, but current speed is imperceptible to users.
```

### When Asked About Security

```
Security considerations:

1. All data stays local (no external calls)
2. POSIX-compliant shell scripts (auditable)
3. No eval or dynamic code execution
4. File permissions respect system settings
5. No secrets stored (users control content)

Threat model: Local file system compromise (same as any local tool).

Auditing: Pure bash, easy to audit. 18 hook files, ~2,000 lines total.
```

### When Asked About Limitations

```
Current limitations:

1. Single project per session (multi-project coming in v2.2)
2. Manual context updates (some automation coming)
3. No team collaboration features yet (planned)
4. Claude Code specific (not portable to other AI tools yet)

Intentional trade-offs:
• Simple > complex (avoiding feature bloat)
• Manual > automatic (user control, transparency)
• Local > cloud (privacy first)

I'm open to feedback on what limitations are most painful for users.
```

### When Asked "Why Not X?"

```
Re: Why not use [alternative approach]:

I considered that, but [specific reason]:

Example approaches I evaluated:
• Database (SQLite/Postgres): Overhead, complexity
• JSON config: Less human-readable than markdown
• Cloud sync: Privacy concerns
• VS Code extension: Claude Code specific

Chose current approach for:
1. Simplicity (bash + markdown)
2. Transparency (readable files)
3. Privacy (local only)
4. Portability (git-friendly)

Open to PRs for alternative backends! Architecture is pluggable.
```

---

## Timing Strategy

### Best Times to Post
- **Tuesday-Thursday**: 8-10 AM EST (highest engagement)
- **Avoid**: Monday (busy), Friday (winding down), weekends (low traffic)

### Launch Day Plan

**Hour 0 (Post)**:
- Submit Show HN post
- Immediately post first comment (detailed explanation)
- Monitor for first comments

**Hour 0-2 (Critical Window)**:
- Respond to EVERY comment
- Upvotes in first 2 hours determine visibility
- Be present, be helpful, be technical

**Hour 2-6 (Momentum)**:
- Continue responding promptly (< 30 min)
- Address technical questions with depth
- Thank people for feedback

**Hour 6-24 (Sustained Engagement)**:
- Check every 2-3 hours
- Respond to new threads
- Engage with criticism constructively

**Day 2-7 (Follow-up)**:
- Continue responding to new comments
- Update first comment if needed
- Consider follow-up post if major updates

---

## Engagement Rules

### Do's ✅

**1. Be Humble**
```
✅ "I built this to solve my own problem. Hope it helps others too."
✅ "Great point. I hadn't considered that angle."
✅ "You're right, there are definitely trade-offs here."
```

**2. Be Technical**
```
✅ Explain architecture decisions with specifics
✅ Share performance metrics
✅ Discuss trade-offs honestly
✅ Link to code for proof
```

**3. Acknowledge Limitations**
```
✅ "Current limitation: [X]. Working on it in v2.2."
✅ "Good catch. That's a bug. I'll fix it."
✅ "You're right, this approach doesn't work for [use case]."
```

**4. Engage with Criticism**
```
✅ "That's fair criticism. Here's my reasoning: [explain]"
✅ "I disagree because [technical reason], but I see your point."
✅ "You've convinced me. I'll change the approach."
```

**5. Provide Value**
```
✅ Answer every question thoroughly
✅ Share implementation details
✅ Explain "why" not just "what"
✅ Link to relevant code/docs
```

### Don'ts ❌

**1. Don't Be Defensive**
```
❌ "You clearly didn't read the docs"
❌ "That's not a real use case"
❌ "You're missing the point"
```

**2. Don't Use Marketing Speak**
```
❌ "Revolutionary game-changer"
❌ "Best tool ever built"
❌ "You need this in your life"
```

**3. Don't Ignore Criticism**
```
❌ Ignoring negative comments
❌ Deleting your responses
❌ Getting into arguments
```

**4. Don't Ask for Upvotes**
```
❌ "Please upvote if you find this useful"
❌ "Help me get to front page"
❌ "Share with your friends"
```

**5. Don't Spam**
```
❌ Posting multiple times same day
❌ Commenting on unrelated threads with your link
❌ Reposting if it doesn't do well
```

---

## Sample Q&A Responses

**Q: "How is this different from just using a good README?"**

A: Great question. I tried the README approach first. Problems I hit:

1. Claude didn't read it consistently (even with explicit "read README.md" instructions)
2. README got bloated trying to cover everything
3. No session-to-session continuity (what we did last time)
4. No automated updates (manual editing only)

Mini-CoderBrain solves this with:
• Hook-based automatic loading (AI can't forget)
• Structured context (5 files with specific purposes)
• Session updates (auto-appended to activeContext)
• Memory sync commands (update context as you work)

Think of it as "README + recent session history + automation".

---

**Q: "This seems overly complex for what it does"**

A: Fair criticism. Complexity breakdown:

User-facing complexity: Low
• Install: 30 seconds (drop folder in project)
• Setup: 1 command (/init-memory-bank)
• Usage: Zero (automatic)

Implementation complexity: Medium
• 18 hook files (bash scripts)
• 5 memory bank files (markdown)
• ~2,000 lines of code

Why this complexity?
• Hooks enable automation (zero user intervention)
• Multiple files enable structure (specific purposes)
• Bash enables portability (no dependencies)

I prioritized "simple to use" over "simple implementation".

Trade-off I'd reconsider: Maybe fewer memory files would work for 80% of use cases.

---

**Q: "Why not make this a VS Code extension?"**

A: Considered it, but:

1. Claude Code specific (not general VS Code)
2. Extension API limits (can't hook into Claude's prompts)
3. Less transparent (compiled code vs readable scripts)
4. Harder to audit (security/privacy)

Current approach:
• Works with Claude Code's hook system
• Human-readable bash scripts
• Easy to audit for privacy
• Git-friendly (version controlled)

Trade-off: Less discoverability (no VS Code marketplace) but better integration with Claude Code's architecture.

If VS Code exposes better APIs for AI tool integration, I'd reconsider!

---

**Q: "Have you thought about monetization?"**

A: Keeping it open source and free forever. Reasons:

1. Built it to solve my own problem (already has value for me)
2. Community contributions make it better
3. Open source enables trust (privacy-first claims auditable)
4. More impact as free tool

Sustainability plan:
• Keep scope manageable (avoid feature bloat)
• Community contributions for new features
• Sponsor button for those who want to support

Not interested in SaaS/paid tiers. This solves a problem too fundamental to put behind paywall.

---

**Q: "What about privacy concerns with AI reading my code?"**

A: Important question. Privacy guarantees:

1. All data stays local (no external API calls)
2. Context files stored in your project directory
3. No telemetry, no tracking, no data collection
4. Auditable (bash scripts, readable)

What gets stored:
• Project structure (paths, tech stack)
• Coding patterns (conventions you define)
• Session history (what you worked on)
• Technical decisions (ADRs)

What DOESN'T get stored:
• Source code itself (too large, unnecessary)
• Secrets (explicitly avoided)
• Personal information

If Claude has access to your project, Mini-CoderBrain doesn't add new privacy risks—it just organizes context Claude would see anyway.

All code open source: https://github.com/kunwar-shah/mini-coder-brain

---

## Key Principles for HN

1. **Be Genuine**: Share your real journey, including failures
2. **Be Technical**: HN audience is sophisticated, go deep
3. **Be Humble**: Acknowledge limitations and criticism
4. **Be Present**: First 2 hours are critical for engagement
5. **Be Helpful**: Answer every question thoroughly
6. **Be Honest**: Don't oversell, don't hide trade-offs

---

## What Works on HN

**✅ Technical Depth**
- Architecture explanations
- Performance metrics
- Design trade-offs
- Implementation details

**✅ Problem-Solving Focus**
- Real problems you faced
- Why existing solutions failed
- How you solved it differently

**✅ Honest Trade-offs**
- What works well
- What doesn't work well
- Why you chose this approach
- What you'd do differently

**✅ Open Source**
- Free, MIT licensed
- Code available for review
- Community-driven
- No monetization agenda

---

## What Doesn't Work on HN

**❌ Marketing Speak**
- "Revolutionary", "game-changing"
- Hyperbolic claims
- Sales pitches

**❌ Incomplete Projects**
- "Coming soon" features
- Vaporware
- No working demo

**❌ Ignoring Feedback**
- Defensive responses
- Dismissing criticism
- Not engaging with comments

**❌ Asking for Promotion**
- "Please upvote"
- "Share with friends"
- Vote manipulation

---

**Remember**: HN is technical, skeptical, and values substance over hype. Be real, be technical, be helpful! 🚀

# Onboarding Documentation

**Purpose**: Complete understanding of how Mini-CoderBrain works, from placeholders to production

---

## 📚 Documents in This Folder

### 1. [SESSION-START-EXPLAINED.md](./SESSION-START-EXPLAINED.md)
**Read This First!**

Complete guide to how the session-start hook works:
- What you see in `<session-start-hook>` tags
- How memory files are loaded
- Real project vs Mini-CoderBrain comparison
- Complete flow from installation to production use

**Answer These Questions**:
- Why do I see placeholders?
- How does session-start work?
- What happens in real projects?

---

### 2. [PLACEHOLDER-FILLING-GUIDE.md](./PLACEHOLDER-FILLING-GUIDE.md)
**Complete Reference**

Every placeholder in Mini-CoderBrain explained:
- All 60+ placeholders listed
- How each one gets filled
- When they get filled
- Automatic detection logic
- User input prompts

**Answer These Questions**:
- What are all the placeholders?
- How do they get filled?
- What gets auto-detected vs user-provided?

---

### 3. [SESSION-START-REFINEMENTS.md](./SESSION-START-REFINEMENTS.md)
**Implementation Guide**

Concrete improvements to make session-start better:
- Current issues (400+ lines of placeholders)
- 6 proposed refinements
- Implementation priority (Phase 1-3)
- Before/after comparisons
- Success metrics

**Answer These Questions**:
- What's wrong with current session-start?
- How can we fix it?
- What should we implement first?

---

### 4. [REAL-WORLD-COMPARISON.md](./REAL-WORLD-COMPARISON.md)
**Side-by-Side Examples**

Mini-CoderBrain vs User Projects:
- Memory files comparison (unfilled vs filled)
- Boot status comparison
- Development experience comparison
- What we should do next

**Answer These Questions**:
- How does Mini-CoderBrain differ from user projects?
- What does a properly filled memory bank look like?
- Should we fill our own placeholders?

---

## 🎯 Quick Start

### For New Users (Installing Mini-CoderBrain)

**Read In This Order**:
1. SESSION-START-EXPLAINED.md → Understand how it works
2. PLACEHOLDER-FILLING-GUIDE.md → Know what needs filling
3. Run `/init-memory-bank` → Fill placeholders automatically

---

### For Mini-CoderBrain Developers

**Read In This Order**:
1. REAL-WORLD-COMPARISON.md → Understand the meta problem
2. SESSION-START-REFINEMENTS.md → See what needs fixing
3. Implement Phase 1 refinements → Make it better

---

## ✅ Action Items

### Immediate (Do Now)
- [ ] Read SESSION-START-EXPLAINED.md
- [ ] Understand why placeholders exist
- [ ] Learn how `/init-memory-bank` works

### Short-Term (This Week)
- [ ] Implement session-start refinements (Phase 1)
- [ ] Run `/init-memory-bank` on mini-coder-brain itself
- [ ] Test with real project

### Long-Term (This Month)
- [ ] Complete all 3 phases of refinements
- [ ] Document in main README
- [ ] Add to onboarding checklist

---

## 🎓 Learning Path

### Level 1: Understanding
**Goal**: Know how Mini-CoderBrain works

**Read**:
- SESSION-START-EXPLAINED.md (20 min)
- Key sections of PLACEHOLDER-FILLING-GUIDE.md (10 min)

**Expected Knowledge**:
- How session-start hook works
- Why placeholders exist
- What happens in real projects

---

### Level 2: Using
**Goal**: Install and use Mini-CoderBrain properly

**Read**:
- PLACEHOLDER-FILLING-GUIDE.md (30 min)
- REAL-WORLD-COMPARISON.md (15 min)

**Do**:
- Install Mini-CoderBrain in test project
- Run `/init-memory-bank`
- Verify placeholders are filled

**Expected Knowledge**:
- How to initialize memory bank
- What each memory file contains
- How to maintain context

---

### Level 3: Improving
**Goal**: Make Mini-CoderBrain better

**Read**:
- SESSION-START-REFINEMENTS.md (30 min)
- All previous docs (review)

**Do**:
- Implement Phase 1 refinements
- Test with multiple projects
- Document improvements

**Expected Knowledge**:
- What's wrong with current implementation
- How to optimize token usage
- How to improve user experience

---

## 📊 Key Insights

### 1. Placeholders Are Temporary
Placeholders exist ONLY until `/init-memory-bank` runs. In production, users should NEVER see placeholders.

### 2. Mini-CoderBrain Is Special
It's a TOOL, not an APPLICATION. Its memory files are TEMPLATES that get copied to user projects.

### 3. We Should Dogfood
Mini-CoderBrain should use its own system properly. Fill our own placeholders!

### 4. Session-Start Needs Optimization
Current output is too verbose (400+ lines). Should be ~6 lines.

### 5. Context Loading ≠ Output
Files are loaded into context automatically. Hook doesn't need to output full contents.

---

## 🎯 Success Criteria

### For Users
✅ Placeholders filled in < 60 seconds
✅ Boot status shows real project data
✅ No confusing template text
✅ Claude knows project context immediately

### For Mini-CoderBrain
✅ Session-start outputs < 10 lines
✅ Token usage reduced by 98% (8000 → 120 tokens)
✅ Professional appearance (no placeholders)
✅ Clear guidance for uninitialized projects

---

## 🔗 Related Documentation

### Main Project Docs
- [CLAUDE.md](../../CLAUDE.md) - Main controller document
- [README.md](../../README.md) - Project overview
- [V2.1-IMPLEMENTATION-SUMMARY.md](../.development/V2.1-IMPLEMENTATION-SUMMARY.md) - Version history

### Technical Docs
- [.claude/hooks/session-start.sh](../../.claude/hooks/session-start.sh) - Hook implementation
- [.claude/memory/](../../.claude/memory/) - Memory bank files
- [.claude/patterns/](../../.claude/patterns/) - Behavioral patterns

---

## 💡 Common Questions

### Q: Why do I see so many placeholders in session-start?
**A**: You're seeing Mini-CoderBrain's own memory files, which are templates. In real projects, `/init-memory-bank` fills these automatically.

### Q: How long does initialization take?
**A**: 60 seconds. Claude auto-detects tech stack and prompts for 3-4 quick questions.

### Q: Should Mini-CoderBrain fill its own placeholders?
**A**: YES! We should practice what we preach and use our own system properly.

### Q: What's the biggest issue with current session-start?
**A**: Too verbose (400+ lines). Should be ~6 lines with smart detection.

### Q: When should I run `/init-memory-bank`?
**A**: Immediately after installing Mini-CoderBrain in any project.

---

## 🚀 Next Steps

1. **Read SESSION-START-EXPLAINED.md** to understand the system
2. **Read SESSION-START-REFINEMENTS.md** to see what needs fixing
3. **Implement Phase 1 refinements** to make it better
4. **Run `/init-memory-bank`** on mini-coder-brain itself
5. **Test with real project** to validate improvements

---

**Created**: 2025-10-17
**Last Updated**: 2025-10-17
**Status**: Complete (4 docs, 100% coverage)
**Next**: Implementation of refinements

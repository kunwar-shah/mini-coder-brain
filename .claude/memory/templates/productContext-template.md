# Product Context — [PROJECT_NAME]

<!--
  🔧 SETUP REQUIRED: Replace placeholders with your project details
  💡 TIP: Run /init-memory-bank to auto-populate this file
  📚 IMPORTANT: This file is critical for Mini-CoderBrain effectiveness!
-->

**Last Updated**: [AUTO_GENERATED]
**Project Type**: [AUTO_DETECTED]

---

## Project Overview

**[PROJECT_NAME]** — [ONE_LINE_DESCRIPTION]

<!-- Example: "A modern task management SaaS with real-time collaboration features" -->

**Description**: [2-3 sentences about what this project does, who it's for, and what problem it solves]

<!--
Example:
MyApp is a productivity platform that helps remote teams collaborate on tasks
in real-time. It combines project management, time tracking, and team chat
into a unified interface designed for distributed teams.
-->

---

## Core Features

<!-- List 3-5 core features that define your application -->

- [FEATURE_1]  <!-- e.g., "Real-time task collaboration with WebSocket" -->
- [FEATURE_2]  <!-- e.g., "User authentication with role-based access control" -->
- [FEATURE_3]  <!-- e.g., "Team workspaces with invite system" -->
- [FEATURE_4]  <!-- e.g., "Mobile-responsive design (PWA)" -->

---

## Technology Stack

<!-- Specify all major technologies used -->

### Frontend
- **Framework**: [FRAMEWORK]  <!-- e.g., React 18, Vue 3, Next.js 14 -->
- **Language**: [LANGUAGE]  <!-- e.g., TypeScript, JavaScript -->
- **Styling**: [STYLING]  <!-- e.g., Tailwind CSS, styled-components -->
- **State Management**: [STATE]  <!-- e.g., Zustand, Redux, Context API -->

### Backend
- **Framework**: [FRAMEWORK]  <!-- e.g., Express, FastAPI, Actix-web -->
- **Language**: [LANGUAGE]  <!-- e.g., Node.js/TypeScript, Python, Rust -->
- **ORM/Database Layer**: [ORM]  <!-- e.g., Prisma, SQLAlchemy, Diesel -->

### Database
- **Primary**: [DATABASE]  <!-- e.g., PostgreSQL, MongoDB, MySQL -->
- **Cache/Session**: [CACHE]  <!-- e.g., Redis, Memcached, or "None" -->

### Infrastructure
- **Deployment**: [PLATFORM]  <!-- e.g., Vercel, AWS, Docker Compose -->
- **CI/CD**: [TOOL]  <!-- e.g., GitHub Actions, GitLab CI, CircleCI -->
- **Monitoring**: [TOOL]  <!-- e.g., Sentry, LogRocket, or "None" -->

---

## Architecture

<!-- Describe your system architecture -->

**Type**: [ARCHITECTURE_TYPE]
<!-- e.g., "Monolithic REST API", "Microservices", "Serverless", "JAMstack" -->

**Pattern**: [PATTERN]
<!-- e.g., "MVC", "Clean Architecture", "Domain-Driven Design" -->

**Description**:
[2-3 sentences describing how components interact]

<!--
Example:
The application follows a clean architecture pattern with three layers:
API layer (Express routes), Business logic layer (services), and Data
layer (Prisma + PostgreSQL). Real-time features use WebSocket connections
managed by Socket.io server integrated with Express.
-->

---

## Project Structure

```
[PROJECT_ROOT]/
├── [DETECTED_FRONTEND_PATH]/     # Frontend application
├── [DETECTED_BACKEND_PATH]/      # Backend/API
├── [DETECTED_DATABASE_PATH]/     # Database migrations/schema
├── [DETECTED_TESTS_PATH]/        # Test suites
└── [DETECTED_DOCS_PATH]/         # Documentation
```

<!--
Example for Next.js + Prisma project:
```
my-app/
├── app/                # Next.js 14 App Router
├── components/         # React components
├── lib/                # Utility functions
├── prisma/             # Database schema & migrations
├── public/             # Static assets
└── __tests__/          # Test suites
```
-->

---

## Development Goals

### Current Phase
[CURRENT_DEVELOPMENT_PHASE]
<!-- e.g., "MVP Development", "Beta Testing", "Production Scaling" -->

### Primary Goal
[PRIMARY_GOAL]
<!-- e.g., "Launch MVP by end of Q2 2025", "Reach 1000 users" -->

### Success Metrics
- [METRIC_1]  <!-- e.g., "50+ beta users onboarded" -->
- [METRIC_2]  <!-- e.g., "Core features complete (auth, tasks, teams)" -->
- [METRIC_3]  <!-- e.g., "Test coverage >80%" -->

---

## Key Constraints & Considerations

<!-- Optional: Add any important constraints -->

- **Performance**: [CONSTRAINT]  <!-- e.g., "API responses < 200ms" -->
- **Security**: [REQUIREMENT]  <!-- e.g., "SOC 2 compliance required" -->
- **Scalability**: [TARGET]  <!-- e.g., "Support 10k concurrent users" -->
- **Budget**: [CONSTRAINT]  <!-- e.g., "Minimal cloud costs during MVP" -->

---

## Documentation References

<!-- Links to additional documentation -->

- **SRS/Requirements**: [PATH_OR_LINK]
- **Architecture Docs**: [PATH_OR_LINK]
- **API Documentation**: [PATH_OR_LINK]
- **Design System**: [PATH_OR_LINK]

---

## Context Notes

<!-- Add any additional context that doesn't fit above -->

[ADDITIONAL_CONTEXT_AND_NOTES]

<!--
Examples:
- "This is a migration from Rails monolith to Node.js microservices"
- "Mobile app (React Native) planned for Phase 2"
- "Using Supabase for auth to accelerate MVP development"
-->

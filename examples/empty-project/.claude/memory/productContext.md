# Product Context — my-new-saas-app

**Last Updated**: 2025-10-14T10:00:00Z
**Project Type**: Web Application (SaaS)

---

## Project Overview

**my-new-saas-app** — A modern SaaS platform for team collaboration

**Description**: This is a new project in the planning phase. The goal is to create a collaborative platform that helps remote teams stay aligned on goals and tasks. The application will focus on simplicity and real-time features.

---

## Core Features

- User authentication and team workspaces
- Real-time task management
- Team chat integration

---

## Technology Stack

### Frontend
- **Framework**: Next.js 14
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **State Management**: Zustand

### Backend
- **Framework**: Express.js
- **Language**: TypeScript
- **ORM/Database Layer**: Prisma

### Database
- **Primary**: PostgreSQL
- **Cache/Session**: Redis (planned)

### Infrastructure
- **Deployment**: Vercel (planned)
- **CI/CD**: GitHub Actions (planned)
- **Monitoring**: None yet

---

## Architecture

**Type**: Monolithic REST API with separate frontend
**Pattern**: MVC

**Description**:
Simple architecture with Next.js frontend and Express backend. Database accessed via Prisma ORM. Real-time features will be added using WebSocket in future iterations.

---

## Development Goals

### Current Phase
Planning & Initial Setup

### Primary Goal
Launch MVP by Q2 2025

### Success Metrics
- Complete user authentication by end of month
- Build 3 core features
- Get 10 beta testers onboard

---

## Key Constraints & Considerations

- **Performance**: Aim for <200ms API responses
- **Security**: Standard authentication, HTTPS only
- **Scalability**: Start simple, optimize later
- **Budget**: Minimize cloud costs during MVP

---

## Documentation References

- **SRS/Requirements**: Not yet created
- **Architecture Docs**: Not yet created
- **API Documentation**: Not yet created

---

## Context Notes

This is a greenfield project. Using modern TypeScript stack for rapid development. Focus is on getting MVP working quickly rather than perfection.

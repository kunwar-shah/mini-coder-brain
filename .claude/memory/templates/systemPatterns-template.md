# System Patterns — [PROJECT_NAME]

<!--
  🔧 SETUP REQUIRED: Define your project's patterns and conventions
  💡 TIP: Run /init-memory-bank to auto-detect patterns from your code
  📚 IMPORTANT: Claude uses this to match your coding style!
-->

**Last Updated**: [AUTO_GENERATED]
**Purpose**: Define coding standards, architectural patterns, testing strategy, error handling, and project conventions.

---

## Architectural Principles

<!-- Define 3-5 key principles that guide your architecture -->

- **[PRINCIPLE_1]**: [DESCRIPTION]
  <!-- Example: "Separation of Concerns - UI, business logic, and data layers are strictly separated" -->

- **[PRINCIPLE_2]**: [DESCRIPTION]
  <!-- Example: "API-First Design - All features exposed via REST API before UI implementation" -->

- **[PRINCIPLE_3]**: [DESCRIPTION]
  <!-- Example: "Fail Fast - Validate inputs early, throw errors at boundaries" -->

---

## Code Style & Conventions

### File Organization
- **[PATTERN]**: [DESCRIPTION]
<!-- Example: "Feature-based folders - /features/auth/, /features/tasks/" -->
<!-- Example: "Colocated tests - __tests__/ folder next to implementation" -->

### Naming Conventions
- **Files**: [CONVENTION]  <!-- e.g., "kebab-case for files, PascalCase for components" -->
- **Variables**: [CONVENTION]  <!-- e.g., "camelCase for variables, SCREAMING_SNAKE_CASE for constants" -->
- **Functions**: [CONVENTION]  <!-- e.g., "Verbs for functions (getUserById, calculateTotal)" -->
- **Components**: [CONVENTION]  <!-- e.g., "PascalCase, prefixed by domain (AuthButton, TaskList)" -->

### Code Formatting
- **Formatter**: [TOOL]  <!-- e.g., "Prettier with 2-space indent" -->
- **Linter**: [TOOL]  <!-- e.g., "ESLint with Airbnb config" -->
- **Line Length**: [LIMIT]  <!-- e.g., "80 characters (strict), 120 max" -->

---

## Technology Stack Details

### Primary Language
- **Language**: [LANGUAGE]  <!-- e.g., "TypeScript 5.x" -->
- **Version**: [VERSION]
- **Strict Mode**: [YES/NO]  <!-- e.g., "TypeScript strict: true" -->

### Build Tools
- **Build Tool**: [TOOL]  <!-- e.g., "Vite", "webpack", "esbuild" -->
- **Package Manager**: [MANAGER]  <!-- e.g., "pnpm", "npm", "yarn" -->
- **Task Runner**: [TOOL]  <!-- e.g., "npm scripts", "Makefile" -->

---

## Testing Patterns
- **Testing Framework**: [FRAMEWORK]
- **Test Structure**: [ORGANIZATION]
- **Coverage Requirements**: [PERCENTAGE]

---

## Error Handling & Logging
- **Error Types**: [ERROR_HANDLING_STRATEGY]
- **Logging**: [LOGGING_APPROACH]
- **Monitoring**: [MONITORING_TOOLS]

---

## Security Patterns
- **Authentication**: [IMPLEMENTATION]
- **Authorization**: [IMPLEMENTATION]
- **Data Protection**: [APPROACH]

---

## Performance Patterns
- **Optimization Strategy**: [APPROACH]
- **Caching**: [IMPLEMENTATION]
- **Scalability**: [CONSIDERATIONS]

---

## Development Workflow
- **Version Control**: [GIT_STRATEGY]
- **Branching**: [BRANCHING_MODEL]
- **Code Review**: [PROCESS]

---

## CI/CD & Tooling
- **CI/CD**: [TOOL_AND_PROCESS]
- **Deployment**: [STRATEGY]
- **Infrastructure**: [APPROACH]

---

## Cross-References
- **Related Decisions** → see @.claude/memory/decisionLog.md
- **Current Progress** → see @.claude/memory/progress.md
- **Active Context** → see @.claude/memory/activeContext.md

---

## Future Considerations
- **[FUTURE_PATTERN_1]**: [DESCRIPTION]
- **[FUTURE_PATTERN_2]**: [DESCRIPTION]

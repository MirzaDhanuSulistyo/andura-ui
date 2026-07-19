---
name: app-builder
description: Turns an app idea or core feature into a feasible product brief, PRD, screen inventory, Andura UI prototype, architecture, roadmap, and phase-by-phase implementation. Use when starting or continuing a Flutter, React, Compose, or SwiftUI product that should use Andura UI and pause for approval between product, design, and delivery stages.
compatibility: Requires access to an Andura UI checkout and the target platform toolchain. Simulator/device execution is optional but strongly preferred.
metadata:
  author: andura-ui
  version: "1.0"
---

# Andura App Builder

Build products through explicit, reviewable stages:

`idea → brief → feasibility → PRD → screens → UI proof → architecture → vertical slices`

Do not jump directly from an idea to a full application. Do not claim unsupported platform capabilities. Preserve the user's working tree and existing product decisions.

## Start or resume

1. Inspect the current directory, Git status, existing docs, source, tests, and screenshots.
2. Locate Andura UI. Check local sibling paths first, then the target project's dependency configuration.
3. If `docs/STATUS.md` exists, use it to identify the current stage. Verify it against the repository rather than trusting it blindly.
4. If product artifacts already exist, continue from the first incomplete or unapproved stage. Do not replace approved work without asking.
5. Read [the workflow](references/workflow.md) before planning work.
6. When implementing UI, read [the Andura integration rules](references/andura-ui.md) before writing code.

If the user's request does not identify the primary user, core problem, core feature, target platforms, or distribution constraints, ask only the missing high-impact questions. Avoid long questionnaires when reasonable assumptions can be documented.

## Operating modes

Default to **gated mode**: complete one stage, present its output, and stop at the approval gate.

Use **autopilot mode** only when the user explicitly asks to proceed without intermediate approval. Even in autopilot mode:

- record assumptions and platform limitations;
- create a focused commit after each completed stage if the user authorized commits;
- stop on destructive operations, policy blockers, unavailable credentials/entitlements, or major scope ambiguity;
- never skip tests or represent mock data as production data.

## Required stages

### Stage 1 — Product brief

Translate the idea into `docs/APP_BRIEF.md` using [the brief template](assets/APP_BRIEF.template.md). Include the primary user, problem, value proposition, core feature, platforms, constraints, non-goals, assumptions, and open questions.

**Gate:** ask the user to approve or correct the brief.

### Stage 2 — Feasibility

Research or inspect authoritative platform documentation and record findings in `docs/FEASIBILITY.md` using [the feasibility template](assets/FEASIBILITY.template.md). Cover APIs, permissions, background execution, store policy, privacy, security, data accuracy, and platform differences. Separate confirmed facts, prototype-needed assumptions, and unavailable capabilities.

Do not silently weaken an impossible feature. Offer product alternatives.

**Gate:** ask the user to approve the realistic scope.

### Stage 3 — PRD

Create or update `PRD.md`. Derive requirements from the approved brief and feasibility work. Include goals, non-goals, personas, platform capability contract, P0/P1/P2 scope, functional requirements, acceptance criteria, information architecture, privacy, non-functional requirements, risks, metrics, release gates, and definition of done.

Every important requirement must be testable or explicitly marked as discovery work.

**Gate:** ask the user to approve the PRD.

### Stage 4 — Screen inventory

Derive screens from user tasks and PRD requirements. Create `docs/screens/SCREEN_INVENTORY.md` using [the inventory template](assets/SCREEN_INVENTORY.template.md), then one specification per substantial screen using [the screen template](assets/SCREEN_SPEC.template.md).

For every screen define purpose, entry points, content hierarchy, actions, Andura component mapping, data, loading/empty/error/permission states, accessibility, and platform differences. Include navigation and deep links.

Do not add screens only because similar apps have them.

**Gate:** ask the user to approve navigation and screen scope.

### Stage 5 — Andura UI proof

Select one representative screen, usually Overview or the core workflow, and build it with realistic mock data before implementing infrastructure.

- Inspect Andura's exports, component signatures, tokens, theme APIs, examples, and platform package instructions.
- Use Andura components directly where they satisfy the product need.
- Build product-specific compositions only when Andura has no matching business component.
- Consume semantic Andura tokens; do not copy Andura source or hard-code substitute design values.
- Include loading, empty, error, and accessibility behavior appropriate to the prototype.
- Format, analyze/lint, and test.
- Run on the requested simulator/device when available.
- Save screenshots under `artifacts/screens/` with platform/device names.

Keep mock services clearly isolated from production data sources.

**Gate:** ask the user to approve the visual direction.

### Stage 6 — Architecture and roadmap

Create `docs/ARCHITECTURE.md` using [the architecture template](assets/ARCHITECTURE.template.md), covering module boundaries, state management, domain model, persistence, platform/native integration, security, observability, testing, and dependency rationale. Create `docs/ROADMAP.md` from [the roadmap template](assets/ROADMAP.template.md) as independently verifiable vertical slices.

Prefer end-to-end slices that make one user outcome real over layers such as “build all screens” or “build the entire database.”

**Gate:** ask the user to approve architecture and phase order.

### Stage 7 — Phase execution

For each approved phase:

1. State the user outcome and definition of done.
2. Inspect relevant code and current tests.
3. Implement the smallest complete vertical slice.
4. Add or update unit, widget/component, integration, and accessibility tests as applicable.
5. Run scoped checks, then repository checks required by local `AGENTS.md` files.
6. Run the app and capture screenshots when UI changed.
7. Update docs and `docs/STATUS.md`.
8. Summarize files, behavior, checks, limitations, and uncommitted changes.
9. Commit only when the user requested or previously authorized commits.
10. Stop for phase approval in gated mode.

Never mark a phase complete while required checks fail. Report blockers precisely.

## Status tracking

Create `docs/STATUS.md` from [the status template](assets/STATUS.template.md) as soon as Stage 1 begins. Update it at every gate and after each phase. It must remain concise and factual so another agent can resume safely.

Use these stage statuses: `not-started`, `in-progress`, `awaiting-approval`, `approved`, `blocked`, `complete`.

## Andura repository boundary

Andura UI contains reusable foundations and cross-platform components. Product-specific tracking cards, finance summaries, media timelines, dashboards, and domain services belong in the consuming application. Do not add them to Andura merely to complete a product prototype.

If the task genuinely requires a new shared Andura primitive, pause product work, explain why the primitive is broadly reusable, and follow Andura's cross-platform contract and generation rules.

## Completion response

At each gate report only:

- stage completed;
- artifacts created or changed;
- validations run and their result;
- assumptions, limitations, or blockers;
- exact decision required from the user;
- whether changes are committed.

Do not claim the app or phase is complete merely because the UI renders with sample data.

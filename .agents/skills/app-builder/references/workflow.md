# App Builder workflow reference

Use this checklist after loading the App Builder skill. Tailor depth to product risk; keep all gates.

## Artifact map

```text
PRD.md
docs/
  APP_BRIEF.md
  FEASIBILITY.md
  ARCHITECTURE.md
  ROADMAP.md
  STATUS.md
  screens/
    SCREEN_INVENTORY.md
    <screen-name>.md
artifacts/
  screens/
    <screen>-<platform>-<device>.png
```

Use existing repository conventions when they differ. Do not create duplicate documents solely to match this layout.

## Stage transition rules

A stage can move to `awaiting-approval` only when its artifact exists and is internally consistent. It can move to `approved` only after explicit user approval or when explicit autopilot authorization covers that gate.

| From | To | Requirement |
|---|---|---|
| Idea | Brief | High-impact product inputs known or assumptions documented |
| Brief | Feasibility | Brief approved |
| Feasibility | PRD | Realistic scope approved |
| PRD | Screens | PRD approved |
| Screens | UI proof | Screen inventory/navigation approved |
| UI proof | Architecture | Visual direction approved on a target device or equivalent preview |
| Architecture | Execution | Architecture and phase order approved |
| Execution phase N | Phase N+1 | Definition of done met and phase approved |

If the user asks for one downstream artifact directly, inspect upstream context and create only the minimum missing assumptions needed. Do not force ceremony that has no decision value.

## Intake questions

Ask only unanswered high-impact questions:

1. Who is the primary user and what painful outcome are they trying to avoid?
2. What is the single core feature?
3. Which platforms and minimum versions matter?
4. Which feature must be real in the first release?
5. Is store distribution required?
6. Are accounts, backend, payments, cloud sync, regulated data, or special entitlements involved?
7. Which Andura adapter and visual-system ID should be used?
8. Which simulator/device should demonstrate the UI?

Document reasonable defaults instead of asking about reversible details.

## Feasibility evidence

Prefer authoritative platform/vendor documentation. Record links and access dates when web research is available. If internet access is unavailable, label conclusions requiring verification.

For each core capability record:

- platform;
- API or mechanism;
- minimum OS/runtime;
- permissions/entitlements;
- background behavior;
- policy/review risk;
- data quality limitations;
- prototype needed;
- fallback product behavior.

Use capability states: `supported`, `limited`, `permission-required`, `entitlement-gated`, `unsupported`, `unknown`.

## PRD quality checks

Before presenting the PRD:

- the core feature is visible in P0;
- goals and non-goals do not conflict;
- platform differences are explicit;
- permissions are progressive and justified;
- acceptance criteria describe observable behavior;
- background/offline/error behavior exists;
- privacy and deletion requirements exist;
- metrics do not require invasive collection;
- schedules are marked directional until estimated;
- open questions are actual decisions, not missing analysis.

## Screen derivation method

Derive screens by walking each P0 user journey:

1. entry/onboarding;
2. permission or setup;
3. core action;
4. result/detail;
5. recovery and diagnostics;
6. history/management;
7. settings and privacy controls.

Then map every P0 requirement to at least one screen, background service, notification, widget, or system interaction. A requirement need not create a screen.

## UI proof checklist

- Correct Andura package and theme configured.
- Shared Andura components used where available.
- Product widgets consume semantic tokens.
- No copied design-system implementation.
- Realistic content lengths and large values tested.
- Small supported viewport has no overflow.
- Light/dark mode handled according to scope.
- Text scaling and screen-reader labels checked.
- Charts have textual alternatives.
- Mock/preview state is disclosed where it could be mistaken for real data.
- App launched on requested target.
- Screenshot reviewed rather than merely captured.

## Vertical-slice planning

A good phase delivers one testable user outcome and includes its UI, domain logic, persistence/API/native integration, telemetry/privacy behavior, and tests.

Good:

- “User grants usage access and sees today’s reconciled total.”
- “User configures a billing cycle and receives one deduplicated 80% warning.”

Poor:

- “Implement all models.”
- “Build all screens.”
- “Finish backend.”

Every phase entry in `ROADMAP.md` should include:

- user outcome;
- included requirements/screens;
- implementation tasks;
- dependencies and risks;
- validation commands;
- simulator/device demonstration;
- definition of done;
- excluded follow-up work.

## Validation hierarchy

1. Format changed files.
2. Static analysis/lint/typecheck.
3. Focused tests for changed behavior.
4. Full package suite when practical.
5. Repository-level contract checks required by `AGENTS.md`.
6. Build and run on target.
7. Inspect screenshots/logs.

Never hide a failing check by weakening or deleting a test unless the product requirement changed and the replacement test preserves meaningful coverage.

## Git discipline

- Inspect status before editing.
- Preserve unrelated changes.
- Keep generated artifacts and caches out of commits unless repository conventions require them.
- Use focused stage/phase commits.
- Do not commit without user authorization.
- Record the current commit in `STATUS.md` after committing; use `uncommitted` before then.

Suggested messages:

- `docs: define <product> app brief`
- `docs: document platform feasibility`
- `docs: add product requirements and screen map`
- `feat: prototype <screen> with Andura UI`
- `docs: define application architecture and roadmap`
- `feat(<feature>): deliver <user outcome>`

## Resume protocol

When a later session resumes:

1. Read repository instructions and `STATUS.md`.
2. Check Git status/log; do not assume STATUS is current.
3. Read approved upstream artifacts relevant to the current phase.
4. Run a fast baseline check if code exists.
5. State the next action and any mismatch before editing.

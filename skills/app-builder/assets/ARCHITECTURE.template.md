# <Product name> — Application architecture

**Status:** Draft | Awaiting approval | Approved  
**Last updated:** <date>

## Architecture goals

- <Quality or product goal>

## System context

<Clients, native services, backend, external APIs, widgets/extensions, and trust boundaries.>

## Module boundaries

| Module | Responsibilities | Depends on |
|---|---|---|
| <Module> | <Responsibilities> | <Dependencies> |

## State and data flow

<UI → state/controller → use case → repository → local/remote/native source.>

## Domain model

- `<Entity>` — <purpose and invariants>

## Persistence and migrations

<Store, schema ownership, retention, encryption, migration, and reconciliation.>

## Platform integration

- **Android:** <native APIs/services/channels>
- **iOS:** <native APIs/extensions/channels>
- **Other:** <integration>

## Security and privacy

<Authentication, authorization, secret handling, local storage, transport, deletion, and logging.>

## Failure and offline behavior

<Retries, idempotency, stale data, partial capability, and recovery.>

## Observability

<Privacy-safe logs, metrics, crash reports, diagnostics, and prohibited fields.>

## Testing strategy

- Unit: <scope>
- UI/component: <scope>
- Integration: <scope>
- Native/device: <scope>
- Accessibility/visual: <scope>

## Dependencies and rationale

| Dependency | Purpose | Why selected | Risk/exit plan |
|---|---|---|---|
| <Dependency> | <Purpose> | <Rationale> | <Risk> |

## Architecture decisions

1. **<Decision>:** <choice, alternatives, consequences>

## Approval

- [ ] Architecture approved
- Approved by/date: <name/date>

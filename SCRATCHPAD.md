# Maintenance scratchpad

This is current state for `/maintain`. The skill updates or removes stale
entries on every maintenance cycle and appends one compact history entry.

Two bound forks; each has its own baseline.

## Baseline — neko

- Last completed maintenance: **none**. Scaffolded 2026-09-01.
- Delivered upstream base: `148bc06bbd11173a4e8b826f0dbebe1fef7bcb98`
  (`kernel/neko:master`); the fork's `master` mirrors it exactly.
- Local integration: `6babebd99e2a5f998c7ffd57de5d0cfc80aaba16`, composed
  2026-09-01 from both carries. **Not published.**

## Baseline — kernel-images

- Delivered upstream base: `edaff49f9793197c9e777369f7c154f6626e4e1b`
  (`kernel/kernel-images:main`).
- Local integration: `edaff49f` — an empty composition at upstream main.
- Published fork `main`: `3be26fcbcdbed7e615d57217ee8db8f9dac00ee3`, behind
  upstream. The fork carries nothing.

## Carry heads

**neko** — two, published under non-conforming names:

- `fix/xtest-scroll-fallback-units` — `7705469`, scales the XTest scroll
  fallback to wheel notches. Offer candidate.
- `driver-sync-wip` — `6b93c0c`, syncs `xf86-input-neko` with the driver
  kernel-images ships.

**kernel-images** — none.

## Fork namespace

neko's fork inherits upstream developer branches (`hiro/*`, `sayan/*`,
`hypeship/*`, `sync/*`). All undeclared; reconciliation leaves them unchanged.

## Offers

None open.

## Notes that can change a later decision

- **The chain is unbound.** `agentbrowse` pins
  `onkernel/chromium-headful@sha256:da9ee68c…` built from upstream
  kernel-images `57858c77` — it contains neither carry.
- The published image namespace (`onkernel`) differs from the fork's upstream
  (`kernel/kernel-images`); where a fork-built image publishes is undecided.
- `go` is not on this machine's PATH, so neko's gate cannot run yet.
- Neither gate has been executed.

## History

- **2026-09-01** — Workshop scaffolded; `~/src/kernel-neko` and
  `~/src/kernel-images` moved to `fork/neko` and `fork/kernel-images`, fork
  remotes added, neko integration composed, kernel-images integration created
  at upstream main. No cycle run.

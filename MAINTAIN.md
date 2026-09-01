# Kernel browser image stack fork maintenance

This repository delivers and maintains our forks of
[`kernel/neko`](https://github.com/kernel/neko) and
[`kernel/kernel-images`](https://github.com/kernel/kernel-images): the virtual
browser and the image that ships it, which agentbrowse draws its Live View
through. `/maintain` runs a maintenance cycle from this file; this file is the
whole of what that skill knows about them.

> **Draft.** Scaffolded 2026-09-01 from the observed state of both forks. Lines
> marked **DECISION** are yours to settle before the first cycle runs.

## Purpose

Keep agentbrowse's browser image carrying the input behavior it needs, by
maintaining a neko fork for the behavior and a kernel-images fork as the only
vehicle that can deliver it.

## Upstream

Two bound forks:

- **neko** — checkout `fork/neko`. `origin` is `kernel/neko`; `fork` is
  `possibilities/neko`. Our fork was created 2026-08-30 and inherits upstream's
  developer branches (`hiro/*`, `sayan/*`, `hypeship/*`); maintenance owns only
  Master, Integration, and the declared carries, and preserves the rest.
- **kernel-images** — checkout `fork/kernel-images`. `origin` is
  `kernel/kernel-images`; `fork` is `possibilities/kernel-images`. It carries
  nothing today and is an exact mirror, 29 behind upstream.

`kernel-images` **vendors neko by copy**, not as a submodule
(`images/chromium-headful/client/src/neko`,
`images/chromium-headful/xorg-deps/xf86-input-neko`), and its `Dockerfile`
builds `chromium-headful` from that copy. This is why two forks are needed: the
behavior lives in neko, but only kernel-images can ship it.

## Branch model

Applied to each fork independently:

- Mirror branch: neko `master`, kernel-images `main`, exact mirrors of upstream.
- Integration branch: `integration` — every carry composed together, and the
  only ref the delivery chain may build from.
- Carries: `carry/<feature>`, each merged into Integration.

**Current state.** neko's Integration was composed locally on 2026-09-01 from
its two published branches and is **not yet published**; both branches still
carry their original names on the fork. kernel-images has no Integration
branch, because it has nothing to carry yet.

**DECISION — branch naming.** Neither neko branch follows `carry/`. Renaming
them on the fork is safe today (neither has an upstream pull request), but
`fix/xtest-scroll-fallback-units` is an offer candidate (below), and offers keep
`fix/` names. Settle whether that one is an offer before renaming either.
- Deletion marker prefix: `DELETEME/`. Creating, moving, or removing
  `DELETEME/<original-name>` requires an explicit human decision naming that
  branch. Maintenance never infers deletion from branch age, ownership,
  request state, or namespace. Every undeclared fork head remains unchanged.
- Open pull-request heads: validated. Reconciliation confirms the exact head
  of each currently open request from the fork but does not acquire ownership
  of the ref.
- `scripts/reconcile-branches.sh` is this repository's entrypoint to the
  shared branch script; it declares these values and nothing else.
  Because this workshop binds two forks, its first argument selects one:
  `reconcile-branches.sh <neko|kernel-images> [args...]`.
- Supervision: `scripts/reconcile-branches.sh --configure-supervision`
  converges this model into the bound checkout's own `supervisor.*` git
  config, which is where advisory tools read it — `/tend` judges a worktree
  against Integration and never proposes removing a carry head's worktree.
  `--check-supervision` verifies that convergence and that this section still
  names these branches. The config is derived state, not a second declaration.

## Features

### neko

| Commit | Subject | Scope |
|---|---|---|
| `7705469` | fix: scale the XTest scroll fallback to wheel notches | Adds `server/pkg/xorg/scroll_units.go` + test, touches `xorg.go` and `internal/desktop/xorg.go`. Fixes the defect agentbrowse recorded as a fork follow-up: the XTest fallback synthesizes one button click per protocol unit, so a 120-unit notch becomes 120 clicks during a socket failure. **DECISION — offer upstream?** agentbrowse's own note says the fallback "should divide by the 120-unit increment with a remainder, or be removed", which is upstream-shaped, not agentbrowse-shaped. |
| `6b93c0c` | fix: sync xf86-input-neko with the scroll driver kernel-images ships | Reconciles the vendored driver with what kernel-images ships. Downstream by construction: it exists because the copy drifts. |

Composed Integration: `6babebd`, over upstream `148bc06`.

### kernel-images

Empty. **DECISION — what carries here?** To deliver the neko fix, this fork must
carry a vendored-neko update. Two shapes are possible: carry the vendored source
update on `carry/vendor-neko-integration`, or build the image locally from a
patched tree and pin the digest without publishing a kernel-images branch. The
first is reproducible from published refs; the second is fewer moving parts.

## Consumer

agentbrowse, at the end of the delivery chain:

```
neko carry
  → vendored into kernel-images
  → chromium-headful image built
  → agentbrowse/config/kernel-headful.lock.json advanced
```

The lock currently reads `kernelSourceCommit 57858c77` and
`runtimeReference docker.io/onkernel/chromium-headful@sha256:da9ee68c…`,
verified 2026-08-29 — an **upstream** image that does **not** contain either
carry. `agentbrowse/docs/adr/0011-scroll-in-neko-notch-units.md` and
`docs/performance.md` document the dependency in prose and name the pending fix.

Note the registry namespace differs from the fork's: the published image is
`onkernel/chromium-headful` while our fork's upstream is `kernel/kernel-images`.
**DECISION — where does a fork-built image get published, and under what name?**

## Notify

- Title: `Kernel image stack Maintenance`
- Group: `nekomancer.maintain`

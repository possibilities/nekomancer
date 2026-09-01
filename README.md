# nekomancer

The workshop for this machine's Kernel browser image stack forks —
[neko](https://github.com/kernel/neko) and
[kernel-images](https://github.com/kernel/kernel-images) — which together
deliver the browser image agentbrowse draws its Live View through.

Unlike the single-fork workshops, this one binds **two** forks in an ordered
delivery chain: a neko carry reaches agentbrowse only by being vendored into
kernel-images, built into a `chromium-headful` image, and pinned.

- `MAINTAIN.md` — the specification, including that ordering. The shared
  `maintain` skill reads it by section name.
- `SCRATCHPAD.md` — current state between cycles.
- `scripts/reconcile-branches.sh <neko|kernel-images>` — declares the branch
  model for one named fork and nothing else.
- `fork.json` — the tracked pins for both forks plus the agentbrowse lock.
- `fork/neko`, `fork/kernel-images` — the bound checkouts, ignored here.

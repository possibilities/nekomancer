# nekomancer

Workshop for our forks of the Kernel browser image stack:
[`kernel/neko`](https://github.com/kernel/neko) and
[`kernel/kernel-images`](https://github.com/kernel/kernel-images).

Read `MAINTAIN.md` completely before changing either fork, and `CONTEXT.md` for
the language. `/maintain` runs a maintenance cycle from `MAINTAIN.md`; this
repository is the whole of what that skill knows about them.

Unlike the single-fork workshops, this one binds **two** forks in an ordered
delivery chain: a neko carry only reaches agentbrowse by being vendored into
kernel-images, built into a `chromium-headful` image, and pinned. `MAINTAIN.md`
is the contract for that ordering.

The forks live at `fork/neko` and `fork/kernel-images`, with worktrees at
`worktrees/`. All are ignored: the workshop tracks the *pin* (`fork.json`),
never the forks' contents.

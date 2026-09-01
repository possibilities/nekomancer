#!/bin/bash

set -euo pipefail

# nekomancer's entrypoint to the maintain skill's shared namespace script.
# This workshop binds two forks, so the first argument selects one; the rest
# pass through unchanged. It declares what MAINTAIN.md's Branch model says and
# nothing else; the mechanics are the skill's and are tested there.
#
# Usage: reconcile-branches.sh <neko|kernel-images> [args...]

workshop="$(cd "$(dirname "$0")/.." && pwd)"

die() {
    printf 'nekomancer branches: %s\n' "$*" >&2
    exit 1
}

[ "$#" -gt 0 ] || die "name a fork: neko or kernel-images"
fork_name=$1
shift

case "$fork_name" in
    neko)
        export MAINTAIN_CHECKOUT="${NEKOMANCER_NEKO_CHECKOUT:-$workshop/fork/neko}"
        export MAINTAIN_FORK_REPO=possibilities/neko
        export MAINTAIN_UPSTREAM_REPO=kernel/neko
        export MAINTAIN_MAIN_BRANCH=master
        # Both carries were published before the naming convention, and
        # renaming a published branch is a publication. Name them exactly
        # rather than claiming the whole fix/ namespace, which belongs to
        # upstream offers.
        export MAINTAIN_CARRY_REFS="fix/xtest-scroll-fallback-units driver-sync-wip"
        ;;
    kernel-images)
        export MAINTAIN_CHECKOUT="${NEKOMANCER_KERNEL_IMAGES_CHECKOUT:-$workshop/fork/kernel-images}"
        export MAINTAIN_FORK_REPO=possibilities/kernel-images
        export MAINTAIN_UPSTREAM_REPO=kernel/kernel-images
        export MAINTAIN_MAIN_BRANCH=main
        ;;
    *) die "unknown fork '$fork_name': expected neko or kernel-images" ;;
esac

skill_dir="${MAINTAIN_SKILL_DIR:-$HOME/.local/share/agentstart/capabilities/packs/common/skills/maintain}"
script="$skill_dir/scripts/reconcile-branches.sh"
[ -f "$script" ] || die "the maintain skill is not installed at $skill_dir (render ~/code/agentguidance, or set MAINTAIN_SKILL_DIR)"

export MAINTAIN_WORKSHOP="$workshop"
export MAINTAIN_FORK_REMOTE=fork
export MAINTAIN_UPSTREAM_REMOTE=origin
export MAINTAIN_INTEGRATION_BRANCH=integration
export MAINTAIN_CARRY_PREFIX=carry/
export MAINTAIN_WORKSHOP_CHECKOUTS="$workshop/fork/neko $workshop/fork/kernel-images"
export MAINTAIN_QUARANTINE_PREFIX=DELETEME/
export MAINTAIN_PRESERVE_OPEN_PRS=1

exec bash "$script" "$@"

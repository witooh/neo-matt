#!/usr/bin/env bash
set -euo pipefail

# Agent Plugins 1.0 discovers only immediate children of skills/ that contain
# SKILL.md (no recursion). This fork keeps Matt's bucket layout
# (skills/engineering/<name>/) and adds a promoted-name symlink at
# skills/<name> so omp can load the same files. Targets stay inside the
# plugin root.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN="$REPO/.claude-plugin/plugin.json"
SKILLS="$REPO/skills"
BUCKETS="engineering productivity misc in-progress deprecated"

if ! command -v python3 >/dev/null; then
  echo "error: python3 required" >&2
  exit 1
fi

python3 - "$PLUGIN" "$SKILLS" <<'PY'
import json, os, sys

plugin_path, skills_dir = sys.argv[1], sys.argv[2]
buckets = {"engineering", "productivity", "misc", "in-progress", "deprecated"}
manifest = json.load(open(plugin_path, encoding="utf-8"))
wanted = []
for rel in manifest["skills"]:
    # ./skills/<bucket>/<name>
    parts = rel.strip("./").split("/")
    if len(parts) != 3 or parts[0] != "skills":
        sys.exit(f"unexpected skills path: {rel}")
    bucket, name = parts[1], parts[2]
    if bucket not in buckets:
        sys.exit(f"unknown bucket in {rel}")
    if name in buckets:
        sys.exit(f"skill name collides with bucket: {name}")
    wanted.append((name, bucket))

wanted_names = {n for n, _ in wanted}

# Remove stale promoted symlinks at skills/<name> (not bucket dirs).
for entry in os.listdir(skills_dir):
    path = os.path.join(skills_dir, entry)
    if entry in buckets:
        continue
    if os.path.islink(path) and entry not in wanted_names:
        os.remove(path)
        print(f"removed stale {entry}")

for name, bucket in wanted:
    target = os.path.join(bucket, name)
    dest = os.path.join(skills_dir, name)
    if os.path.islink(dest) or not os.path.exists(dest):
        if os.path.lexists(dest):
            os.remove(dest)
        os.symlink(target, dest)
        print(f"linked {name} -> {target}")
    elif os.path.isdir(dest) and not os.path.islink(dest):
        sys.exit(f"refusing to replace real directory: {dest}")
PY

#!/usr/bin/env bash
# neo-matt → Kiro installer. Copies promoted skills into a Kiro config
# directory as .kiro/skills/<name>/. Not an Agent Plugin: a root plugin.json
# would make omp skip user-invoked skills (disable-model-invocation).
# Run with --help for the layout.

set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
PLUGIN="$REPO/.claude-plugin/plugin.json"

usage() {
  cat <<'EOF'
neo-matt → Kiro installer

Copies promoted skills into a Kiro configuration directory so they appear
as /<name> slash commands. Skills come from .claude-plugin/plugin.json
(engineering/, productivity/, and neo/).

Does not install agents or SessionStart hooks. Does not add a root
plugin.json (that would route omp through Agent Plugins 1.0 and drop
user-invoked skills).

Kiro layout (https://kiro.dev/docs/skills/):
  .kiro/skills/      each subdirectory with SKILL.md is a /<name> command

Usage:
  ./kiro.sh                  install to global   ~/.kiro
  ./kiro.sh --global         install to global   ~/.kiro   (explicit)
  ./kiro.sh --project        install to project  ./.kiro
  ./kiro.sh --project DIR    install to project  DIR/.kiro
  ./kiro.sh -h | --help      show this help

Re-running overwrites those promoted skill directories only; other Kiro
content is left intact.
EOF
}

scope="global"
project_dir="."
while [ $# -gt 0 ]; do
  case "$1" in
    --global) scope="global"; shift ;;
    --project)
      scope="project"; shift
      if [ $# -gt 0 ] && [ "${1#-}" = "$1" ]; then project_dir="$1"; shift; fi
      ;;
    -h|--help) usage; exit 0 ;;
    *) echo "kiro.sh: unknown option '$1' (try --help)" >&2; exit 1 ;;
  esac
done

if ! command -v python3 >/dev/null; then
  echo "kiro.sh: python3 required" >&2
  exit 1
fi

if [ ! -f "$PLUGIN" ]; then
  echo "kiro.sh: missing $PLUGIN" >&2
  exit 1
fi

if [ "$scope" = "global" ]; then
  kiro_root="$HOME/.kiro"
else
  if [ ! -d "$project_dir" ]; then
    echo "kiro.sh: project directory '$project_dir' does not exist" >&2
    exit 1
  fi
  kiro_root="$(cd "$project_dir" && pwd)/.kiro"
fi

echo "neo-matt → Kiro"
echo "  source: $REPO"
echo "  target: $kiro_root ($scope)"
echo

mkdir -p "$kiro_root/skills"

skills="$(python3 - "$PLUGIN" "$REPO" "$kiro_root/skills" <<'PY'
import json, os, shutil, sys

plugin_path, repo, dest_root = sys.argv[1], sys.argv[2], sys.argv[3]
buckets = {"engineering", "productivity", "neo"}
manifest = json.load(open(plugin_path, encoding="utf-8"))
seen = set()
count = 0
os.makedirs(dest_root, exist_ok=True)
for rel in manifest["skills"]:
    path = rel[2:] if rel.startswith("./") else rel
    parts = path.split("/")
    if len(parts) != 3 or parts[0] != "skills":
        sys.exit(f"unexpected skills path: {rel}")
    bucket, name = parts[1], parts[2]
    if bucket not in buckets:
        sys.exit(f"non-promoted bucket in {rel}")
    if name in buckets:
        sys.exit(f"skill name collides with bucket: {name}")
    if name in seen:
        sys.exit(f"duplicate skill name: {name}")
    seen.add(name)
    src = os.path.join(repo, "skills", bucket, name)
    if not os.path.isfile(os.path.join(src, "SKILL.md")):
        sys.exit(f"missing SKILL.md: {src}")
    dest = os.path.join(dest_root, name)
    if os.path.islink(dest) or os.path.isfile(dest):
        os.remove(dest)
    elif os.path.isdir(dest):
        shutil.rmtree(dest)
    shutil.copytree(src, dest, symlinks=True)
    count += 1
sys.stdout.write(str(count))
PY
)"

printf '  %-11s %d → %s/  %s\n' "skills:" "$skills" "$kiro_root/skills" "(as /<skill-name>)"
echo
echo "Done. In Kiro, promoted skills appear as /<name> slash commands. No session router is injected."

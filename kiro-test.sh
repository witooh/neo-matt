#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

project_dir="$tmp_dir/project"
global_home="$tmp_dir/home"
mkdir -p "$project_dir/.kiro/hooks" "$project_dir/.kiro/skills/my-own" "$global_home"
printf '%s\n' '{"version":"v1","hooks":[]}' > "$project_dir/.kiro/hooks/user-owned.json"
printf '%s\n' 'USER_OWNED_SKILL' > "$project_dir/.kiro/skills/my-own/SKILL.md"
mkdir -p "$project_dir/.kiro/skills/ask-matt"
printf '%s\n' 'STALE_ASK_MATT' > "$project_dir/.kiro/skills/ask-matt/SKILL.md"

help_out="$("$SCRIPT_DIR/kiro.sh" --help)"
[[ "$help_out" == *"neo-matt → Kiro installer"* ]] || fail "help omitted installer title"
[[ "$help_out" == *".kiro/skills/"* ]] || fail "help omitted skills layout"
[[ "$help_out" != *"using-neo"* ]] || fail "help advertised using-neo"

if "$SCRIPT_DIR/kiro.sh" --nope >/dev/null 2>&1; then
  fail "unknown option did not fail"
fi

if "$SCRIPT_DIR/kiro.sh" --project "$tmp_dir/missing" >/dev/null 2>&1; then
  fail "missing project directory did not fail"
fi

"$SCRIPT_DIR/kiro.sh" --project "$project_dir" >/dev/null

if [ -e "$project_dir/.kiro/steering/AGENTS.md" ]; then
  fail "kiro.sh created .kiro/steering/AGENTS.md"
fi
if [ -e "$project_dir/.kiro/hooks/neo-session-context.json" ]; then
  fail "kiro.sh installed a SessionStart hook"
fi
if [ ! -f "$project_dir/.kiro/hooks/user-owned.json" ]; then
  fail "kiro.sh removed a user-owned hook"
fi
if [ -d "$project_dir/.kiro/skills/using-neo" ]; then
  fail "kiro.sh installed using-neo"
fi
if [ -d "$project_dir/.kiro/skills/engineering" ]; then
  fail "kiro.sh copied a bucket directory as a skill"
fi
if [ -d "$project_dir/.kiro/skills/loop-me" ]; then
  fail "kiro.sh copied an in-progress skill"
fi
if [ ! -f "$project_dir/.kiro/skills/my-own/SKILL.md" ]; then
  fail "kiro.sh removed a user-owned skill"
fi
if ! grep -qF 'USER_OWNED_SKILL' "$project_dir/.kiro/skills/my-own/SKILL.md"; then
  fail "kiro.sh overwrote a user-owned skill"
fi

for name in ask-matt tdd grill-me markitdown implement; do
  if [ ! -f "$project_dir/.kiro/skills/$name/SKILL.md" ]; then
    fail "project install omitted $name"
  fi
done
if grep -qF 'STALE_ASK_MATT' "$project_dir/.kiro/skills/ask-matt/SKILL.md"; then
  fail "re-run left a stale ask-matt copy"
fi

expected="$(python3 -c 'import json,sys; print(len(json.load(open(sys.argv[1]))["skills"]))' "$SCRIPT_DIR/.claude-plugin/plugin.json")"
got="$(find "$project_dir/.kiro/skills" -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l | tr -d ' ')"
# my-own is extra
want=$((expected + 1))
if [ "$got" != "$want" ]; then
  fail "expected $want SKILL.md files (promoted + user-owned), got $got"
fi

HOME="$global_home" "$SCRIPT_DIR/kiro.sh" --global >/dev/null
if [ ! -f "$global_home/.kiro/skills/ask-matt/SKILL.md" ]; then
  fail "global install omitted ask-matt"
fi
if [ -e "$global_home/.kiro/hooks/neo-session-context.json" ]; then
  fail "global install installed a SessionStart hook"
fi
global_got="$(find "$global_home/.kiro/skills" -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l | tr -d ' ')"
if [ "$global_got" != "$expected" ]; then
  fail "global install expected $expected skills, got $global_got"
fi

echo "PASS: kiro.sh copies promoted skills into .kiro/skills/ and leaves other Kiro content alone"

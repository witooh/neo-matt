---
name: ship
description: >
  Project-scope omp maintainer skill for neo-matt. Bump the plugin version,
  pack the working tree into one commit, tag, push, and publish a GitHub
  release, in that order. Takes the bump type as an argument (major | minor |
  patch); infers it from the diff when omitted. Use when the user says
  "/ship", "/ship minor", "/ship patch", "ship it", "cut a release",
  "bump version + commit + push + release", "ออก release",
  "bump + push + release ที่เดียว". Not part of the shipped plugin.
---

# Ship (this repo only)

omp discovers this via `.omp/config.yml` -> `skills.customDirectories: [.agents/skills]`.
It is not under `skills/`, not in `.claude-plugin/plugin.json`, and not linked into
`~/.claude/skills`.

You run this. The user does not have to remember which files hold the version.

Runs the full release chain: **bump -> commit -> tag -> push -> GitHub release**.

**Argument:** `/ship <major|minor|patch>` selects the version bump.

- `/ship minor` -> pack everything, bump the minor version, ship.
- No argument -> **infer** the bump from the change type (see step 2) and show it
  in the preview for the user to confirm.

**Safety model (fixed):** draft everything, do the **local** commit + tag, then
**STOP for one confirmation before the irreversible push + release**. Local
commit/tag are cheap to amend or delete; push and a public GitHub release are not.

## Non-negotiables

- **Two files must share the same version:** `package.json` and
  `.claude-plugin/plugin.json` (Claude Code). Bump both in the same step.
  Marketplace indexes (`.claude-plugin/marketplace.json`,
  `.omp-plugin/marketplace.json`) have no version field: never touch them for
  versioning. Do not recreate a root `plugin.json` (that re-enters Agent Plugins
  and drops user-invoked skills).
- **Semver by change type:** `patch` = fix/docs, `minor` = new skill/feature,
  `major` = breaking.
- **One annotated tag per bump, created after the commit:** `v<version>` (v-prefix),
  message `neo-matt <version>: <headline>`.
- **Release title is the version only** (`v<version>`). The headline goes in the
  notes body, never the title.
- **Commit to the current branch** (this repo ships from `main`; do not open a
  feature branch).
- Every commit message ends with a `Co-Authored-By:` trailer naming **the model
  that wrote it**, taken from this session, never copied from this file or from
  an earlier commit. If the session does not name the model, drop the name rather
  than guess one.
- Do not use Matt's changeset flow for a fork release. This skill is the doer.
  After bumping, prepend a `## <next>` section to `CHANGELOG.md` under the
  `# neo-matt` heading.

## Workflow

### 1. Preconditions

```bash
git rev-parse --show-toplevel        # must be the neo-matt repo root
git branch --show-current            # the branch we commit + push
gh auth status                       # gh must be authenticated
git status --porcelain               # must be NON-empty, else "nothing to ship", stop
```

If cwd is not this repo, stop. Do not stash unless the user asked.

### 2. Determine the new version

Read the current version from `package.json` and confirm
`.claude-plugin/plugin.json` matches it. If they diverge, stop and fix; do not
pick one silently.

When no bump arg was given, infer it: any breaking change -> `major`; a new
skill or feature -> `minor`; otherwise (fix/docs/refactor) -> `patch`.

```bash
cur=$(python3 -c "import json;print(json.load(open('package.json'))['version'])")
IFS=. read -r MA MI PA <<< "$cur"
case "$BUMP" in
  major) next="$((MA+1)).0.0";;
  minor) next="$MA.$((MI+1)).0";;
  patch) next="$MA.$MI.$((PA+1))";;
esac
echo "$cur -> $next"
```

### 3. Stage + draft (no commit yet)

1. Bump the `version` field in `package.json` and `.claude-plugin/plugin.json`
   to `<next>`.
2. Prepend a `## <next>` section to `CHANGELOG.md` (under `# neo-matt`, above
   the previous fork release). Keep Matt's archived `# mattpocock-skills`
   history untouched.
3. Pack everything: `git add -A` (all changes including untracked, plus the
   manifests).
4. Draft the **commit message**: Conventional Commits (`type(scope): subject`),
   a body saying what changed and why, derived from `git diff --cached`. End
   with the Co-Authored-By trailer. Write it to a temp file.
5. Draft the **release notes**: `### neo-matt <next>: <headline>`, then the
   sections that apply (`Added` / `Changed` / `Fixed` / `Removed` / `Notes`).
   Check the last GitHub release first:

   ```bash
   gh release view "$(git tag --sort=-v:refname | head -1)"
   ```

   Write the notes to a temp file.

### 4. Preview -> local commit + tag -> STOP

Show the user, in one message:

- `cur -> next` version and the inferred/selected bump type
- `git diff --cached --stat` (what is being packed)
- the drafted commit message
- the drafted release notes

Then do the **local** steps only:

```bash
git commit -F <commit-msg-file>
git tag -a "v$next" -m "neo-matt $next: <headline>"
```

**Stop here.** Ask the user to confirm the push + release (a single yes). Do
NOT run step 5 until they reply. If they want changes: `git tag -d v$next`,
amend the commit or edit the notes, re-preview.

### 5. On confirm: push + publish

```bash
git push origin "$(git branch --show-current)" && git push origin "v$next"
gh release create "v$next" --title "v$next" --notes-file <notes-file> --latest
```

### 6. Report

Version, commit SHA, tag, and the release URL.

## Red flags: stop and fix, do not ship through them

- Working tree is clean -> nothing to ship; do not cut an empty release.
- `gh auth status` fails -> resolve auth first; a half-done chain (pushed, no
  release) is worse than not starting.
- Tempted to edit a `marketplace.json` for the version -> don't; those indexes
  have no version field.
- Release **title** contains the headline -> wrong; title is `v<version>` only.
- Pushing before the user confirmed the preview -> never; the confirm gate is
  the point.
- Version files disagree before the bump -> stop; do not invent a winner.

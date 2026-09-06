#!/usr/bin/env node
// Copies package.json's version into .claude-plugin/plugin.json and
// .grok-plugin/plugin.json. Runs as part of `npm run version`, immediately
// after `changeset version`.
// With --check it changes nothing and exits 1 if any version differs, or if
// the two skills arrays differ (Grok's manifest takes precedence; omitting
// skills ships ./skills as one dir, including non-promoted buckets).

import { readFileSync, writeFileSync } from "node:fs";
import { dirname, join, relative } from "node:path";
import { fileURLToPath } from "node:url";

const repo = join(dirname(fileURLToPath(import.meta.url)), "..");
const { version } = JSON.parse(readFileSync(join(repo, "package.json"), "utf8"));
const check = process.argv.includes("--check");

const pluginPaths = [
  join(repo, ".claude-plugin", "plugin.json"),
  join(repo, ".grok-plugin", "plugin.json"),
];

const loaded = pluginPaths.map((pluginPath) => {
  const source = readFileSync(pluginPath, "utf8");
  return { pluginPath, rel: relative(repo, pluginPath), source, plugin: JSON.parse(source) };
});

const [claude, grok] = loaded;
if (JSON.stringify(claude.plugin.skills) !== JSON.stringify(grok.plugin.skills)) {
  console.error(
    `.grok-plugin/plugin.json skills array must match .claude-plugin/plugin.json.`,
  );
  process.exit(1);
}

let failed = false;
for (const { pluginPath, rel, source, plugin } of loaded) {
  if (plugin.version === version) {
    console.log(`${rel} version is ${version} (already in sync)`);
    continue;
  }

  if (check) {
    console.error(
      `${rel} version is ${plugin.version}, package.json is ${version}. Run \`node scripts/sync-plugin-version.mjs\`.`,
    );
    failed = true;
    continue;
  }

  const updated = source.replace(
    /("version"\s*:\s*")[^"]*(")/,
    `$1${version}$2`,
  );

  if (JSON.parse(updated).version !== version) {
    console.error(`Could not find a version field to replace in ${pluginPath}.`);
    process.exit(1);
  }

  writeFileSync(pluginPath, updated);
  console.log(`${rel} version ${plugin.version} -> ${version}`);
}

if (failed) {
  process.exit(1);
}

import { readFileSync, readdirSync, statSync, existsSync } from 'node:fs';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

function readJson(filePath) {
  try {
    return JSON.parse(readFileSync(filePath, 'utf8'));
  } catch (err) {
    return { __error: `${filePath}: JSON inválido — ${err.message}` };
  }
}

function parseFrontmatter(md) {
  const match = md.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!match) return null;
  const block = match[1];
  const out = {};
  for (const line of block.split(/\r?\n/)) {
    const m = line.match(/^([a-zA-Z_][a-zA-Z0-9_-]*):\s*(.*)$/);
    if (m) out[m[1]] = m[2].trim();
  }
  return out;
}

function* walk(dir) {
  for (const entry of readdirSync(dir)) {
    const full = path.join(dir, entry);
    const st = statSync(full);
    if (st.isDirectory()) {
      yield { type: 'dir', path: full, name: entry };
      yield* walk(full);
    } else {
      yield { type: 'file', path: full, name: entry };
    }
  }
}

export function validate(repoRoot) {
  const errors = [];
  const push = (msg) => errors.push(msg);

  // 1. marketplace.json exists and parses
  const mpPath = path.join(repoRoot, '.claude-plugin', 'marketplace.json');
  if (!existsSync(mpPath)) {
    push(`marketplace.json não encontrado em ${mpPath}`);
    return { ok: false, errors };
  }
  const mp = readJson(mpPath);
  if (mp.__error) {
    push(mp.__error);
    return { ok: false, errors };
  }

  // 2. Required fields
  for (const field of ['name', 'owner']) {
    if (!(field in mp)) push(`marketplace.json: campo "${field}" obrigatório`);
  }
  if (!Array.isArray(mp.plugins)) {
    push('marketplace.json: campo "plugins" obrigatório e deve ser array');
    return { ok: false, errors };
  }

  // 3. Each plugin entry
  for (const p of mp.plugins) {
    for (const f of ['name', 'source', 'version', 'description']) {
      if (!(f in p)) push(`marketplace.json plugin: campo "${f}" obrigatório (entrada: ${JSON.stringify(p)})`);
    }
    if (typeof p.source !== 'string' || p.source.trim() === '') {
      push(`marketplace.json plugin "${p.name ?? '?'}": campo "source" deve ser string não vazia`);
      continue;
    }
    const pluginDir = path.join(repoRoot, p.source);
    if (!existsSync(pluginDir)) {
      push(`marketplace.json: source "${p.source}" aponta para pasta inexistente`);
      continue;
    }
    const pluginJsonPath = path.join(pluginDir, '.claude-plugin', 'plugin.json');
    if (!existsSync(pluginJsonPath)) {
      push(`${p.source}: .claude-plugin/plugin.json não encontrado`);
      continue;
    }
    const pj = readJson(pluginJsonPath);
    if (pj.__error) { push(pj.__error); continue; }
    for (const f of ['name', 'version']) {
      if (!(f in pj)) push(`${p.source}/.claude-plugin/plugin.json: campo "${f}" obrigatório`);
    }
    if ('name' in pj && pj.name !== p.name) {
      push(`${p.source}: plugin.json.name "${pj.name}" != marketplace name "${p.name}"`);
    }

    // 4. Skills frontmatter
    const skillsDir = path.join(pluginDir, 'skills');
    if (existsSync(skillsDir)) {
      for (const skillName of readdirSync(skillsDir)) {
        const skillMd = path.join(skillsDir, skillName, 'SKILL.md');
        if (!existsSync(skillMd)) continue;
        const fm = parseFrontmatter(readFileSync(skillMd, 'utf8'));
        if (!fm) {
          push(`${path.relative(repoRoot, skillMd)}: frontmatter YAML ausente ou inválido`);
          continue;
        }
        for (const f of ['name', 'description']) {
          if (!fm[f]) push(`${path.relative(repoRoot, skillMd)}: frontmatter sem "${f}"`);
        }
      }
    }
  }

  // 5. No .svn anywhere under plugins/
  const pluginsRoot = path.join(repoRoot, 'plugins');
  if (existsSync(pluginsRoot)) {
    for (const entry of walk(pluginsRoot)) {
      if (entry.type === 'dir' && entry.name === '.svn') {
        push(`pasta .svn proibida encontrada: ${path.relative(repoRoot, entry.path)}`);
      }
    }
  }

  return { ok: errors.length === 0, errors };
}

// CLI
if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  const root = process.argv[2] || process.cwd();
  const result = validate(root);
  if (result.ok) {
    console.log(`✔ Validação OK (${root})`);
    process.exit(0);
  } else {
    console.error(`✗ ${result.errors.length} erro(s) em ${root}:`);
    for (const e of result.errors) console.error(`  - ${e}`);
    process.exit(1);
  }
}

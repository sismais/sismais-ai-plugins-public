import { test } from 'node:test';
import assert from 'node:assert/strict';
import { validate } from '../scripts/validate.mjs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const fixture = (name) => path.join(__dirname, 'fixtures', name);

test('valid fixture returns no errors', () => {
  const result = validate(fixture('valid'));
  assert.deepEqual(result.errors, []);
  assert.equal(result.ok, true);
});

test('missing marketplace.json reports error', () => {
  const result = validate(fixture('missing-marketplace'));
  assert.equal(result.ok, false);
  assert.ok(result.errors.some(e => e.includes('marketplace.json não encontrado')));
});

test('bad JSON reports parse error', () => {
  const result = validate(fixture('bad-json'));
  assert.equal(result.ok, false);
  assert.ok(result.errors.some(e => e.includes('JSON inválido')));
});

test('plugin source pointing to missing folder is detected', () => {
  const result = validate(fixture('missing-plugin-folder'));
  assert.equal(result.ok, false);
  assert.ok(result.errors.some(e => e.includes('pasta inexistente')));
});

test('name mismatch between marketplace and plugin.json is detected', () => {
  const result = validate(fixture('name-mismatch'));
  assert.equal(result.ok, false);
  assert.ok(result.errors.some(e => e.includes('plugin.json.name')));
});

test('skill without frontmatter is detected', () => {
  const result = validate(fixture('skill-no-frontmatter'));
  assert.equal(result.ok, false);
  assert.ok(result.errors.some(e => e.includes('frontmatter YAML ausente')));
});

test('forbidden .svn folder is detected', () => {
  const result = validate(fixture('has-svn'));
  assert.equal(result.ok, false);
  assert.ok(result.errors.some(e => e.includes('.svn proibida')));
});

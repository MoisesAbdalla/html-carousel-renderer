import { readFileSync, writeFileSync } from 'node:fs';

import { dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
const base = dirname(fileURLToPath(import.meta.url));
const dataUri = (p, mime) => `data:${mime};base64,${readFileSync(p).toString('base64')}`;

let html = readFileSync(`${base}/preview.template.html`, 'utf8');

html = html.replace('__LOGO__', dataUri(`${base}/assets/logo-h.png`, 'image/png'));
for (let n = 1; n <= 7; n++) {
  html = html.replace(`__IMG${n}__`, dataUri(`${base}/out/_preview/s${n}.jpg`, 'image/jpeg'));
}

if (html.includes('__IMG') || html.includes('__LOGO__')) {
  throw new Error('sobrou placeholder sem substituir');
}

writeFileSync(`${base}/preview.html`, html);
console.log(`preview.html: ${(Buffer.byteLength(html) / 1024 / 1024).toFixed(2)} MB`);

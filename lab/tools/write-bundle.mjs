import { mkdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const appDir = join(dirname(fileURLToPath(import.meta.url)), "..", "app");
const outDir = join(appDir, "generated");
mkdirSync(outDir, { recursive: true });

const chunk =
  'window.__AC__=Object.assign(window.__AC__||{},{sku:"TEA-001",css:".site{color:#0b3d2e;font:14px Segoe UI;padding:24px 32px;background:#faf7f2}",html:"<div class=\\"noprint\\"></div>"});';

const lines = ["/* GENERATED FILE. Do not edit. Source of truth is src/. */"];
for (let i = 0; i < 80; i += 1) {
  lines.push(chunk.replaceAll("__AC__", `__AC_${i}__`));
}

const text = `${lines.join("\n")}\n`;
writeFileSync(join(outDir, "receipt-bundle.js"), text);
console.log(`wrote ${text.length} chars`);

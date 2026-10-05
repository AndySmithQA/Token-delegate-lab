#!/usr/bin/env node
/**
 * Local, approximate token count for comparing lab files before a Copilot call.
 * Uses the common teaching estimate of about 4 characters per token.
 * Copilot CLI /usage and /context are the meters that match what you consume.
 */
import { readFileSync } from "node:fs";
import { basename } from "node:path";

function estimate(text) {
  const chars = [...text].length;
  const words = text.trim() === "" ? 0 : text.trim().split(/\s+/).length;
  const tokens = Math.max(1, Math.ceil(chars / 4));
  return { chars, words, tokens };
}

const files = process.argv.slice(2).filter((arg) => !arg.startsWith("--"));

if (files.length === 0) {
  console.error("Usage: node estimate-tokens.mjs <file> [file...]");
  process.exit(1);
}

const rows = files.map((file) => {
  const text = readFileSync(file, "utf8");
  return { file: basename(file), ...estimate(text) };
});

const nameWidth = Math.max(4, ...rows.map((row) => row.file.length));
const header = `${"File".padEnd(nameWidth)}  ${"Chars".padStart(8)}  ${"Words".padStart(8)}  ${"Est. tokens".padStart(12)}`;
console.log(header);
console.log("-".repeat(header.length));
for (const row of rows) {
  console.log(
    `${row.file.padEnd(nameWidth)}  ${String(row.chars).padStart(8)}  ${String(row.words).padStart(8)}  ${String(row.tokens).padStart(12)}`
  );
}

console.log("");
console.log("Estimate only: about 4 characters per token for English text.");
console.log("Read real consumption in Copilot CLI with /context and /usage.");

if (rows.length === 2 && rows[1].tokens > 0) {
  const [first, second] = [...rows].sort((a, b) => b.tokens - a.tokens);
  const ratio = (first.tokens / second.tokens).toFixed(1);
  console.log(`${first.file} is about ${ratio}x the estimated tokens of ${second.file}.`);
}

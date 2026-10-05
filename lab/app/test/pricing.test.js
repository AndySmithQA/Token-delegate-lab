import assert from "node:assert/strict";
import { test } from "node:test";
import { calculateLineTotal, calculateOrderTotal } from "../src/pricing.js";

test("does not discount a line with quantity 2", () => {
  // 2 x 50 = 100 pre-tax. Quantity 2 is below the discount threshold. Tax is 20%.
  assert.equal(calculateLineTotal(50, 2), 120);
});

test("discounts a line with quantity 3 before tax", () => {
  // 3 x 50 = 150; 10% discount = 135; tax 20% = 162.
  assert.equal(calculateLineTotal(50, 3), 162);
});

test("sums mixed lines", () => {
  const total = calculateOrderTotal([
    { unitPrice: 50, quantity: 2 },
    { unitPrice: 10, quantity: 3 },
  ]);
  // 120 + (30 * 0.9 * 1.2 = 32.40) = 152.40
  assert.equal(total, 152.4);
});

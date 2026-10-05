/** Standard VAT-style rate applied after any line discount. */
export const TAX_RATE = 0.2;

/** Half-up rounding to 2 decimal places. */
export function roundMoney(amount) {
  return Math.round((amount + Number.EPSILON) * 100) / 100;
}

/**
 * Line total for one product.
 * Quantity discount is currently applied, then tax.
 */
export function calculateLineTotal(unitPrice, quantity) {
  if (!Number.isFinite(unitPrice) || !Number.isFinite(quantity)) {
    throw new Error("Price and quantity must be numbers");
  }
  if (unitPrice < 0 || quantity < 0) {
    throw new Error("Price and quantity must be zero or positive");
  }

  const gross = unitPrice * quantity;
  const discount = quantity >= 2 ? 0.1 : 0;
  const discounted = gross * (1 - discount);
  return roundMoney(discounted * (1 + TAX_RATE));
}

/** Sum of line totals. Each line is { unitPrice, quantity }. */
export function calculateOrderTotal(lines) {
  const total = lines.reduce(
    (sum, line) => sum + calculateLineTotal(line.unitPrice, line.quantity),
    0
  );
  return roundMoney(total);
}

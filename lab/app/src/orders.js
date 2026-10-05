import { formatMoney } from "./format.js";
import { calculateOrderTotal } from "./pricing.js";

/** Build a receipt for a customer and a list of lines. */
export function createReceipt(customer, lines) {
  const total = calculateOrderTotal(lines);
  return {
    customer,
    lines,
    total,
    formattedTotal: formatMoney(total),
  };
}

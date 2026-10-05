import { createReceipt } from "./orders.js";

const receipt = createReceipt("Ada Lovelace", [
  { sku: "TEA-001", unitPrice: 50, quantity: 2 },
  { sku: "MUG-014", unitPrice: 10, quantity: 3 },
]);

console.log(receipt.customer);
for (const line of receipt.lines) {
  console.log(`${line.sku}  x${line.quantity}  @ ${line.unitPrice}`);
}
console.log(`Total ${receipt.formattedTotal}`);

const currencyFormat = new Intl.NumberFormat("en-GB", {
  style: "currency",
  currency: "GBP",
});

/** Format a numeric amount as GBP. */
export function formatMoney(amount) {
  return currencyFormat.format(amount);
}

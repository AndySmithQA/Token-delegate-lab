---
applyTo: "src/pricing.js,test/pricing.test.js"
---

10% discount only when quantity is 3 or more.
Apply the discount to the pre-tax line amount, then `TAX_RATE`. Tax is not discounted.
`src/pricing.js` uses `quantity >= 2`. That is the bug. Change the comparison. Do not change the tests.
Round with `roundMoney`.
Verify with `node --test`. Do not run `npm install`, `npm test`, or `npm --test`.

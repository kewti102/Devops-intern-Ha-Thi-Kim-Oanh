const test = require("node:test");
const assert = require("node:assert");

test("2 + 2 = 4", () => {
  assert.strictEqual(2 + 2, 4);
});

test("10 - 5 = 5", () => {
  assert.strictEqual(10 - 5, 5);
});

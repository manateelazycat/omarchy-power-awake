const assert = require("node:assert/strict")
const test = require("node:test")

const model = require("../PowerAwakeModel.js")

test("enabled automation keeps an AC-powered machine awake", () => {
  assert.equal(model.shouldStayAwake(true, false), true)
  assert.equal(model.idleShouldBeEnabled(true, false), false)
})

test("enabled automation restores idle handling on battery", () => {
  assert.equal(model.shouldStayAwake(true, true), false)
  assert.equal(model.idleShouldBeEnabled(true, true), true)
})

test("disabled automation always restores idle handling", () => {
  assert.equal(model.shouldStayAwake(false, false), false)
  assert.equal(model.shouldStayAwake(false, true), false)
  assert.equal(model.idleShouldBeEnabled(false, false), true)
  assert.equal(model.idleShouldBeEnabled(false, true), true)
})

test("status text describes every visible state", () => {
  assert.equal(model.statusText(false, false), "Power Awake: Off · Idle enabled")
  assert.equal(model.statusText(true, true), "Power Awake: On · Battery · Screensaver and lock enabled")
  assert.equal(model.statusText(true, false), "Power Awake: On · Plugged in · Staying awake")
})

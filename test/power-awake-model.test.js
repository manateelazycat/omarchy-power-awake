const assert = require("node:assert/strict")
const test = require("node:test")

const model = require("../PowerAwakeModel.js")

test("only a present system battery makes a machine count as a laptop", () => {
  assert.equal(model.hasLaptopBattery(null), false)
  assert.equal(model.hasLaptopBattery({ ready: false, isPresent: true, isLaptopBattery: true }), false)
  assert.equal(model.hasLaptopBattery({ ready: true, isPresent: false, isLaptopBattery: true }), false)
  assert.equal(model.hasLaptopBattery({ ready: true, isPresent: true, isLaptopBattery: false }), false)
  assert.equal(model.hasLaptopBattery({ ready: true, isPresent: true, isLaptopBattery: true }), true)
})

test("enabled automation keeps an AC-powered machine awake", () => {
  assert.equal(model.shouldStayAwake(true, false, true), true)
  assert.equal(model.idleShouldBeEnabled(true, false, true), false)
})

test("enabled automation restores idle handling on battery", () => {
  assert.equal(model.shouldStayAwake(true, true, true), false)
  assert.equal(model.idleShouldBeEnabled(true, true, true), true)
})

test("a desktop stays awake while the option is on, regardless of UPower battery state", () => {
  assert.equal(model.shouldStayAwake(true, false, false), true)
  assert.equal(model.shouldStayAwake(true, true, false), true)
  assert.equal(model.idleShouldBeEnabled(true, true, false), false)
})

test("disabled automation always restores idle handling", () => {
  assert.equal(model.shouldStayAwake(false, false, true), false)
  assert.equal(model.shouldStayAwake(false, true, true), false)
  assert.equal(model.shouldStayAwake(false, false, false), false)
  assert.equal(model.shouldStayAwake(false, true, false), false)
  assert.equal(model.idleShouldBeEnabled(false, false, true), true)
  assert.equal(model.idleShouldBeEnabled(false, true, false), true)
})

test("status text describes every visible state", () => {
  assert.equal(model.statusText(false, false, false), "Power Awake: Off · Idle enabled")
  assert.equal(model.statusText(true, true, false), "Power Awake: On · Desktop · Staying awake")
  assert.equal(model.statusText(true, true, true), "Power Awake: On · Battery · Screensaver and lock enabled")
  assert.equal(model.statusText(true, false, true), "Power Awake: On · Plugged in · Staying awake")
})

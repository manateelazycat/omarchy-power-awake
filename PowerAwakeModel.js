function hasLaptopBattery(device) {
  return !!(device && device.ready && device.isPresent && device.isLaptopBattery)
}

function shouldStayAwake(automationEnabled, onBattery, hasLaptopBattery) {
  return !!automationEnabled && (!hasLaptopBattery || !onBattery)
}

function idleShouldBeEnabled(automationEnabled, onBattery, hasLaptopBattery) {
  return !shouldStayAwake(automationEnabled, onBattery, hasLaptopBattery)
}

function statusText(automationEnabled, onBattery, hasLaptopBattery) {
  if (!automationEnabled) return "Power Awake: Off · Idle enabled"
  if (!hasLaptopBattery) return "Power Awake: On · Desktop · Staying awake"
  if (onBattery) return "Power Awake: On · Battery · Screensaver and lock enabled"
  return "Power Awake: On · Plugged in · Staying awake"
}

if (typeof module !== "undefined") {
  module.exports = {
    hasLaptopBattery: hasLaptopBattery,
    shouldStayAwake: shouldStayAwake,
    idleShouldBeEnabled: idleShouldBeEnabled,
    statusText: statusText
  }
}

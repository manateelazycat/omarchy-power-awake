function shouldStayAwake(automationEnabled, onBattery) {
  return !!automationEnabled && !onBattery
}

function idleShouldBeEnabled(automationEnabled, onBattery) {
  return !shouldStayAwake(automationEnabled, onBattery)
}

function statusText(automationEnabled, onBattery) {
  if (!automationEnabled) return "Power Awake: Off · Idle enabled"
  if (onBattery) return "Power Awake: On · Battery · Screensaver and lock enabled"
  return "Power Awake: On · Plugged in · Staying awake"
}

if (typeof module !== "undefined") {
  module.exports = {
    shouldStayAwake: shouldStayAwake,
    idleShouldBeEnabled: idleShouldBeEnabled,
    statusText: statusText
  }
}

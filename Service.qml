import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import "PowerAwakeModel.js" as PowerAwakeModel

Item {
  id: root

  property var shell: null

  readonly property bool automationEnabled: persisted.automationEnabled
  readonly property bool onBattery: UPower.onBattery
  readonly property bool pluggedIn: !onBattery
  readonly property bool stayAwake: PowerAwakeModel.shouldStayAwake(automationEnabled, onBattery)
  readonly property string tooltipText: PowerAwakeModel.statusText(automationEnabled, onBattery)

  property bool ready: false
  property bool applied: false
  property var pendingIdleEnabled: null
  property int applyRetries: 0

  PersistentProperties {
    id: persisted
    reloadableId: "io-github-manateelazycat-power-awake"
    property bool automationEnabled: true
  }

  function applyPowerState() {
    root.pendingIdleEnabled = PowerAwakeModel.idleShouldBeEnabled(root.automationEnabled, root.onBattery)
    root.applyRetries = 0
    retryTimer.stop()
    root.ready = true
    root.runPendingPowerState()
    return true
  }

  function runPendingPowerState() {
    if (applyProcess.running || root.pendingIdleEnabled === null) return

    var idleEnabled = root.pendingIdleEnabled === true
    root.pendingIdleEnabled = null
    root.applied = false
    applyProcess.command = [
      "omarchy-shell",
      "idle",
      idleEnabled ? "enable" : "disable"
    ]
    applyProcess.running = true
  }

  function setAutomationEnabled(value) {
    persisted.automationEnabled = !!value
    Qt.callLater(root.applyPowerState)
    return root.statusJson()
  }

  function toggle() {
    return setAutomationEnabled(!root.automationEnabled)
  }

  function statusJson() {
    return JSON.stringify({
      enabled: root.automationEnabled,
      onBattery: root.onBattery,
      pluggedIn: root.pluggedIn,
      stayAwake: root.stayAwake,
      idleEnabled: !root.stayAwake,
      applied: root.applied
    })
  }

  Process {
    id: applyProcess

    onExited: function(exitCode) {
      if (root.pendingIdleEnabled !== null) {
        root.runPendingPowerState()
        return
      }

      root.applied = exitCode === 0
      if (!root.applied && root.applyRetries < 30) {
        root.applyRetries++
        retryTimer.start()
      }
    }
  }

  Timer {
    id: retryTimer
    interval: 1000
    repeat: false
    onTriggered: {
      root.pendingIdleEnabled = PowerAwakeModel.idleShouldBeEnabled(root.automationEnabled, root.onBattery)
      root.runPendingPowerState()
    }
  }

  onShellChanged: Qt.callLater(root.applyPowerState)
  onAutomationEnabledChanged: Qt.callLater(root.applyPowerState)

  Connections {
    target: UPower

    function onOnBatteryChanged() {
      root.applyPowerState()
    }
  }

  IpcHandler {
    target: "io.github.manateelazycat.power-awake"

    function status(): string { return root.statusJson() }
    function enable(): string { return root.setAutomationEnabled(true) }
    function disable(): string { return root.setAutomationEnabled(false) }
    function toggle(): string { return root.toggle() }
  }

  Component.onCompleted: Qt.callLater(root.applyPowerState)

  Component.onDestruction: {
    if (root.automationEnabled)
      Quickshell.execDetached(["omarchy", "toggle", "idle", "allow-idle"])
  }
}

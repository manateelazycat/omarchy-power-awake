import QtQuick
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "io.github.manateelazycat.power-awake"

  readonly property var powerAwakeService: bar?.shell?.serviceFor(root.moduleName)
  readonly property bool automationEnabled: powerAwakeService ? powerAwakeService.automationEnabled : true
  readonly property bool onBattery: powerAwakeService ? powerAwakeService.onBattery : false

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰚥"
    active: root.automationEnabled && !root.onBattery
    useActiveColor: false
    dimmed: !root.automationEnabled
    slotSize: Style.bar.statusSlot
    fontSize: Style.font.caption
    tooltipText: root.powerAwakeService
      ? root.powerAwakeService.tooltipText
      : "Power Awake is starting"

    onPressed: function() {
      if (root.powerAwakeService) root.powerAwakeService.toggle()
    }
  }
}

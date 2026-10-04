pragma ComponentBehavior: Bound
import QtQuick
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "io.github.manateelazycat.power-awake"

  readonly property var powerAwakeService: bar?.shell?.serviceFor(root.moduleName)
  readonly property bool automationEnabled: powerAwakeService ? powerAwakeService.automationEnabled : true
  readonly property bool stayAwake: powerAwakeService?.stayAwake === true

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    iconComponent: Component {
      PowerAwakeIcon {
        color: button.foreground
      }
    }
    active: root.stayAwake
    useActiveColor: false
    dimmed: false
    slotSize: Style.bar.iconSlot
    tooltipText: root.powerAwakeService
      ? root.powerAwakeService.tooltipText
      : "Power Awake is starting"

    onPressed: function() {
      if (root.powerAwakeService) root.powerAwakeService.toggle()
    }
  }
}

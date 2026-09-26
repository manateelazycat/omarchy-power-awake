# Omarchy Power Awake

简体中文 | [English](README.md)

![Omarchy Power Awake](preview.jpg)

让台式机保持唤醒；笔记本接通电源时自动保持唤醒，使用电池时恢复屏保和锁屏。

插件会在 Omarchy 状态栏中间添加一个电源插头图标。点击图标可开启或关闭此选项。首次使用时默认开启，选择会在 Shell 重启后保留。

## 安装

```bash
omarchy plugin add https://github.com/manateelazycat/omarchy-power-awake.git --enable
```

无需额外脚本、systemd 服务或配置。

## 行为

| 选项 | 设备／电源状态 | 效果 |
| --- | --- | --- |
| 开启 | 台式机（没有笔记本电池） | 禁用屏保和空闲锁屏 |
| 开启 | 笔记本接通电源 | 禁用屏保和空闲锁屏 |
| 开启 | 笔记本使用电池 | 屏保和空闲锁屏使用 Omarchy 的正常超时设置 |
| 关闭 | 任意设备 | 屏保和空闲锁屏使用 Omarchy 的正常超时设置 |

插件通过 Quickshell 的 UPower 服务检测笔记本电池及电源变化，并通过 Omarchy 空闲服务的 IPC 控制「保持唤醒」。无线外设的电池不会让台式机被识别为笔记本。插件不会修改 `~/.config/omarchy/shell.json` 中的超时设置。

## 命令行

```bash
omarchy-shell io.github.manateelazycat.power-awake status
omarchy-shell io.github.manateelazycat.power-awake enable
omarchy-shell io.github.manateelazycat.power-awake disable
omarchy-shell io.github.manateelazycat.power-awake toggle
```

## 更新

```bash
omarchy plugin update io.github.manateelazycat.power-awake --yes
```

## 卸载

```bash
omarchy plugin remove io.github.manateelazycat.power-awake
```

卸载或禁用插件后，Omarchy 会恢复正常的空闲管理。

## 依赖

- Omarchy 4（Quattro）
- Omarchy 自带的 UPower

## 开发

```bash
npm test
omarchy plugin validate .
qmllint -I "$OMARCHY_PATH/shell" BarWidget.qml Service.qml
```

## 协议

GPL-3.0-only

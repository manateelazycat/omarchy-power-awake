# Omarchy Power Awake

![Omarchy Power Awake](https://github.com/user-attachments/assets/977c4dc4-0d05-4083-8d36-2734cbbc4147)

Automatically stays awake while plugged in and restores the screensaver and lock screen on battery power.

The plugin adds a power-plug icon to the center of the Omarchy bar. Click the icon to turn the automation on or off. The option is enabled by default and the selected state persists across shell restarts.

## Install

```bash
omarchy plugin add https://github.com/manateelazycat/omarchy-power-awake.git --enable
```

No additional scripts, systemd services, or configuration are required.

## Behavior

| Option | Power source | Result |
| --- | --- | --- |
| On | Plugged in | Screensaver and idle lock are disabled |
| On | Battery | Screensaver and idle lock use the normal Omarchy timeouts |
| Off | Any | Screensaver and idle lock use the normal Omarchy timeouts |

The plugin uses Quickshell's UPower service to react to power-source changes and Omarchy's built-in `omarchy toggle idle` command to control Stay Awake. It does not modify timeout values in `~/.config/omarchy/shell.json`.

## Command line

```bash
omarchy-shell io.github.manateelazycat.power-awake status
omarchy-shell io.github.manateelazycat.power-awake enable
omarchy-shell io.github.manateelazycat.power-awake disable
omarchy-shell io.github.manateelazycat.power-awake toggle
```

## Update

```bash
omarchy plugin update io.github.manateelazycat.power-awake --yes
```

## Remove

```bash
omarchy plugin remove io.github.manateelazycat.power-awake
```

Removing or disabling the plugin restores normal Omarchy idle handling.

## Requirements

- Omarchy 4 (Quattro)
- UPower, included with Omarchy

## Development

```bash
npm test
omarchy plugin validate .
qmllint -I "$OMARCHY_PATH/shell" BarWidget.qml Service.qml
```

## License

GPL-3.0-only

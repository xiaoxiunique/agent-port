# Agent Port

Cross-platform Flutter client for [Agent Monitor](../agent-monitor) — monitor and control agent sessions (Claude Code, Codex, …) running in tmux on your Mac.

One Dart codebase, six platforms (iOS / Android / macOS / Linux / Windows / Web). Connects to the Rust Agent Monitor service over HTTP + WebSocket.

## Features

- **Live session/pane list** — WebSocket `/ws` with HTTP polling fallback
- **Interactive terminal** — xterm over `/terminal/ws` (PTY lives on the server, no local PTY needed)
- **Actions/messages** — text + control-key input (Codex auto-Tab, Claude Enter), action chips
- **Image upload** — `image_picker` → raw bytes to `/api/upload-image`
- **Multi-server profiles** + onboarding + settings
- **CC Switch** provider switching + project history launch
- **macOS host** — menu-bar tray, Rust subprocess lifecycle (health-check + auto-restart), control center, cc/cx wrapper install, LAN IP detection
- **iOS Picture-in-Picture** — logs rendered to CVPixelBuffer video frames + `AVPictureInPictureController`

## Requirements

- The Agent Monitor **Rust service** running on each Mac you want to monitor (it serves the HTTP/WebSocket API this client consumes). See the `agent-monitor` repo.
- Flutter 3.13+ / Dart 3.x.

## Run

```bash
flutter pub get
flutter run -d macos    # or: ios | chrome | android | windows | linux
```

On first launch, onboarding asks for the service URL (+ optional token).

## Platform status

| Platform | Status |
|---|---|
| macOS | Full (host service + menu bar + control center) |
| iOS | Full (incl. PiP, iOS 17+) |
| Android | Builds (cleartext HTTP allowed for local/trusted nets) |
| Web | Builds |
| Linux / Windows | Builds (remote-client only — tmux host is Unix-only) |

## Architecture

```
lib/
├── core/            router, theme
├── data/
│   ├── api/         AgentMonitorApi (dio, 11 endpoints)
│   └── models/      freezed models (snapshot, pane, interaction, …)
├── services/        snapshotProvider (WS), terminal session, host service, PiP, settings
└── features/        monitor, pane_detail (terminal/actions/status), settings, onboarding, control_center
```

The client reuses the Rust service's API verbatim — no server-side changes.

## License

MIT

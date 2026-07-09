# Agent Port

Local-first monitor and control surface for agent sessions (Claude Code, Codex, …) running in tmux on your Mac.

Ships as a Flutter client in this repo; the service it talks to is the
[`amux`](https://github.com/xiaoxiunique/amux) CLI (Axum + portable-pty + tmux),
maintained in its own repo and bundled inside the macOS host app:
- **`amux serve`** — Rust service (the macOS host builds it with `--features full`)
- **Flutter client** (`lib/`) — one Dart codebase, six platforms (iOS / Android / macOS / Linux / Windows / Web)

## Features

- **Live session/pane list** — WebSocket `/ws` with HTTP polling fallback
- **Interactive terminal** — xterm over `/terminal/ws` (PTY lives on the server, no local PTY needed)
- **Actions/messages** — text + control-key input (Codex auto-Tab, Claude Enter), action chips
- **Image upload** — `image_picker` → raw bytes to `/api/upload-image`
- **Multi-server profiles** + onboarding + settings
- **CC Switch** provider switching + project history launch
- **macOS host** — menu-bar tray, Rust subprocess lifecycle (health-check + auto-restart), control center, cc/cx wrapper install, LAN IP detection
- **iOS push** — APNs device-token registration + per-session notify config

## Requirements

- Flutter 3.13+ / Dart 3.x.
- Rust toolchain (for the service).
- tmux (on each monitored Mac).

## Run

**1. Install & start the service** (the `amux` CLI — polls tmux, serves HTTP/WebSocket):

```bash
brew install amux        # or clone github.com/xiaoxiunique/amux
amux serve               # serves http://0.0.0.0:8787
```

The macOS host app bundles `amux` automatically (built with `--features full`),
so this step is only needed when running the client against a service you start
by hand.

**2. Run the Flutter client** (connects to the service):

```bash
flutter pub get
flutter run -d macos    # or: ios | chrome | android | windows | linux
```

On first launch, onboarding asks for the service URL (+ optional token).

## Platform status

| Platform | Status |
|---|---|
| macOS | Full (host service + menu bar + control center) |
| iOS | Full (incl. APNs push, iOS 17+) |
| Android | Builds (cleartext HTTP allowed for local/trusted nets) |
| Web | Builds |
| Linux / Windows | Builds (remote-client only — tmux host is Unix-only) |

## Architecture

```
amux serve (sibling repo)   Rust service (Axum + portable-pty + tmux): the HTTP/WS API
lib/                   Flutter client (consumes that API)
├── core/            router, theme
├── data/
│   ├── api/         AgentMonitorApi (dio, 11 endpoints)
│   └── models/      freezed models (snapshot, pane, interaction, …)
├── services/        snapshotProvider (WS), terminal session, host service, push, settings
└── features/        monitor, pane_detail (terminal/actions/status), settings, onboarding, control_center
```

The Flutter client consumes the Rust service's HTTP/WebSocket API.

## License

MIT

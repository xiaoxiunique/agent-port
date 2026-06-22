# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Agent Port is a **local-first monitor and control surface for agent sessions** (Claude Code, Codex, …) running in **tmux** on a Mac. It's two halves in one repo:

- **`AgentMonitorService/`** — Rust service (Axum + portable-pty + tmux). Runs on **each monitored Mac**, polls tmux, serves the HTTP/WebSocket API.
- **`lib/`** — Flutter client (one Dart codebase → iOS / Android / macOS / Linux / Windows / Web). Runs on **any device**, connects to the service over HTTP/WS.

The client is a pure consumer of the Rust API — there is no shared code or codegen between the two halves. tmux is Unix-only, so Linux/Windows clients are remote-only (can't host the service).

`docs/PROJECT_STATUS.md` (in Chinese) is the living source of truth for feature parity, known issues, and roadmap — **read it before starting non-trivial work**. The reference implementation being ported is the native Swift app in the separate `agent-monitor` repo.

## Commands

### Rust service
```bash
cargo run --manifest-path AgentMonitorService/Cargo.toml   # serves http://0.0.0.0:8787
cargo build --manifest-path AgentMonitorService/Cargo.toml
cargo clippy --manifest-path AgentMonitorService/Cargo.toml
```

### Flutter client
```bash
flutter pub get
flutter run -d macos          # or: ios | chrome | android | windows | linux
flutter analyze               # lint (flutter_lints, see analysis_options.yaml)
flutter test                  # all tests
flutter test test/features/monitor/monitor_page_test.dart   # single test file
```

### Codegen (required after editing any model)
Models use **freezed + json_serializable**; the `.freezed.dart` / `.g.dart` files are generated and committed.
```bash
dart run build_runner build --delete-conflicting-outputs   # one-shot
dart run build_runner watch  --delete-conflicting-outputs   # during model work
```

### macOS run caveat
`flutter run` exits without a real tty. Run the macOS app from a **real terminal**, not from inside a Claude Code session.

## Architecture

### Rust service (`AgentMonitorService/src/main.rs`, single ~3900-line file)
Axum router (routes defined in `main()` around line 348). Endpoints:
- `GET  /api/snapshot` — current tmux pane list + status
- `GET  /api/pane/context` — pane tail/scrollback
- `POST /api/send`, `/api/key` — send text / control keys to a pane
- `POST /api/refine-text` — DeepSeek text polish
- `POST /api/upload-image` — raw image bytes
- `POST /api/session/kill`
- `GET  /api/project-history` + `POST /api/project-history/launch` — launch Claude/Codex on a past project
- `GET  /api/cc-switch` + `POST /api/cc-switch/switch` — provider switching
- `GET  /ws` — snapshot push stream
- `GET  /pane-log/ws` — per-pane log stream (burst-refresh on activity)
- `GET  /terminal/ws` — bidirectional PTY bridge (data → client, input/resize → PTY)

The **PTY lives entirely on the server** (portable-pty); the client only renders. Global mutable state is a set of `LazyLock<Mutex<…>>` caches (pane activity, message cache, project history, etc.).

**Known server-side gotchas** (documented in PROJECT_STATUS, not yet fixed):
- `/api/pane/events` is **called by the client but not registered** → 404. Status tab is effectively dead until this route is added.
- `AGENT_MONITOR_PUBLIC_URLS` env var: if unset, sessions get long encoded names and `pane.id` is always empty. The macOS `HostService` injects it from `.env`; manual launches must set it.
- Claude Code (a TUI on tmux alternate screen) writes no scrollback, so `capture-pane` only sees the current ~26-line screen — full history lives in `~/.claude/projects/*.jsonl`, which the server does not read.

### Flutter client (`lib/`)
```
core/        router (go_router), theme (dark only)
data/
  api/       AgentMonitorApi — dio client, ~11 endpoints, token auto-injected
  models/    freezed models (snapshot, pane, interaction, cc_switch, …) + enums.dart
services/    Riverpod providers (see below)
features/    monitor (list) · pane_detail (terminal/actions/status + input_bar)
             · settings · onboarding · control_center (macOS)
```

**Riverpod provider graph** (the reconnection backbone):
- `settingsProvider` → app settings + server profiles (persisted via `shared_preferences`).
- `apiProvider` watches `settingsProvider`, rebuilds a fresh `AgentMonitorApi` whenever the active profile changes.
- `snapshotProvider` (`SnapshotNotifier`) watches `apiProvider`, so switching profiles tears down and reconnects the WS. It runs a **`/ws` socket with HTTP-polling fallback + periodic reconnect** state machine (see `snapshot_service.dart`).

Switching the active server profile cascades: settings → api → snapshot reconnect. Keep this chain intact when touching networking.

**macOS-only services** (all guarded by `Platform.isMacOS`):
- `HostService` — spawns/supervises the Rust subprocess (2s health check, 3s crash auto-restart), reads `.env`.
- `TrayService` — menu-bar tray (`tray_manager`); initialized in `app.dart` via `addPostFrameCallback` (engine must be ready before talking to AppKit). App uses `LSUIElement`.
- `EnvironmentService` — installs `cc`/`cx` wrappers into `~/.agent-monitor/bin` + `~/.zshrc` PATH.

**iOS PiP** is native Swift (logs → `CVPixelBuffer` frames → `AVPictureInPictureController`, iOS 17+).

## Project-specific conventions & traps

- **freezed 3.x**: every model class must be declared `abstract class` (2.x did not require this). Forgetting this is the most common codegen failure here.
- **Riverpod is pinned to 2.x**, not 3.x — 3.x has an analyzer version conflict with `json_serializable`. Don't upgrade it casually.
- **`shared_preferences`, not `flutter_secure_storage`** — the latter conflicts with build_runner AOT. Tokens are stored in plain prefs.
- **JSON casing across the boundary**: the Rust models use `#[serde(rename_all = "camelCase")]` on most structs, but a few enums are `snake_case`/`lowercase` (see `InteractionRole`, `PaneStatus`, etc.). Match the Dart `@JsonKey` / enum mapping to the Rust serde attribute, not to a guess.
- **Android cleartext HTTP** is allowed via `network_security_config.xml` (the service has no TLS; intended for LAN / Tailscale).
- **Dead code to be aware of**: `lib/features/pane_detail/actions_tab.dart` and `status_tab.dart` are leftovers from a three-tab design; the detail page is now single-page (`pane_detail_page.dart`). They are unreferenced — don't wire new work through them without checking PROJECT_STATUS first.

## Git

Per the user's global rules: **do not add `Co-Authored-By` or any AI-attribution lines** to commit messages.

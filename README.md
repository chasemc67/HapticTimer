# HapticTimer

HapticTimer is an Apple Watch and iPhone app designed to provide a haptic-based timer experience, primarily for meditation and mindfulness sessions. The app starts a stopwatch and delivers distinct haptic feedback at every 5-minute increment. Optionally, it can write session data to HealthKit for tracking meditation sessions.

## Features

- **Apple Watch First**: The primary experience is on Apple Watch, with iPhone support as a secondary target.
- **Haptic Feedback**: Receive different haptic cues at every 5-minute mark during a session.
- **HealthKit Integration**: (Planned) Log meditation sessions to HealthKit for tracking.
- **Simple UI**: Minimal, distraction-free interface.

## Development Workflow

- **Code in Cursor**: Most development and code editing is done in Cursor for rapid iteration and AI assistance.
- **Build & Run in Xcode**: Use Xcode for building, running, and deploying to simulators or devices.
- **Project Structure**:
  - `HapticTimer/`: iPhone app code
  - `HapticTimerWatch Watch App/`: Apple Watch app code
  - `HapticTimerTests/`, `HapticTimerUITests/`: iPhone tests
  - `HapticTimerWatch Watch AppTests/`, `HapticTimerWatch Watch AppUITests/`: Watch app tests

## Contributing

- Follow the [Cursor Rules](./CURSOR_RULES.md) for best practices when using AI assistance.
- Keep code modular and well-documented.
- Prefer Swift and SwiftUI for UI and logic.
- Test on both Apple Watch and iPhone when possible.
- Use Xcode for interface design, provisioning, and deployment.

## Getting Started

1. Clone the repository.
2. Open the project in Cursor for code editing.
3. Use Xcode to build and run the app on your device or simulator.

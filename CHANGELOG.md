# [0.0.1]

### Added
- Initial release of the Flutter Dev Analytics Dashboard.
- **Device Info**: Displays device model, OS version, and screen size using `device_info_plus` and `MediaQuery`.
- **Performance Metrics**: Tracks FPS (simulated and visually via `statsfl`), memory usage (`system_info2`), and CPU usage via platform channels.
- **Screen Logs**: Logs navigation, interactions, and errors, persisted to disk using `path_provider` and `flutter_logs`.
- **Error Tracking**: Captures uncaught exceptions with `FlutterError.onError`.
- **User Flow Visualization**: Bar chart of screen visits using `fl_chart` and detailed list.
- **Gesture Toggle**: Customizable gesture (finger count, tap count) to show/hide the dashboard.
- **Settings Screen**: Configure gesture triggers.
- State management with `provider`.
- Modular architecture with services for log storage and CPU monitoring.

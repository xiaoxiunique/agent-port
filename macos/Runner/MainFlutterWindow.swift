import Cocoa
import CoreGraphics
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    // Screen Recording permission bridge for the control-center features
    // (screenshots / window previews run via the embedded service).
    let permissions = FlutterMethodChannel(
      name: "agent_port/permissions",
      binaryMessenger: flutterViewController.engine.binaryMessenger)
    permissions.setMethodCallHandler { call, result in
      switch call.method {
      case "screenRecordingStatus":
        result(CGPreflightScreenCaptureAccess())
      case "requestScreenRecording":
        // Triggers the system prompt the first time and registers the app in
        // the Screen Recording list.
        result(CGRequestScreenCaptureAccess())
      case "openScreenRecordingSettings":
        if let url = URL(
          string:
            "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")
        {
          NSWorkspace.shared.open(url)
        }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    super.awakeFromNib()
  }
}

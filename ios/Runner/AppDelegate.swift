import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    DispatchQueue.main.async {
      if let controller = self.window?.rootViewController as? FlutterViewController {
        AgentPortPush.shared.register(with: controller)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    AgentPortPush.shared.didRegister(deviceToken: deviceToken)
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    NSLog("[push] failed to register: \(error.localizedDescription)")
  }
}

// MARK: - Push (APNs device-token registration)

/// Bridges iOS remote-notification registration to Dart over the
/// `agent_port/push` method channel.
///
/// Dart → native:
///   - `requestPermission` → ask for alert/sound/badge, then
///     `registerForRemoteNotifications`; returns the granted bool.
///   - `getToken` → returns the last APNs device token (hex) or null.
/// Native → Dart:
///   - `onToken` (hex string) when the device token arrives.
final class AgentPortPush: NSObject, UNUserNotificationCenterDelegate {
  static let shared = AgentPortPush()

  private var channel: FlutterMethodChannel?
  private var deviceTokenHex: String?
  private var pendingTapPaneId: String?

  func register(with controller: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: "agent_port/push",
      binaryMessenger: controller.binaryMessenger)
    self.channel = channel
    UNUserNotificationCenter.current().delegate = self
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else { result(nil); return }
      switch call.method {
      case "requestPermission":
        self.requestPermission(result)
      case "getToken":
        result(self.deviceTokenHex)
      case "getPendingTap":
        // Cold-start: the app was launched by tapping a notification before
        // Dart wired up its handler. Hand over (and consume) the target pane.
        result(self.pendingTapPaneId)
        self.pendingTapPaneId = nil
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func requestPermission(_ result: @escaping FlutterResult) {
    UNUserNotificationCenter.current()
      .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
        DispatchQueue.main.async {
          if granted {
            UIApplication.shared.registerForRemoteNotifications()
          }
          result(granted)
        }
      }
  }

  func didRegister(deviceToken: Data) {
    let hex = deviceToken.map { String(format: "%02x", $0) }.joined()
    deviceTokenHex = hex
    channel?.invokeMethod("onToken", arguments: hex)
  }

  // Foreground: the user is already in the app, so don't pop our own banner.
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([])
  }

  // The user tapped a notification → deep-link to that pane's detail page.
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    if let paneId = response.notification.request.content.userInfo["paneId"] as? String,
       !paneId.isEmpty {
      pendingTapPaneId = paneId
      channel?.invokeMethod("onTap", arguments: paneId)
    }
    completionHandler()
  }
}

import Flutter
import UIKit
import Firebase
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(_application: UIApplication,
                              didRegisterForRemoteNotificationsWithDeviceToken deviceToken:Data
    ){
        Messaging.messaging().apnsToken = deviceToken
        print("Token: \(deviceToken)")
        super.application(_application: application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
}

import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  //UITextField 초기화
  private var textField = UITextField()
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      //함수 추가
    makeSecureYourScreen()
    
    //MethodChannel생성
    let controller : FlutterViewController = self.window?.rootViewController as! FlutterViewController
    let securityChannel = FlutterMethodChannel(name: "secureShotChannel", binaryMessenger: controller.binaryMessenger)
    securityChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "secureIOS" {
                self.textField.isSecureTextEntry = true
            } else if call.method == "unSecureIOS" {
                self.textField.isSecureTextEntry = false
            }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  //UITextField View에 추가
  private func makeSecureYourScreen() {
      if ((self.window.rootViewController?.view.contains(self.textField)) != nil) {
          self.window.rootViewController?.view.addSubview(self.textField)
          self.textField.centerYAnchor.constraint(equalTo: self.window.rootViewController!.view.centerYAnchor).isActive = true
            textField.centerXAnchor.constraint(equalTo: self.window.rootViewController!.view.centerXAnchor).isActive = true
            self.window.layer.superlayer?.addSublayer(textField.layer)
            textField.layer.sublayers?.first?.addSublayer(self.window.layer)
        }
    }
}

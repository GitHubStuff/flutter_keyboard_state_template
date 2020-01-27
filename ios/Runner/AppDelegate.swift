import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    static let method = "getKeyboardState"
    static let channel = "com.icodeforyou.keyboarder/keyboard"
    
    static var isShowing:Bool = false
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name:
            UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let keyboardChannel = FlutterMethodChannel(name: AppDelegate.channel, binaryMessenger: controller.binaryMessenger)
        keyboardChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == AppDelegate.method) {
                let string:String = (AppDelegate.isShowing) ? "open" : "close"
                result(string)
                return
            }
            result(FlutterMethodNotImplemented);
        })
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        AppDelegate.isShowing = true
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        AppDelegate.isShowing = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
}

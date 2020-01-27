# flutter_keyboard_template

A Temple for getting keyboard state

## Getting Started

Keyboard Open/Closed state install cookbook

-- ANDROID
-
    
- Find "MainActivity.kt" within the android[project] path
    (example: myProject => android => app => src => main => kotlin => com.sample.myproject)
    
    in the same folder as "MainActivity.kt" add "Keyboarder.kt"
    (Keyboarder.kt extends the Activity and Context classes with methods that can report keyboard visibility)
    
- Edit "MainActivity.kt" to look like:

		class MainActivity: FlutterActivity() {
			private val CHANNEL = "com.icodeforyou.keyboarder/keyboard"
			private val METHOD = 'getKeyboardState'

			override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        		GeneratedPluginRegistrant.registerWith(flutterEngine)
        		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            			if (call.method == METHOD) {
                			val state: String = if (isKeyboardClosed()) "closed" else "open"
                			result.success(state)
            			} else {
                			result.notImplemented()
            			}
                 	}
           	}
        }
   
-- iOS
-

- iOS open iOS Module in XCode and edit AppDelegate.swift to look like:

		import UIKit
		import Flutter

		@UIApplicationMain
		@objc class AppDelegate: FlutterAppDelegate {
    
		  static let channel = "com.icodeforyou.keyboarder/keyboard"
          static let method = "getKeyboardState"

		  static var isShowing:Bool = false
    
		  override func application(_ application: UIApplication,
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


-- DART
-

- Copy 'keyboarder.dart' into the Project/lib or one of its children

- Any class that wants to get keyboard state should include it like:

    	import 'package:{path}/keyboarder.dart' as Keyboard;
    
    (the 'as Keyboard' will prevent name space collision with Widget's 'State')


- Example on usage:

		Keyboard.State state = await Keyboard.getKeyboardState();
   
   or
   
   	 	Keyboard.getKeyboardState().then((Keyboard.State state)) {
    		     ...do something with 'state'...
     	}
     
   NOTE: 'Keyboard' is from the 'as Keyboard' on the import statement, call it anything you like
   but not using 'as' will with conflict with 'State' in widgets.
   
    
-- In closing:
- Any changes to the 'channel' or 'method' names in the Keyboarder.dart, MainActivity.kt, or AppDelegate.swift must be consistent across all three(3) or calls will error out.

- Keyboard.State is 'open', 'closed', 'unknown' or 'error'
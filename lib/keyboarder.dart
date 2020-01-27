import 'package:flutter/services.dart';

const _channel = 'com.icodeforyou.keyboarder/keyboard';
const _method = 'getKeyboardState';

const _platform = const MethodChannel(_channel);

enum State { closed, error, open, unknown }

Future<State> getKeyboardState() async {
  State keyboardState;
  try {
    final String result = await _platform.invokeMethod(_method);
    switch (result) {
      case 'open':
        keyboardState = State.open;
        break;
      case 'closed':
        keyboardState = State.closed;
        break;
      default:
        keyboardState = State.unknown;
    }
  } on PlatformException catch (_) {
    keyboardState = State.error;
  } on MissingPluginException catch (_) {
    keyboardState = State.error;
  }
  return keyboardState;
}

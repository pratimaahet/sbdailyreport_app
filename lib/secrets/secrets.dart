import 'dart:io' show Platform;

class Secret {
  static const ANDROID_CLIENT_ID =
      "Your Andriod Client ID here";
  static const IOS_CLIENT_ID =
      "Your IOS Client ID Here ";
  static String getId() =>
      Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.IOS_CLIENT_ID;
}

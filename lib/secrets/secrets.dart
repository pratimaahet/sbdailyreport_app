import 'dart:io' show Platform;

class Secret {
  static const ANDROID_CLIENT_ID =
      "<319846761591-fhba245vbvjqmpee6hhlcu8jl904vp91.apps.googleusercontent.com>";
  static const IOS_CLIENT_ID =
      "<319846761591-i5ibe2jq3lug0bll2onmk0tn3ct2oos3.apps.googleusercontent.com>";
  static String getId() =>
      Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.IOS_CLIENT_ID;
}

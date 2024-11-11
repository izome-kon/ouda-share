import 'package:webview_flutter/webview_flutter.dart';

class WebViewModel {
  final String url;
  final List<String> callbackUrl;
  final String title;
  final JavaScriptMode javascriptMode;
  final bool gestureNavigationEnabled;
  final bool clearCookie;

  WebViewModel({
    required this.url,
    this.callbackUrl = const [],
    this.title = 'title',
    this.javascriptMode = JavaScriptMode.unrestricted,
    this.gestureNavigationEnabled = true,
    this.clearCookie = false,
  });
}

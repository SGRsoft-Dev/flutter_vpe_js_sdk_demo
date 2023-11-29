import 'dart:math';

import 'package:apptest/secure_shot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';



class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    Wakelock.enabled;
    return const _VideoView();
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView({super.key});

  @override
  State<_VideoView> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_VideoView> {
  late final PlatformWebViewControllerCreationParams params;
  static WebViewController controller = WebViewController();
  @override
  void initState() {
    super.initState();
    SecureShot.on();

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("vpeToApp", onMessageReceived: (JavaScriptMessage message){
            //전체 화면 제어 Webview => Flutter
            if(message.message == "fullscreenOn"){
              SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
            }else if (message.message == "fullscreenOff"){
              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            }

      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {},
          onPageStarted: (url) {},
          onPageFinished: (url) {
            String message = "flutterRun";
            controller.runJavaScript('appToWeb("$message")');
          },
          onWebResourceError: (error) {},
          onNavigationRequest: (request) {
            if (request.url.startsWith('url')) {
              return NavigationDecision.prevent;
            } else {
              return NavigationDecision.navigate;
            }
          },
        ),
      )
      //..loadFlutterAsset('assets/index.html');
      ..loadRequest(Uri.parse('https://mediaplus-demo.web.app/fl/player.html'));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }
  // 네이티브 액티비티 실행 함수
  Future<void> launchNativeActivity() async {
    try {
      // SecureShot.on();
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller,),
    );
  }
}

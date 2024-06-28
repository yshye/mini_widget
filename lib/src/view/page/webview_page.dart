import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../router/navigator_util.dart';
import '../base/mixin_state.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const WebViewPage({super.key, required this.title, required this.url});

  @override
  State<StatefulWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebViewPage> with StateMixin {
  late String _title;
  late String _url;

  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _url = widget.url;
    _initController();
  }

  void _initController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          // onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_url));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        var canGoBack = await controller.canGoForward();
        if (canGoBack) {
          controller.goBack();
          return;
        }
        pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Row(children: [
            const BackButton(),
            CloseButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]),
          title: Text(
            _title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                NavigatorUtil.launchInBrowser(_url);
              },
              tooltip: '浏览器打开',
              icon: Icon(
                MdiIcons.earth,
                color: Colors.lightBlue,
              ),
            )
          ],
        ),
        body: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}

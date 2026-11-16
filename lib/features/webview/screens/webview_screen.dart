
import 'dart:async';

import 'package:divineesoft_gym_pro_app/core/constants/security/url_policy.dart';
import 'package:divineesoft_gym_pro_app/core/constants/utils/external_url_launcher.dart';
import 'package:divineesoft_gym_pro_app/features/webview/presentation/cubit/webview_cubit.dart';
import 'package:divineesoft_gym_pro_app/features/webview/presentation/cubit/webview_state.dart';
import 'package:divineesoft_gym_pro_app/features/widgets/portal_error_view.dart';
import 'package:divineesoft_gym_pro_app/features/widgets/portal_loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../../../../app/app_theme.dart';
import '../../../../core/constants/app_config.dart';


class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() =>
      _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen>
    with WidgetsBindingObserver {
  late final WebViewController _controller;

  bool _webViewInitialized = false;
  bool _isPageLoading = true;

  Timer? _loadTimeout;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..setBackgroundColor(
        AppTheme.navy,
      )
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (!mounted) return;

            context.read<WebViewCubit>().onProgress(
                  progress,
                );
          },

          onPageStarted: (url) {
            if (!mounted) return;

            _loadTimeout?.cancel();

            _loadTimeout = Timer(
              AppConfig.pageLoadTimeout,
              () {
                if (mounted && _isPageLoading) {
                  context.read<WebViewCubit>()
                      .onPageError(
                    'The portal is taking too long to respond. Please try again.',
                  );
                }
              },
            );

            setState(() {
              _isPageLoading = true;
            });

            context.read<WebViewCubit>()
                .onPageStarted();
          },

          onPageFinished: (url) {
            if (!mounted) return;

            _loadTimeout?.cancel();

            setState(() {
              _isPageLoading = false;
            });

            context.read<WebViewCubit>()
                .onPageFinished();
          },

          onWebResourceError: (error) {
            if (!mounted ||
                error.isForMainFrame != true) {
              return;
            }

            _loadTimeout?.cancel();

            setState(() {
              _isPageLoading = false;
            });

            context.read<WebViewCubit>()
                .onPageError(
              'Unable to load GYM Pro. Please check your connection and try again.',
            );
          },

          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);

            if (uri == null) {
              return NavigationDecision.prevent;
            }

            final action = UrlPolicy.classify(uri);

            switch (action) {
              case UrlAction.internal:
                return NavigationDecision.navigate;

              case UrlAction.external:
                unawaited(
                  ExternalUrlLauncher.open(
                    context,
                    uri,
                  ),
                );

                return NavigationDecision.prevent;

              case UrlAction.block:
                return NavigationDecision.prevent;
            }
          },
        ),
      );

    _configureAndroidFilePicker();

    _webViewInitialized = true;

    _controller.loadRequest(
      Uri.parse(AppConfig.startUrl),
    );
  }

  Future<void> _configureAndroidFilePicker() async {
    final platformController = _controller.platform;

    if (platformController is AndroidWebViewController) {
      await platformController.setOnShowFileSelector(
        (params) async {
          try {
            final result =
                await FilePicker.platform.pickFiles(
              allowMultiple:
                  params.mode ==
                      FileSelectorMode.openMultiple,
              type: FileType.any,
              withData: false,
            );

            if (result == null) {
              return <String>[];
            }

            return result.files
                .where((file) => file.path != null)
                .map((file) => file.path!)
                .toList(growable: false);
          } catch (_) {
            return <String>[];
          }
        },
      );
    }
  }

  Future<void> _reload() async {
    final online = await context
        .read<WebViewCubit>()
        .checkConnection(updateState: false);

    if (!mounted) return;

    if (!online) {
      context.read<WebViewCubit>().onPageError(
        'The GYM Pro portal is currently unreachable.',
      );

      return;
    }

    context.read<WebViewCubit>().setRefreshing();

    setState(() {
      _isPageLoading = true;
    });

    await _controller.reload();
  }

  Future<void> _handleBack() async {
    if (_webViewInitialized) {
      final canGoBack = await _controller.canGoBack();

      if (canGoBack) {
        await _controller.goBack();
        return;
      }
    }

    if (!mounted) return;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Exit GYM Pro?'),
          content: const Text(
            'Do you want to close the application?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );

    if (shouldExit == true && mounted) {
      SystemNavigator.pop();
    }
  }

  Future<void> _retryConnection() async {
    final online = await context
        .read<WebViewCubit>()
        .checkConnection();

    if (!mounted) return;

    if (online) {
      await _controller.loadRequest(
        Uri.parse(AppConfig.startUrl),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<WebViewCubit>()
          .checkConnection(updateState: false);
    }
  }

  @override
  void dispose() {
    _loadTimeout?.cancel();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          unawaited(_handleBack());
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppTheme.navy,
          body: SafeArea(
            top: false,
            bottom: true,
            child: BlocBuilder<WebViewCubit, WebViewState>(
              builder: (context, state) {
                if (state.status == PortalStatus.offline) {
                  return PortalErrorView(
                    title: 'You are offline',
                    message:
                        'Connect to the internet to access your GYM Pro management portal.',
                    onRetry: _retryConnection,
                  );
                }
        
                if (state.status == PortalStatus.failed) {
                  return PortalErrorView(
                    title: 'Unable to load GYM Pro',
                    message: state.errorMessage ??
                        'Something went wrong while opening the portal.',
                    icon: Icons.wifi_off_rounded,
                    onRetry: _reload,
                  );
                }
        
                return Stack(
                  children: [
                    WebViewWidget(
                      controller: _controller,
                    ),
        
                    if (_isPageLoading)
                      Positioned.fill(
                        child: PortalLoading(
                          progress: state.progress,
                        ),
                      ),
        
                    if (state.status == PortalStatus.ready)
                      Positioned(
                        top: MediaQuery.paddingOf(context).top + 8,
                        right: 12,
                        child: Material(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius:
                              BorderRadius.circular(24),
                          child: InkWell(
                            borderRadius:
                                BorderRadius.circular(24),
                            onTap: _reload,
                            child: const Padding(
                              padding: EdgeInsets.all(9),
                              child: Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                                size: 19,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

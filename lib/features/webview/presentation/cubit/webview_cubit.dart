
import 'dart:async';

import 'package:divineesoft_gym_pro_app/core/constants/networks/connectivity_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../core/constants/app_config.dart';
import 'webview_state.dart';

class WebViewCubit extends Cubit<WebViewState> {
  WebViewCubit({
    required ConnectivityService connectivityService,
  })  : _connectivityService = connectivityService,
        super(const WebViewState());

  final ConnectivityService _connectivityService;

  StreamSubscription<List<ConnectivityResult>>?
      _subscription;

  bool _checking = false;

  Future<bool> checkConnection({
    bool updateState = true,
  }) async {
    if (_checking) {
      return state.status != PortalStatus.offline;
    }

    _checking = true;

    try {
      final connected =
          await _connectivityService.hasInternet(
        Uri.parse(AppConfig.startUrl),
        AppConfig.connectivityTimeout,
      );

      if (updateState && !isClosed) {
        emit(
          state.copyWith(
            status: connected
                ? PortalStatus.loading
                : PortalStatus.offline,
            clearError: true,
          ),
        );
      }

      return connected;
    } finally {
      _checking = false;
    }
  }

 

  void onPageStarted() {
    if (isClosed) return;

    emit(
      state.copyWith(
        status: PortalStatus.loading,
        progress: 0,
        clearError: true,
        isRefreshing: false,
      ),
    );
  }

  void onProgress(int progress) {
    if (isClosed) return;

    emit(
      state.copyWith(
        progress: progress.clamp(0, 100),
      ),
    );
  }

  void onPageFinished() {
    if (isClosed) return;

    emit(
      state.copyWith(
        status: PortalStatus.ready,
        progress: 100,
        clearError: true,
        isRefreshing: false,
      ),
    );
  }

  void onPageError(String message) {
    if (isClosed) return;

    emit(
      state.copyWith(
        status: PortalStatus.failed,
        errorMessage: message,
        isRefreshing: false,
      ),
    );
  }

  void setRefreshing() {
    if (isClosed) return;

    emit(
      state.copyWith(
        status: PortalStatus.loading,
        isRefreshing: true,
      ),
    );
  }

  Future<void> retry() async {
    final online = await checkConnection();

    if (!online && !isClosed) {
      emit(
        state.copyWith(
          status: PortalStatus.offline,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

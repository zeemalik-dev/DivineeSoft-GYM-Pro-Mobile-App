
import 'package:equatable/equatable.dart';

enum PortalStatus {
  checkingConnection,
  loading,
  ready,
  offline,
  failed,
}

class WebViewState extends Equatable {
  const WebViewState({
    this.status = PortalStatus.checkingConnection,
    this.progress = 0,
    this.errorMessage,
    this.isRefreshing = false,
  });

  final PortalStatus status;
  final int progress;
  final String? errorMessage;
  final bool isRefreshing;

  WebViewState copyWith({
    PortalStatus? status,
    int? progress,
    String? errorMessage,
    bool clearError = false,
    bool? isRefreshing,
  }) {
    return WebViewState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
      isRefreshing:
          isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
        status,
        progress,
        errorMessage,
        isRefreshing,
      ];
}

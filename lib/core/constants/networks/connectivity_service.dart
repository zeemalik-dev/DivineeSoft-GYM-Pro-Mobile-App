
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<List<ConnectivityResult>>
      get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  Future<bool> hasNetworkInterface() async {
    final results =
        await _connectivity.checkConnectivity();

    return results.any(
      (result) =>
          result != ConnectivityResult.none,
    );
  }

  Future<bool> canReachGymPortal(
    Uri uri,
    Duration timeout,
  ) async {
    HttpClient? client;

    try {
      client = HttpClient()
        ..connectionTimeout = timeout;

      final request = await client
          .headUrl(uri)
          .timeout(timeout);

      request.followRedirects = true;

      final response = await request
          .close()
          .timeout(timeout);

      await response.drain<void>();

      return response.statusCode >= 200 &&
          response.statusCode < 500;
    } catch (_) {
      return false;
    } finally {
      client?.close(force: true);
    }
  }

  Future<bool> hasInternet(
    Uri probeUri,
    Duration timeout,
  ) async {
    final hasNetwork =
        await hasNetworkInterface();

    if (!hasNetwork) return false;

    return canReachGymPortal(
      probeUri,
      timeout,
    );
  }
}

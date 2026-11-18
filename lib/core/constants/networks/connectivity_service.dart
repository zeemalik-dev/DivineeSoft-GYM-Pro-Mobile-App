


class ConnectivityService {
  Future<bool> hasNetworkInterface() async {
    return true;
  }

  Future<bool> canReachGymPortal(
    Uri uri,
    Duration timeout,
  ) async {
    return true;
  }

  Future<bool> hasInternet(
    Uri probeUri,
    Duration timeout,
  ) async {
    return true;
  }
}

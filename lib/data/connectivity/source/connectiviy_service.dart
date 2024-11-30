import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

abstract class ConnectivityService {
  Future<Either> checkConnectivity();
}

class ConnectivityServiceImpl implements ConnectivityService {
  @override
  Future<Either> checkConnectivity() async {
    try {
      // Returns the current connectivity status
      List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        return const Right('Connected to the internet.');
      } else {
        return const Left('Not connected to the internet.');
      }
    } catch (e) {
      // If an error occurs, we return no connection as the default state
      return const Left('An unknown connectivity issue has occured.');
    }
  }
}

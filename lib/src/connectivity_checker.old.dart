import 'dart:async';
import 'package:flutter/foundation.dart';

/// The connection checker class
class ConnectivityChecker {
  /// The duration to recheck connectivity
  final Duration interval;

  /// A list of hosts to check every [interval]
  final List<String> domains;

  ConnectivityChecker(
      {this.domains = const ['google.com', 'pub.dev'],
      this.interval = const Duration(seconds: 1)});

  static Stream<bool> checkConnectivity({Duration? interval}) async* {
    var connectivity = ConnectivityChecker();

    Timer.periodic(interval ?? connectivity.interval, (timer) => lookupHosts());
  }
}

void lookupHosts() {
  debugPrint('A ping to host...');
}

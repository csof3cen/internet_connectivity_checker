import 'package:flutter/material.dart';
import 'package:internet_connectivity_checker/src/connectivity_checker.dart';
import 'package:internet_connectivity_checker/src/connectivity_status.dart';

connectivityBuilder(Widget Function(ConnectivityStatus status) builder,
    {Duration? interval}) {
  return StreamBuilder(
    stream: ConnectivityChecker(interval: interval).stream,
    builder: (context, snapshot) {
      if (snapshot.hasData && (snapshot.data as bool) == true) {
        return builder(ConnectivityStatus.online);
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return builder(ConnectivityStatus.checking);
      } else {
        return builder(ConnectivityStatus.offline);
      }
    },
  );
}

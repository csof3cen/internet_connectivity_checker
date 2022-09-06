library internet_connectivity_checker;

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

enum ConnectivityStatus { online, offine, checking }

int defaultInterval = 5000;

/// An InternetConnectivity
class InternetConnectivity {
  /// Create a new [InternetConnectivity] object.
  InternetConnectivity({
    this.interval,
    this.domainsToCheck = const [
      'google.com',
      'exemple.com',
      'github.com',
      'pub.dev',
    ],
  });

  /// A list of custom domains to check
  final List<String> domainsToCheck;

  /// The interval in milliseconds to re-check internet connectivity, default to 5000ms (5 seconds)
  final int? interval;

  /// A stream of bool that lookup [domainsToCheck] every [interval]
  Stream<bool> isConnectedToInternet({int? intervalInMilliseconds}) {
    StreamController<bool> controller = StreamController();

    checkInternet() async {
      intervalInMilliseconds = interval ?? defaultInterval;
      Timer.periodic(Duration(milliseconds: intervalInMilliseconds!),
          (timer) async {
        int success = 0;
        for (String domain in domainsToCheck) {
          try {
            final result = await InternetAddress.lookup(domain);
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              success++;
            }
          } on SocketException catch (_) {
            success--;
          }
        }
        // If at least the half of domains check succeeded, we pretend internet is on
        if (success >= (domainsToCheck.length / 2).round()) {
          controller.add(true);
        } else {
          // Otherwise, device is offline
          controller.add(false);
        }
      });
    }

    controller = StreamController<bool>(onListen: checkInternet);

    return controller.stream;
  }
}

internetConnectivityBuilder(
  Widget Function(ConnectivityStatus status, int interval) builder,
) {
  Stream stream = InternetConnectivity().isConnectedToInternet();
  return StreamBuilder(
    stream: stream,
    builder: (context, snapshot) {
      if (snapshot.hasData && (snapshot.data as bool) == true) {
        return builder(ConnectivityStatus.online, defaultInterval);
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return builder(ConnectivityStatus.checking, defaultInterval);
      } else {
        return builder(ConnectivityStatus.offine, defaultInterval);
      }
    },
  );
}

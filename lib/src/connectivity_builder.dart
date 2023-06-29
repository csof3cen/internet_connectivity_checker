import 'package:flutter/material.dart';
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';

/// Connectivity builder widget
class ConnectivityBuilder extends StatefulWidget {
  /// A builder that enables you to easily handle connectivity state
  const ConnectivityBuilder({
    this.interval,
    required this.builder,
    Key? key,
  }) : super(key: key);

  /// The duration interval to recheck connectivity state
  final Duration? interval;

  /// Connectivity builder function
  final Widget Function(ConnectivityStatus status) builder;

  @override
  State<ConnectivityBuilder> createState() => _ConnectivityBuilderState();
}

class _ConnectivityBuilderState extends State<ConnectivityBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ConnectivityChecker(
        interval: widget.interval ?? const Duration(seconds: 5),
      ).stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && (snapshot.data as bool) == true) {
          // debugPrint('Working');
          return widget.builder(ConnectivityStatus.online);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.builder(ConnectivityStatus.checking);
        } else {
          // debugPrint('Failed');
          return widget.builder(ConnectivityStatus.offline);
        }
      },
    );
  }
}

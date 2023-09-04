import 'dart:io';
import 'dart:async';

bool _isDurationALongerThanB(Duration a, Duration b) {
  if (DateTime.now().add(a).isAfter(DateTime.now().add(b))) {
    return true;
  } else {
    return false;
  }
}

/// Connectivity checker class
class ConnectivityChecker {
  /// A list of hosts to lookup every [interval]
  final List<String> _urlsToCheck = const [
    'https://google.com',
    'https://github.com'
  ];

  /// The time to wait between each internet connectivity verification
  /// The default [interval] is set to 5 seconds
  final Duration? interval;

  final StreamController<bool> _streamController = StreamController<bool>();

  /// Connectivity stream
  Stream<bool> get stream =>
      _streamController.stream.asBroadcastStream().timeout(
          interval != null
              ? Duration(
                  seconds: _isDurationALongerThanB(
                  interval!,
                  const Duration(seconds: 2),
                )
                      ? (interval!.inSeconds + 2)
                      : 2)
              : const Duration(seconds: 5), onTimeout: (eventSink) {
        eventSink.add(false);
      });

  /// Initialize an connectivity checker object
  ConnectivityChecker({
    this.interval,
  }) {
    if (interval != null) {
      if (DateTime.now()
          .add(const Duration(seconds: 5))
          .isAfter(DateTime.now().add(interval!))) {
        throw Exception(
            '''interval cannot be smaller than 5 seconds because of lookups time.
            ${interval!.inMilliseconds}ms given.''');
      }
    }

    _checkUrls();
    // TODO: Handle duration taken by host lookups
    Timer.periodic(interval ?? const Duration(seconds: 5), (_) => _checkUrls());
  }

  void _checkUrls() async {
    int successfulLookupsNum = 0;
    int failedLookupsNum = 0;

    for (final url in _urlsToCheck) {
      try {
        final request = await HttpClient().headUrl(Uri.parse(url));
        final response = await request.close();

        if (response.connectionInfo != null) {
          // print('Success');
          successfulLookupsNum++;
        } else {
          // print('Failed. ${response.statusCode}');
          failedLookupsNum++;
        }
      } catch (e) {
        failedLookupsNum++;
        // print('Failed. Error : $e');
      }
    }

    _streamController.sink.add(
      successfulLookupsNum >= failedLookupsNum ? true : false,
    );
    // print(successfulLookupsNum >= failedLookupsNum ? 'Success' : 'Failed');
  }

  /// Dispose the streamController to free up resources
  void dispose() {
    _streamController.close();
  }
}

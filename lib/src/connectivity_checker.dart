import 'dart:io';
import 'dart:async';

class ConnectivityChecker {
  /// A list of hosts to lookup every [interval]
  final List<String> _urlsToCheck = const [
    'https://google.com',
    'https://example.com'
  ];

  // The time to wait between each internet connectivity verification
  final Duration interval;

  final StreamController<bool> _streamController = StreamController<bool>();

  Stream<bool> get stream => _streamController.stream.asBroadcastStream();

  ConnectivityChecker({
    this.interval = const Duration(seconds: 5),
  }) {
    Timer.periodic(interval, (_) => _checkUrls());
  }

  void _checkUrls() async {
    int successfulLookupsNum = 0;
    int failedLookupsNum = 0;

    for (var url in _urlsToCheck) {
      try {
        final request = await HttpClient().headUrl(Uri.parse(url));
        final response = await request.close();

        if (response.statusCode == 200) {
          // print('Success');
          successfulLookupsNum++;
        } else {
          // print('Failed.');
          failedLookupsNum++;
        }
      } catch (e) {
        failedLookupsNum++;
        // print('Failed. Error : $e');
      }
    }

    _streamController.sink
        .add(successfulLookupsNum >= failedLookupsNum ? true : false);
  }

  void dispose() {
    _streamController.close();
  }
}

import 'dart:io';
import 'dart:async';

class UrlLookupService {
  final List<String> urls;
  final Duration interval;
  final StreamController<bool> _streamController = StreamController<bool>();

  Stream<bool> get stream => _streamController.stream;

  UrlLookupService(this.urls, {this.interval = const Duration(seconds: 2)}) {
    Timer.periodic(interval, (_) => _checkUrls());
  }

  void _checkUrls() async {
    for (var url in urls) {
      try {
        final request = await HttpClient().headUrl(Uri.parse(url));
        final response = await request.close();

        if (response.statusCode == 200) {
          _streamController.sink.add(true);
        } else {
          _streamController.sink.add(false);
        }
      } catch (e) {
        _streamController.sink.add(false);
      }
    }
  }

  void dispose() {
    _streamController.close();
  }
}

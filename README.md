# internet_connectivity_checker

The [connectivity](https://pub.dev/packages/connectivity) package and other similar packages only provides information if there is a network connection, but not if the network is connected to the Internet. That's why the [internet_connectivity_checker](https://github.com/HamadaHiro/internet_connectivity_checker) package helps you easily manage dynamic widgets based on the device's internet access.

## Features



## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
class ConnectivityStateBased extends StatelessWidget {
  const ConnectivityStateBased({
    required this.onConnectedChild,
    required this.onOfflineChild,
    Key? key,
  }) : super(key: key);

  final Widget onConnectedChild;
  final Widget onOfflineChild;

  @override
  Widget build(BuildContext context) {
    Stream stream = isConnectedToInternet(interval: 1);
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool internet = snapshot.data as bool;
          return internet ? onConnectedChild : onOfflineChild;
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: circularProgressIndicatorSize / 2,
              width: circularProgressIndicatorSize / 2,
              child: const CircularProgressIndicator(),
            ),
          );
        } else {
          return const Center(
            child: Icon(FeatherIcons.alertTriangle),
          );
        }
      },
    );
  }
}
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

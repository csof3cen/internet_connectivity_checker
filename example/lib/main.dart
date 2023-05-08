import 'package:flutter/material.dart';
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle kTextStyle = Theme.of(context)
        .textTheme
        .headlineMedium!
        .copyWith(color: Colors.white);
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        backgroundColor: const Color(0XFF000F1D),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Internet Connectivity Checker"),
        ),
        body: Center(
          child: Container(
            width: 300,
            height: 300,
            margin: const EdgeInsets.all(20),
            child: ConnectivityBuilder(
              interval: const Duration(seconds: 5),
              builder: (ConnectivityStatus status) {
                if (status == ConnectivityStatus.online) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(child: Text("Online", style: kTextStyle)),
                  );
                } else if (status == ConnectivityStatus.offline) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(child: Text("Offline", style: kTextStyle)),
                  );
                } else {
                  // status == ConnectivityStatus.checking
                  return const Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

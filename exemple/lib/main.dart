import 'package:flutter/material.dart';
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Internet Connectivity Checker"),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            height: double.maxFinite,
            width: double.maxFinite,
            child: internetConnectivityBuilder((status, interval) {
              if (status == ConnectivityStatus.online) {
                return Container(
                  color: Colors.green,
                  child: const Center(child: Text("Connecté")),
                );
              } else if (status == ConnectivityStatus.offine) {
                return Container(
                  color: Colors.red,
                  child: const Center(child: Text("Déconnecté")),
                );
              } else {
                return const Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}

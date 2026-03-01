import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityBanner extends StatefulWidget {
  const ConnectivityBanner({super.key});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  StreamSubscription<List<ConnectivityResult>>?  _sub;
  bool _offline = false;

  @override
  void initState(){
    super.initState();
    _start();
  }

  Future<void> _start () async {
    final initial = await Connectivity().checkConnectivity();
    _offline = initial.contains(ConnectivityResult.none); //make _offline true if contains none
    if(mounted) { setState(() {});}

    _sub = Connectivity().onConnectivityChanged.listen((result) {
      final nextOffline = result.contains(ConnectivityResult.none);
      if(nextOffline == _offline) return;
      _offline = nextOffline;
      if(mounted) { setState(() {});
      }
    });
  }

  @override
  void dispose(){
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_offline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: Theme.of(context).colorScheme.error,
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Offline",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 5),
            Icon(Icons.wifi_off, color: Theme.of(context).colorScheme.onError),
          ],
        ),
      ),
    );
  }
}

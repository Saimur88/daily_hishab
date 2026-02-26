import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
class ConnectivityBanner extends StatefulWidget {
  const ConnectivityBanner({super.key});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _sub;

  bool _isoffline = false;

  @override
  void initState(){
    super.initState();
    _initConnectivity();

    Future<void> _initConnectivity() async {
      final initialResults = await _connectivity.checkConnectivity();
      _setofflineFromResults(initialResults);
      _sub = _connectivity.onConnectivityChanged.listen(_setofflineFromResults);
    }
    void _setofflineFromResults(List<ConnectivityResult> result){
      final nextoffline = result.isEmpty
    }


  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.primary;
    return StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot){

        });
  }
}

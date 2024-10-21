import 'dart:async';

import 'package:flutter/material.dart';

import 'data_service.dart';

class MapKitView extends StatefulWidget {
  const MapKitView({super.key});

  @override
  State<MapKitView> createState() => _MapKitViewState();
}

class _MapKitViewState extends State<MapKitView> {
  late Stream<Map<String, dynamic>> _locationStream;
  // DataService _dataService = DataService();

  StreamSubscription? _locationSubscription;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _startListeningToLocation();
  }

  void _startListeningToLocation() {
    _locationSubscription = DataService.locationChannel
        .receiveBroadcastStream("location")
        .listen((data) {
      setState(() {
        latitude = data['latitude'];
        longitude = data['longitude'];
      });
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(child: UiKitView(viewType: 'MapKitView'));
  }
}

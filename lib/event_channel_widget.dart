import 'package:flutter/material.dart';

import 'data_service.dart';

class EventChannelWidget extends StatefulWidget {
  final double currentDirection;
  const EventChannelWidget({super.key, required this.currentDirection});

  @override
  State<EventChannelWidget> createState() => _EventChannelWidgetState();
}

class _EventChannelWidgetState extends State<EventChannelWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('EventChannel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  )),
              StreamBuilder(
                stream: DataService.locationChannel
                    .receiveBroadcastStream("location"),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  debugPrint(
                      "Stream Connection State: ${snapshot.connectionState}");

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text(
                        "Error receiving location stream: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    final data = Map<String, dynamic>.from(snapshot.data);

                    final latitude = data['latitude'];
                    final longitude = data['longitude'];
                    final formattedLatitude = latitude.toStringAsFixed(9);
                    final formattedLongitude = longitude.toStringAsFixed(9);
                    final course = data['course'];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('위도: $formattedLatitude'),
                        const SizedBox(height: 10),
                        Text('경도: $formattedLongitude'),
                        const SizedBox(height: 20),
                        Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            width: double.infinity,
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                      begin: 0, end: widget.currentDirection),
                                  duration: const Duration(milliseconds: 500),
                                  builder: (context, angle, child) {
                                    return Transform.rotate(
                                      angle: (course ?? 0) * (3.14159 / 180),
                                      child: const Icon(
                                        Icons.navigation,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    );
                                  }),
                            )),
                      ],
                    );
                  } else {
                    return const Text("No location Data");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

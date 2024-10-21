import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_channel_practices/basic_message_channel_widget.dart';
import 'package:platform_channel_practices/binary_messenger_widget.dart';
import 'package:platform_channel_practices/event_channel_widget.dart';
import 'package:platform_channel_practices/method_channel_widget.dart';

import 'data_service.dart';
import 'map_kit_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platform Channel Practices',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PlatformChannel(),
    );
  }
}

class PlatformChannel extends StatefulWidget {
  const PlatformChannel({super.key});

  @override
  State<PlatformChannel> createState() => _PlatformChannelState();
}

class _PlatformChannelState extends State<PlatformChannel> {
  StreamSubscription? _locationSubscription;
  // final DataService dataService = DataService();
  late DataService dataService;
  final TextEditingController basicChannelTextController =
      TextEditingController();
  final TextEditingController binaryTextController = TextEditingController();

  String _batteryLevel = 'Battery Level';
  String _basicChannelText = '텍스트 길이가 반환됩니다';
  String _binaryMessengerText = '텍스트 길이가 반환됩니다';

  Map _deviceData = {};
  double _currentDirection = 0.0;

  Future<void> fetchData() async {
    try {
      final data = await dataService.getBatteryData();
      final deviceData = await dataService.getDeviceData();

      setState(() {
        _batteryLevel =
            data != null ? data.toString() : "Battery data unavailable";
        _deviceData = deviceData ?? {};
      });
    } on PlatformException catch (error) {
      print(error);
    } catch (error) {
      print(error);
    }
  }

  void sendBasicChannelMessage() async {
    final result =
        await dataService.sendMessage(basicChannelTextController.text);

    setState(() {
      _basicChannelText = result ?? "No response received";
    });
  }

  void sendBinaryMessage() async {
    final result = await dataService.sendBinaryData(binaryTextController.text);

    setState(() {
      _binaryMessengerText = result ?? "No response received";
    });
  }

  Widget renderData(data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.indigoAccent.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('MethodChannel',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              SizedBox(width: 30),
              Expanded(
                child: IconButton(
                  iconSize: 20,
                  onPressed: fetchData,
                  icon: Icon(Icons.ads_click),
                ),
              )
            ],
          ),
          Text('모델명: ${data["model"]}' ?? ''),
          Text('플랫폼: ${data["systemName"]}' ?? ''),
          Text('버전: ios ${data["systemVersion"]}' ?? ''),
          Text('사용 용량: ${data['totalDiskSpaceGB']} GB' ?? ''),
          Text('남은 용량: ${data['freeDiskSpaceGB']} GB' ?? ''),
        ],
      ),
    );
  }

  Future<void> _subscribeToLocationStream() async {
    dataService = await DataService();

    _locationSubscription = DataService.locationChannel
        .receiveBroadcastStream("location")
        .listen((data) {
      final locationData = Map<String, dynamic>.from(data);
      setState(() {
        _currentDirection = locationData["course"] ?? 0.0;
      });
    }, onError: (error) {
      print('Error receiving location stream: $error');
    });
  }

//todo: 위젯간 빌드가 동기화되는 문제.
  @override
  void initState() {
    super.initState();

    _subscribeToLocationStream();

    // DataService.locationChannel.receiveBroadcastStream("location").listen(
    //     (data) {
    //   final locationData = Map<String, dynamic>.from(data);
    //
    //   setState(() {
    //     _currentDirection = locationData["course"] ?? 0.0;
    //   });
    // }, onError: (error) {
    //   print('Error receiving location stream: $error');
    // });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlatformChannel Examples'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  BinaryMessengerWidget(
                    controller: binaryTextController,
                    resultText: _binaryMessengerText,
                    onPressed: sendBinaryMessage,
                  ),
                  const SizedBox(width: 10),
                  BasicMessageChannelWidget(
                    onPressed: sendBasicChannelMessage,
                    controller: basicChannelTextController,
                    result: _basicChannelText,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: renderData(_deviceData),
                  ),
                  const SizedBox(width: 10),
                  MethodChannelWidget(
                    result: _batteryLevel,
                    onPressed: fetchData,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  EventChannelWidget(currentDirection: _currentDirection),
                  const SizedBox(width: 10),
                  Expanded(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const MapKitView(),
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

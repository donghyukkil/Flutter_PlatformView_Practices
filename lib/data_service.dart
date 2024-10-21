import 'dart:typed_data';

import 'package:flutter/services.dart';

class DataService {
  // static const platformChannel = MethodChannel('samples.flutter.dev/device');
  static const locationChannel = EventChannel('samples.flutter.dev/location');
  // static const BasicMessageChannel<String> basicChatChannel =
  //     BasicMessageChannel('samples.flutter.dev/chat', StringCodec());
  static const String channelName = 'samples.flutter.dev/binary';

  // final BinaryMessenger binaryMessenger =
  //     ServicesBinding.instance.defaultBinaryMessenger;

  Future<dynamic> getBatteryData() async {
    try {
      final data = await platformChannel.invokeMethod('getBatteryData');
      return data;
    } on PlatformException catch (error) {
      print(error);
      return 'Battery data unavailable';
    }
  }

  static const platformChannel = MethodChannel('samples.flutter.dev/device');

  Future<Map<String, dynamic>?> getDeviceData() async {
    try {
      final deviceData = await platformChannel.invokeMethod('getDeviceInfo');
      return Map<String, dynamic>.from(deviceData as Map);
    } on PlatformException catch (error) {
      print(error);
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  static const BasicMessageChannel<String> basicChatChannel =
      BasicMessageChannel('samples.flutter.dev/chat', StringCodec());

  Future<String?> sendMessage(String text) async {
    try {
      final result = await basicChatChannel.send(text);
      return result;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  final BinaryMessenger binaryMessenger =
      ServicesBinding.instance.defaultBinaryMessenger;

  Future<String?> sendBinaryData(String text) async {
    //  텍스트를 바이너리 형식으로 저장
    final ByteData data = ByteData((text.length * 2));

    for (var i = 0; i < text.length; i++) {
      // 인덱스가 유효한지 확인
      if (i * 2 < data.lengthInBytes) {
        // 문자의 유니코드 값을 2바이트로 변환하여 바이너리 데이터에 설정 (빅 엔디안 방식)
        data.setInt16(i * 2, text.codeUnitAt(i), Endian.big);
      }
    }

    final ByteData? response = await binaryMessenger.send(channelName, data);

    // Native가 문자열 길이르 반환. 정수형 데이터(Int, 4 바이트)
    if (response != null && response.lengthInBytes >= 4) {
      // 문자열 길이
      final int length = response.getInt32(0);
      return "Received length: $length";
    } else {
      return "No response or incomplete data received";
    }
  }
}

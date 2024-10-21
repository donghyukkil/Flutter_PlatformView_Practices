//
//  EventChannels.swift
//  Runner
//
//  Created by donghyukkil on 10/21/24.
//

import Flutter

class EventChannels {
    static func register(controller: FlutterViewController) {
        let locationChannel = FlutterEventChannel(name: "samples.flutter.dev/location", binaryMessenger: controller.binaryMessenger)
        locationChannel.setStreamHandler(LocationManager.shared)
    }
}

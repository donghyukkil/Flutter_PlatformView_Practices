//
//  MethodChannels.swift
//  Runner
//
//  Created by donghyukkil on 10/21/24.
//

import Flutter
import UIKit

class MethodChannels {
    static func register(controller: FlutterViewController) {
        let platformChannel = FlutterMethodChannel(name: "samples.flutter.dev/device", binaryMessenger: controller.binaryMessenger )
        
        platformChannel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
            switch call.method {
            case "getBatteryData":
                          DeviceInfoHelper.receiveBatteryLevel(result: result)
                      case "getDeviceInfo":
                          DeviceInfoHelper.receiveDeviceInfo(result: result)
                      default:
                          result(FlutterMethodNotImplemented)
                      }
            }
            
        }
}


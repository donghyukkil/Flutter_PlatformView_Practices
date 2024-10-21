//
//  DeviceInfoHelper.swift
//  Runner
//
//  Created by donghyukkil on 10/21/24.
//

import UIKit
import Flutter

class DeviceInfoHelper {
    static func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        
        if device.batteryState == UIDevice.BatteryState.unknown {
            result(FlutterError(code: "Unavailable", message: "Battery level not available", details: nil))
        } else {
            result(device.batteryLevel * 100)
        }
    }
    
    static func receiveDeviceInfo(result: FlutterResult) {
        let device = UIDevice.current
        let fileManager = FileManager.default
        
        do {
            let attributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
                      let totalSpace = attributes[.systemSize] as? Int64 ?? 0
                      let freeSpace = attributes[.systemFreeSize] as? Int64 ?? 0
                      
                      let totalSpaceGB = Double(totalSpace) / (1024 * 1024 * 1024)
                      let freeSpaceGB = Double(freeSpace) / (1024 * 1024 * 1024)
                      
                      let deviceInfo: [String: Any] = [
                          "model": device.model,
                          "name": device.name,
                          "systemName": device.systemName,
                          "systemVersion": device.systemVersion,
                          "totalDiskSpaceGB": String(format: "%.2f", totalSpaceGB),
                          "freeDiskSpaceGB": String(format: "%.2f", freeSpaceGB)
                      ]
                      
                      result(deviceInfo)
        } catch {
            let deviceInfo: [String: Any] = [
                           "model": device.model,
                           "name": device.name,
                           "systemName": device.systemName,
                           "systemVersion": device.systemVersion,
                           "totalDiskSpaceGB": "Unavailable",
                           "freeDiskSpaceGB": "Unavailable"
                       ]
                       
                       result(deviceInfo)
        }
    }
}

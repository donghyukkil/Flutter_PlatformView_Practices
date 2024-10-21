//
//  BinaryMessageHandler.swift
//  Runner
//
//  Created by donghyukkil on 10/21/24.
//

import Flutter

class BinaryMessageHandler {
    static func register(binaryMessenger: FlutterBinaryMessenger) {
        binaryMessenger.setMessageHandlerOnChannel("samples.flutter.dev/binary") { (message: Data?, reply: FlutterBinaryReply) in
            if let data = message {
                // 데이터가 2바이트 단위로 전달되었다고 가정하고 길이를 계산하여 결과를 반환
                let length = data.count / 2
                var response = withUnsafeBytes(of: Int32(length).bigEndian) { Data($0) }
                reply(response)
            } else {
                reply(nil)
            }
        }
    }
}

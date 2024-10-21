//
//  MessageChannels.swift
//  Runner
//
//  Created by donghyukkil on 10/21/24.
//

import Flutter

class MessageChannels {
    static func register(controller: FlutterViewController) {
        let messageChannel = FlutterBasicMessageChannel(name: "samples.flutter.dev/chat", binaryMessenger: controller.binaryMessenger, codec: FlutterStringCodec.sharedInstance())
        
        messageChannel.setMessageHandler { (message: Any?, reply: FlutterReply) in
            if let text = message as? String {
                reply("\(text.count)")
            } else {
                reply("0")
            }
        }
    }
}

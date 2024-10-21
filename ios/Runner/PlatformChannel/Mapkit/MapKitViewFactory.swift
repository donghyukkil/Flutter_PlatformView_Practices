//
//  MapKitViewFactory.swift
//  Runner
//
//  Created by donghyukkil on 10/21/24.
//

import Flutter
import UIKit

class MapKitViewFactory: NSObject, FlutterPlatformViewFactory {
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return MapKitView(frame: frame)
    }
}

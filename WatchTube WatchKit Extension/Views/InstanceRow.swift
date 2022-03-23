//
//  InstanceRow.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 23/03/2022.
//

import Foundation
import WatchKit

class InstanceRow: NSObject {
    var instanceURL: String!
    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var tick: WKInterfaceImage!
    @IBOutlet var sep: WKInterfaceSeparator!
}

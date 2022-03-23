//
//  SubtitleRow.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 22/03/2022.
//

import WatchKit

class SubtitleRow: NSObject {
    @IBOutlet weak var label: WKInterfaceLabel!
    var str: String!
    @IBOutlet weak var tick: WKInterfaceImage!
    @IBOutlet weak var sep: WKInterfaceSeparator!
}

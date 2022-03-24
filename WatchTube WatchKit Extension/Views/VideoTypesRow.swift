//
//  VideoTypesRow.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 24/03/2022.
//

import WatchKit

class VideoTypesRow: NSObject {
    @IBOutlet weak var label: WKInterfaceLabel!
    @IBOutlet weak var sep: WKInterfaceSeparator!
    @IBOutlet weak var tick: WKInterfaceImage!
    var type: String!
}

//
//  VideoTableRow.swift
//  WatchTube WatchKit Extension
//
//  Created by developer on 12/6/20.
//

import Foundation
import WatchKit

class VideoRow: NSObject {

    @IBOutlet var channelLabel: WKInterfaceLabel!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var thumbImg: WKInterfaceImage!
    var videoId: String!
    var udid: String!
    @IBOutlet weak var channelTitle: WKInterfaceLabel!
    @IBOutlet weak var channelImg: WKInterfaceImage!
    @IBOutlet weak var videoGroup: WKInterfaceGroup!
    @IBOutlet weak var channelGroup: WKInterfaceGroup!
}

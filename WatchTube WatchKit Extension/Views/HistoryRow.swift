//
//  LikedVideosRow.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 17/03/2022.
//

import Foundation
import WatchKit

class HistoryRow: NSObject {
    @IBOutlet weak var channelLabel: WKInterfaceLabel!
    @IBOutlet weak var thumbnail: WKInterfaceImage!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    var id: String!
}

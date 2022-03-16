//
//  TrendingTableRow.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 14/12/2021.
//

import WatchKit
import Foundation

class TrendingRow: NSObject {
    // used on the inital view controller (home screen)
    @IBOutlet var trendingChannelLabel: WKInterfaceLabel!
    @IBOutlet var trendingTitleLabel: WKInterfaceLabel!
    @IBOutlet var trendingThumbImg: WKInterfaceImage!
    var videoId: String!
}

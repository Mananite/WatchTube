//
//  ChannelTableRow.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 16/01/2022.
//

import Foundation
import WatchKit


class ChannelVideoRow: NSObject {
    // used for the videos in the channel view screen
    @IBOutlet var channelVideoTitleLabel: WKInterfaceLabel!
    @IBOutlet var channelVideoThumbImg: WKInterfaceImage!
    var videoId: String!
}


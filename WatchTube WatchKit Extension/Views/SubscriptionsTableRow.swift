//
//  SubscriptionsTableRow.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 16/03/2022.
//

import Foundation
import WatchKit

class SubscriptionsRow: NSObject {
    // used in the subscriptions screen
    var udid: String!
    @IBOutlet weak var channelPfp: WKInterfaceImage!
    @IBOutlet weak var channelLabel: WKInterfaceLabel!
    @IBOutlet weak var subsLabel: WKInterfaceLabel!
}

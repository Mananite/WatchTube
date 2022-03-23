//
//  SubCommentsRow.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 23/03/2022.
//

import Foundation
import WatchKit

class SubCommentsRow: NSObject {
    @IBOutlet weak var authLabel: WKInterfaceLabel!
    @IBOutlet weak var subBody: WKInterfaceLabel!
    @IBOutlet weak var likesCount: WKInterfaceLabel!
    @IBOutlet weak var replyCount: WKInterfaceLabel!
    var contextData: comment!
}

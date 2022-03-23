//
//  CommentsRow.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 23/03/2022.
//

import Foundation
import WatchKit

class CommentsRow: NSObject {
    @IBOutlet weak var authorLabel: WKInterfaceLabel!
    @IBOutlet weak var contentBody: WKInterfaceLabel!
    @IBOutlet weak var likesCountLabel: WKInterfaceLabel!
    @IBOutlet weak var replyCountLabel: WKInterfaceLabel!
    var contextData: comment!
}

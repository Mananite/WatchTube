//
//  LibraryInterfaceController.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 14/03/2022.
//

import WatchKit
import Foundation


class LibraryInterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func history() {
        pushController(withName: "HistoryInterfaceController", context: "")
    }
    @IBAction func likes() {
        pushController(withName: "LikedVideosInterfaceController", context: "")
    }
    @IBAction func collections() {
        pushController(withName: "CollectionsInterfaceController", context: "")
    }
    @IBAction func subscriptions() {
        pushController(withName: "SubscriptionsInterfaceController", context: "")
    }
}

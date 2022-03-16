//
//  SearchTermsTableRow.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 20/02/2022.
//

import Foundation
import WatchKit

class SearchTermsRow: NSObject {
    // used for the search terms and suggestions in the search view screen
    @IBOutlet weak var label: WKInterfaceLabel!
    var text: String!
}

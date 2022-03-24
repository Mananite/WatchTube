//
//  HomeVideosInterfaceController.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 24/03/2022.
//

import WatchKit
import Foundation


class HomeVideosInterfaceController: WKInterfaceController {
    @IBOutlet weak var typesTable: WKInterfaceTable!
    var selected = ""
    var videoTypes: [String] = [
        "default",
        "music",
        "gaming",
        "news",
        "curated"
    ]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        selected = UserDefaults.standard.string(forKey: settingsKeys.homePageVideoType)!
        setupTable()
        // Configure interface objects here.
    }

    func setupTable() {
        typesTable.setNumberOfRows(videoTypes.count, withRowType: "VideoTypesRow")
        for i in 0..<videoTypes.count {
            guard let row = typesTable.rowController(at: i) as? VideoTypesRow else {
                return
            }
            let type = videoTypes[i]
            row.label.setText(type.capitalizingFirstLetter())
            row.type = type
            if i == videoTypes.count - 1 {
                row.sep.setHidden(true)
            } else {
                row.sep.setHidden(false)
            }
            if type == selected {
                row.tick.setHidden(false)
            } else {
                row.tick.setHidden(true)
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        for i in 0..<videoTypes.count {
            guard let row = typesTable.rowController(at: i) as? VideoTypesRow else {
                return
            }
            row.tick.setHidden(true)
        }
        guard let selectedRow = typesTable.rowController(at: rowIndex) as? VideoTypesRow else {
            return
        }
        selectedRow.tick.setHidden(false)
        selected = selectedRow.type
        
        UserDefaults.standard.set(selected, forKey: settingsKeys.homePageVideoType)
        self.pop()
        
    }
}

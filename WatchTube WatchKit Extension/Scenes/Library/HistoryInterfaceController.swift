//
//  HistoryInterfaceController.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 18/03/2022.
//

import WatchKit
import Foundation


class HistoryInterfaceController: WKInterfaceController {
    var itemsShown = UserDefaults.standard.integer(forKey: settingsKeys.itemsCount)

    @IBOutlet var historyTable: WKInterfaceTable!
    @IBOutlet var noHistoryLabel: WKInterfaceLabel!
    @IBOutlet var moreButton: WKInterfaceButton!

    override func willActivate() {
        super.willActivate()
                
        if itemsShown >= history.getHistory().count {
            moreButton.setHidden(true)
            itemsShown = history.getHistory().count
        } else {
            moreButton.setHidden(false)
        }
        
        if history.getHistory().count == 0 {
            moreButton.setHidden(true)
            noHistoryLabel.setHidden(false)
            return
        }

        setupTable(first: 0, last: itemsShown)

    }

    func setupTable(first: Int, last: Int) -> Void {
        historyTable.setNumberOfRows(last, withRowType: "HistoryRow")
        
        for i in first ..< last {
            guard let row = historyTable.rowController(at: i) as? HistoryRow else {
                continue
            }
            
            if i >= history.getHistory().count {
                break
            }
            
            let id = history.getHistory()[i]

            row.channelLabel.setText(meta.getVideoInfo(id: id, key: "channelName") as? String ?? "Unknown")
            row.titleLabel.setText(meta.getVideoInfo(id: id, key: "title") as? String ?? "Unknown")
            
            if UserDefaults.standard.value(forKey: settingsKeys.thumbnailsToggle) == nil {
                UserDefaults.standard.set(true, forKey: settingsKeys.thumbnailsToggle)
            }
            
            if UserDefaults.standard.bool(forKey: settingsKeys.thumbnailsToggle) == false {
                row.thumbnail.setHidden(true)
            } else {
                row.thumbnail.sd_setImage(with: URL(string: meta.getVideoInfo(id: id, key: "thumbnail") as! String))
            }
            
            meta.cacheVideoInfo(id: id)
        }
    }
    
    @IBAction func more() {
        itemsShown = itemsShown + UserDefaults.standard.integer(forKey: settingsKeys.itemsCount)
        
        animate(withDuration: 0.15) {
            self.moreButton.setAlpha(0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            if self.itemsShown >= history.getHistory().count {
                self.moreButton.setHidden(true)
                self.itemsShown = history.getHistory().count
            } else {
                self.moreButton.setHidden(false)
            }
            self.setupTable(first: 0, last: self.itemsShown)
            self.moreButton.setAlpha(1)
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt i: Int) {
        let id = history.getHistory()[i]
        if (meta.getVideoInfo(id: id, key: "title") as! String) == "???" {
            let ok = WKAlertAction(title: "Okay", style: .default) {}
            presentAlert(withTitle: "Slow Down!", message: "We're still waiting for the data you requested. Wait just a second!", preferredStyle: .alert, actions: [ok])
        } else {
            let title = meta.getVideoInfo(id: id, key: "title") as! String
            let img = meta.getVideoInfo(id: id, key: "thumbnail") as! String
            let channel = meta.getVideoInfo(id: id, key: "channelName") as! String
            let egg = Video(id: id, title: title, img: img, channel: channel, subs: "", type: "")
            pushController(withName: "NowPlayingInterfaceController", context: egg)
        }
    }
}

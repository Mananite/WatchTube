//
//  SubscriptionsInterfaceController.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 14/03/2022.
//

import WatchKit
import Foundation


class SubscriptionsInterfaceController: WKInterfaceController {
    var itemsShown = UserDefaults.standard.integer(forKey: settingsKeys.itemsCount)
    
    @IBOutlet weak var notSubbedLabel: WKInterfaceLabel!
    @IBOutlet weak var moreButton: WKInterfaceButton!
    @IBOutlet weak var subscriptionsTable: WKInterfaceTable!
    
    override func willActivate() {
        super.willActivate()
                
        if itemsShown >= subscriptions.getSubscriptions().count {
            moreButton.setHidden(true)
            itemsShown = subscriptions.getSubscriptions().count
        } else {
            moreButton.setHidden(false)
        }
        
        if subscriptions.getSubscriptions().count == 0 {
            moreButton.setHidden(true)
            notSubbedLabel.setHidden(false)
            return
        }
        subscriptions.sortInternal()
        setupTable(first: 0, last: itemsShown)

    }

    func setupTable(first: Int, last: Int) -> Void {
        subscriptionsTable.setNumberOfRows(last, withRowType: "SubscriptionsRow")
        
        for i in first ..< last {
            guard let row = subscriptionsTable.rowController(at: i) as? SubscriptionsRow else {
                continue
            }
            
            if i >= subscriptions.getSubscriptions().count {
                break
            }
            
            let udid = subscriptions.getSubscriptions()[i]

            row.channelLabel.setText(meta.getChannelInfo(udid: udid, key: "name") as? String ?? "Unknown")
            row.subsLabel.setText("\((meta.getChannelInfo(udid: udid, key: "subscribers") as? Double ?? 0).abbreviated) Subscribers")
            
            if UserDefaults.standard.value(forKey: settingsKeys.thumbnailsToggle) == nil {
                UserDefaults.standard.set(true, forKey: settingsKeys.thumbnailsToggle)
            }
            
            if UserDefaults.standard.bool(forKey: settingsKeys.thumbnailsToggle) == false {
                row.channelPfp.setHidden(true)
            } else {
                row.channelPfp.sd_setImage(with: URL(string: meta.getChannelInfo(udid: udid, key: "thumbnail") as! String))
            }
            
            meta.cacheChannelInfo(udid: udid)
        }
    }
    
    @IBAction func more() {
        itemsShown = itemsShown + UserDefaults.standard.integer(forKey: settingsKeys.itemsCount)
        
        animate(withDuration: 0.15) {
            self.moreButton.setAlpha(0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            if self.itemsShown >= subscriptions.getSubscriptions().count {
                self.moreButton.setHidden(true)
                self.itemsShown = subscriptions.getSubscriptions().count
            } else {
                self.moreButton.setHidden(false)
            }
            self.setupTable(first: 0, last: self.itemsShown)
            self.moreButton.setAlpha(1)
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt i: Int) {
        let udid = subscriptions.getSubscriptions()[i]
        if (meta.getChannelInfo(udid: udid, key: "name") as! String) == "???" {
            let ok = WKAlertAction(title: "Okay", style: .default) {}
            presentAlert(withTitle: "Slow Down!", message: "We're still waiting for the data you requested. Wait just a second!", preferredStyle: .alert, actions: [ok])
        } else {
            pushController(withName: "ChannelViewInterfaceController", context: udid)
        }
    }
}

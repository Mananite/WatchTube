//
//  SettingsInterfaceController.swift
//  WatchTube WatchKit Extension
//
//  Created by Hugo on 05/12/2021.
//

import WatchKit
import Foundation
import Alamofire
import UIKit

class SettingsInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var instanceButton: WKInterfaceLabel!
    @IBOutlet weak var thumbnailsToggle: WKInterfaceSwitch!
    @IBOutlet weak var audioOnlyToggle: WKInterfaceSwitch!
    @IBOutlet weak var resultsLabel: WKInterfaceLabel!
    @IBOutlet weak var itemsLabel: WKInterfaceLabel!
    @IBOutlet weak var qualityToggle: WKInterfaceSwitch!
    @IBOutlet weak var sizeLabel: WKInterfaceLabel!
    @IBOutlet weak var sizeCaptionTestLabel: WKInterfaceLabel!
    @IBOutlet weak var typeButton: WKInterfaceLabel!
    
    let userDefaults = UserDefaults.standard
    
//    var videoTypes: [String] = [
//        "default",
//        "music",
//        "gaming",
//        "news",
//        "curated"
//    ]
    
    var instances: Array<String> = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // set all the properties of settings to match userdefaults
        thumbnailsToggle.setOn(userDefaults.bool(forKey: settingsKeys.thumbnailsToggle))
        audioOnlyToggle.setOn(userDefaults.bool(forKey: settingsKeys.audioOnlyToggle))
        qualityToggle.setOn(userDefaults.bool(forKey: settingsKeys.qualityToggle))
        if userDefaults.bool(forKey: settingsKeys.qualityToggle) == true {qualityToggle.setTitle("HD")} else {qualityToggle.setTitle("SD")}
        
        updateLabel()
        
        // Configure interface objects here.
    }
    
    @IBAction func thumbnailsToggle(_ value: Bool) {
        userDefaults.set(value, forKey: settingsKeys.thumbnailsToggle)
    }
    
    @IBAction func audioOnlyToggle(_ value: Bool) {
        userDefaults.set(value, forKey: settingsKeys.audioOnlyToggle)
    }
    
    @IBAction func qualityToggle(_ value: Bool) {
        userDefaults.set(value, forKey: settingsKeys.qualityToggle)
        if value == true {
            qualityToggle.setTitle("HD")
        } else {
            qualityToggle.setTitle("SD")
        }
    }
    
    @IBAction func ClearRecentSearches() {
        userDefaults.setValue([], forKey: preferencesKeys.keywordsHistory)
    }
    
    @IBAction func resultLower() {
        if userDefaults.integer(forKey: settingsKeys.resultsCount) > 3 {
            userDefaults.set(userDefaults.value(forKey: settingsKeys.resultsCount) as! Int-1, forKey: settingsKeys.resultsCount)
            updateLabel()
        }
    }
    
    @IBAction func resultHigher() {
        if userDefaults.integer(forKey: settingsKeys.resultsCount) < 20 {
            userDefaults.set(userDefaults.value(forKey: settingsKeys.resultsCount) as! Int+1, forKey: settingsKeys.resultsCount)
            updateLabel()
        }
    }
    
    @IBAction func itemLower() {
        if userDefaults.integer(forKey: settingsKeys.itemsCount) > 5 {
            userDefaults.set(userDefaults.value(forKey: settingsKeys.itemsCount) as! Int-1, forKey: settingsKeys.itemsCount)
            updateLabel()
        }
    }
    
    @IBAction func itemHigher() {
        if userDefaults.integer(forKey: settingsKeys.itemsCount) < 80 {
            userDefaults.set(userDefaults.value(forKey: settingsKeys.itemsCount) as! Int+1, forKey: settingsKeys.itemsCount)
            updateLabel()
        }
    }
    
    @IBAction func sizeLower() {
        if userDefaults.integer(forKey: settingsKeys.captionsSize) > 8 {
            userDefaults.set(userDefaults.value(forKey: settingsKeys.captionsSize) as! Int-1, forKey: settingsKeys.captionsSize)
            updateLabel()
        }
    }
    
    @IBAction func sizeHigher() {
        if userDefaults.integer(forKey: settingsKeys.captionsSize) < 18 {
            userDefaults.set(userDefaults.value(forKey: settingsKeys.captionsSize) as! Int+1, forKey: settingsKeys.captionsSize)
            updateLabel()
        }
    }
    
    func updateLabel() {
        animate(withDuration: 0.2) {
            self.resultsLabel.setText("\(String(describing: self.userDefaults.value(forKey: settingsKeys.resultsCount) as! Int)) Results")
            self.itemsLabel.setText("\(String(describing: self.userDefaults.value(forKey: settingsKeys.itemsCount) as! Int)) Items")
            self.sizeLabel.setText("Size \(String(describing: self.userDefaults.value(forKey: settingsKeys.captionsSize) as! Int))")

            let text = NSMutableAttributedString(string: "Hi I'm a test caption")
            let regularFont = UIFont.systemFont(ofSize: CGFloat(self.userDefaults.integer(forKey: settingsKeys.captionsSize)))
            text.addAttribute(NSAttributedString.Key.font, value: regularFont, range: NSMakeRange(0, "Hi I'm a test caption".count))
            self.sizeCaptionTestLabel.setAttributedText(text)
        }
    }
    
    override func willActivate() {
        instanceButton.setText(userDefaults.string(forKey: settingsKeys.instanceUrl))
        typeButton.setText(userDefaults.string(forKey: settingsKeys.homePageVideoType)?.capitalizingFirstLetter())
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

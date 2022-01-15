//
//  Misc.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 11/01/2022.
//

import Foundation

class misc {
    class func defaultSettings() {
        // if userdefaults don't exist (like when the app is freshly installed), set them all now.
        if UserDefaults.standard.value(forKey: settingsKeys.cacheToggle) == nil {
            UserDefaults.standard.set(true, forKey: settingsKeys.cacheToggle)
        }
        if UserDefaults.standard.value(forKey: settingsKeys.thumbnailsToggle) == nil {
            UserDefaults.standard.set(true, forKey: settingsKeys.thumbnailsToggle)
        }
        if UserDefaults.standard.value(forKey: settingsKeys.audioOnlyToggle) == nil {
            UserDefaults.standard.set(false, forKey: settingsKeys.audioOnlyToggle)
        }
        if UserDefaults.standard.value(forKey: settingsKeys.resultsCount) == nil {
            UserDefaults.standard.set(10, forKey: settingsKeys.resultsCount)
        }
        if UserDefaults.standard.value(forKey: settingsKeys.itemsCount) == nil {
            UserDefaults.standard.set(12, forKey: settingsKeys.itemsCount)
        }
        if UserDefaults.standard.value(forKey: settingsKeys.homePageVideoType) == nil {
            UserDefaults.standard.set("default", forKey: settingsKeys.homePageVideoType)
        }
        if UserDefaults.standard.value(forKey: settingsKeys.instanceUrl) == nil {
            UserDefaults.standard.set("vid.puffyan.us", forKey: settingsKeys.instanceUrl)
        }
        if UserDefaults.standard.value(forKey: settingsKeys.proxyContent) == nil {
            UserDefaults.standard.set(true, forKey: settingsKeys.proxyContent)
        }
        if UserDefaults.standard.value(forKey: settingsKeys.qualityToggle) == nil {
            UserDefaults.standard.set(true, forKey: settingsKeys.qualityToggle)
        }
        if UserDefaults.standard.value(forKey: miscKeys.pushToCacheContents) == nil {
            UserDefaults.standard.set(false, forKey: miscKeys.pushToCacheContents)
        }
        // this instance just works lol. idk why but some dont have a working api 
    }
}

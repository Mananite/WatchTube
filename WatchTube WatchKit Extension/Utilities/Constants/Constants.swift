//
//  Constants.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 20/04/2022.
//

import Foundation

struct Constants {
    static let defaultInstance = "invidious.osi.kr"
}
struct settingsKeys {
    static let instanceUrl = "settingsKeys.instanceUrl"
    static let preferredCaptionsLanguage = "settingsKeys.preferredCaptionsLanguage"
    static let captionsFontSize = "settingsKeys.captionsFontSize"
    static let trendingType = "settingsKeys.trendingType"
}

struct algorithmConfig {
    static let latestLikedVideosToSample = 10
    static let quantityOfVideosToGetFromRelatedVideos = 6
    static let channelsToSample = 10
    static let quantityOfVideosToGetFromChannels = 6
    static let historyToSample = 15
    static let quantityOfVideosToGetFromHistory = 6
}

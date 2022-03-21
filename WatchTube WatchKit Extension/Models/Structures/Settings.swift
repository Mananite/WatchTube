//
//  Settings.swift
//  WatchTube WatchKit Extension
//
//  Created by developer on 12/6/20.
//

import Foundation
struct preferencesKeys {
    static let keywordsHistory = "keywordsHistory"
}

struct settingsKeys {
    static let thumbnailsToggle = "settings.thumbnailsToggleKey"
    static let audioOnlyToggle = "settings.audioOnlyToggleKey"
    static let resultsCount = "settings.resultsCount"
    static let itemsCount = "settings.itemsCount"
    static let homePageVideoType = "settings.homePageVideoType"
    static let instanceUrl = "settings.instanceUrl"
    static let qualityToggle = "settings.qualityToggle"
    static let captionsSize = "settings.captionsSize"
    static let firstTimeGuide = "settings.firstTimeGuide"
}

struct Constants {
    static let defaultInstance = "invidious.osi.kr"
}

struct hls {
    static let url = "hls.streamUrl"
    static let captionsLangCode = "hls.captionsLangCode"
    static let videoId = "hls.videoId"
}

struct algorithmConfig {
    // this part gets recommendations from liked videos
    static let latestLikedVideosToSample = 10
    static let quantityOfVideosToGetFromRelatedVideos = 5
    static let channelsToSample = 10
    static let quantityOfVideosToGetFromChannels = 5
}

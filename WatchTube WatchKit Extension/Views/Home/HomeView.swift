//
//  HomeView.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 19/04/2022.
//

import SwiftUI
import Invidious_Swift
import SDWebImageSwiftUI

struct HomeView: View {
    
    @State private var finishedLoading = false
    @State private var trendingData = [InvTrendingVideo]()
    @State private var curatedData = [customData]()
        
    var body: some View {
        NavigationView {
            if finishedLoading == false {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                if trendingData.isEmpty && curatedData.isEmpty {
                    VStack(spacing: 10) {
                        Text("An error has occurred.")
                        Button {
                            Task {
                                finishedLoading = false
                                let data = await inv.trending(cc: Locale.current.regionCode)
                                if data != nil {
                                    trendingData = data!
                                }
                                finishedLoading = true
                            }
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    }
                        .navigationTitle("Error")
                } else if curatedData.isEmpty && !trendingData.isEmpty {
                    ScrollView{
                        LazyVStack {
                            ForEach(0..<trendingData.count, id: \.self) { i in
                                let video = trendingData[i]
                                Video(title: video.title, author: video.author, id: video.videoID, url: video.videoThumbnails[0].url)
                                    .task {
                                        await metadata.cacheVideoData(video.videoID)
                                    }
                            }
                        }
                        .cornerRadius(10)
                        .navigationTitle("WatchTube")
                    }
                } else if !curatedData.isEmpty && trendingData.isEmpty {
                    ScrollView{
                        LazyVStack {
                            ForEach(0..<curatedData.count, id: \.self) { i in
                                let video = curatedData[i]
                                Video(title: video.title, author: video.author, id: video.id, url: video.url)
                                    .task {
                                        await metadata.cacheVideoData(video.id, doNotCacheRelated: true)
                                    }
                            }
                        }
                        .cornerRadius(10)
                        .navigationTitle("WatchTube")
                    }
                }
            }
        }
        .task {
            if !curatedData.isEmpty || !trendingData.isEmpty {return}
            if UserDefaults.standard.string(forKey: settingsKeys.trendingType) ?? "default" == "curated" {
                // the almighty youtube algorithm
                // scrape whatever for curated data
                var videosSelected: [String] = []
    //            meta.cacheVideoInfo(id: "bYCUt4sPlKc")
                
                if liked.getLikes().count == 0 || subscriptions.getSubscriptions().count == 0 || history.getHistory().count == 0 { // there is no data to use
                    let data = await inv.trending(cc: Locale.current.regionCode)
                    if data != nil {
                        trendingData = data!
                    }
                    finishedLoading = true
                    return
                }
                for i in 0..<(algorithmConfig.latestLikedVideosToSample > liked.getLikes().count ? algorithmConfig.latestLikedVideosToSample : liked.getLikes().count - 1) {
                    // get last 10 liked videos
                    let likedVideos = liked.getLikes()
                    if i >= likedVideos.count { break }
                    let likedVideo = likedVideos[i]
                    var selectedVideosToAdd: [String] = []
                    for i in 0..<algorithmConfig.quantityOfVideosToGetFromRelatedVideos {
                        while selectedVideosToAdd.count != i + 1 {
                            let related = metadata.getVideoData(likedVideo, key: .related) as? Array<String> ?? []
                            if related.count == 0 { break }
                            let selectedId = related.randomElement()!
                            if metadata.getVideoData(selectedId, key: .title) == nil {continue}
                            if selectedVideosToAdd.contains(selectedId) { continue } else {
                                selectedVideosToAdd.append(selectedId)
                            }
                        }
                    }
                    for id in selectedVideosToAdd {
                        videosSelected.append(id)
                    }
                }
                
                for i in 0..<(algorithmConfig.historyToSample > history.getHistory().count ? algorithmConfig.historyToSample : history.getHistory().count - 1) {
                    // get last 10 history videos
                    let historyvideos = history.getHistory()
                    if i >= historyvideos.count { break }
                    let historyVideo = historyvideos[i]
                    var selectedVideosToAdd: [String] = []
                    for i in 0..<algorithmConfig.quantityOfVideosToGetFromHistory {
                        while selectedVideosToAdd.count != i + 1 {
                            let related = metadata.getVideoData(historyVideo, key: .related) as? Array<String> ?? []
                            if related.count == 0 { break }
                            let selectedId = related.randomElement()!
                            if metadata.getVideoData(selectedId, key: .title) == nil {continue}
                            if selectedVideosToAdd.contains(selectedId) { continue } else {
                                selectedVideosToAdd.append(selectedId)
                            }
                        }
                    }
                    for id in selectedVideosToAdd {
                        videosSelected.append(id)
                    }
                }
                
                var manipulatableChannelList = subscriptions.getSubscriptions()
                var selectedChannels: [String] = []
                
                manipulatableChannelList.shuffle()
                for channel in manipulatableChannelList {
                    // makes sure channels have at least x videos and stuff
                    if selectedChannels.count != algorithmConfig.channelsToSample && (metadata.getChannelData(channel, key: .videos) as! [String]).count >= algorithmConfig.quantityOfVideosToGetFromChannels {
                        selectedChannels.append(channel)
                    }
                }
                
                for channel in selectedChannels {
                    var vidsarray = metadata.getChannelData(channel, key: .videos) as! [String]
                    vidsarray = Array(vidsarray.prefix(algorithmConfig.quantityOfVideosToGetFromChannels))
                    vidsarray.shuffle()
                    for vid in vidsarray {
                        videosSelected.append(vid)
                    }
                }
                
                var videos = [customData]()
                videosSelected.shuffle()
                var added = [String]()
                for id in videosSelected {
                    if added.contains(id) {continue} else {added.append(id)}
                    await metadata.cacheVideoData(id, doNotCacheRelated: true)
                    let title = metadata.getVideoData(id, key: .title)
                    let thumb = metadata.getVideoData(id, key: .thumbnail)
                    let channel = metadata.getVideoData(id, key: .author)
                    if title == nil || thumb == nil || channel == nil {continue}
                    let video = customData(title: title as! String, author: channel as! String, id: id, url: thumb as! String)
                    videos.append(video)
                }
                                                
                if videos.isEmpty {
                    let data = await inv.trending(cc: Locale.current.regionCode)
                    if data != nil {
                        trendingData = data!
                    }
                    finishedLoading = true
                    return
                } else {
                    curatedData = videos
                    finishedLoading = true
                    return
                }
            } else {
                let data = await inv.trending(cc: Locale.current.regionCode)
                if data != nil {
                    trendingData = data!
                }
                finishedLoading = true
            }
        }
    }
}

fileprivate struct customData: Hashable {
    let title, author, id, url: String
}

struct homepreview: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

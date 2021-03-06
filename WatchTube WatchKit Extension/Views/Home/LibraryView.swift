//
//  LibraryView.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 19/04/2022.
//

import SwiftUI
import Invidious_Swift
import SDWebImageSwiftUI

struct LibraryView: View {
    
    @State private var historyVideoIds = history.getHistory()
    @State private var likedVideoIds = liked.getLikes()
    @State private var subbedChannelUdids = subscriptions.getSubscriptions()

    @State private var videoData: [String:InvVideo] = [:]
    @State private var channelData: [String:InvChannel] = [:]
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Text("History")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .onAppear(perform: {
                    historyVideoIds = history.getHistory()
                    likedVideoIds = liked.getLikes()
                    subbedChannelUdids = subscriptions.getSubscriptions()
                })
                .navigationTitle("Library")
                
                ScrollView(.horizontal, showsIndicators: true) { // liked videos
                    LazyHStack {
                        ForEach(historyVideoIds, id: \.self) { id in
                            VStack {
                                if videoData[id] != nil {
                                    let video = videoData[id]!
                                    NarrowVideo(title: video.title, author: video.author, id: id, url: video.videoThumbnails[0].url)
                                        .task {
                                            await metadata.cacheVideoData(id)
                                        }
                                } else {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .frame(width: WKInterfaceDevice.current().screenBounds.width - 25)
                                }
                            }
                            .task {
                                if videoData[id] == nil {
                                    let data = await inv.video(id: id)
                                    if data != nil && videoData[id] == nil {
                                        videoData[id] = data
                                    }
                                }
                                await metadata.cacheVideoData(id)
                            }
                        }
                    }
                }
                .cornerRadius(10)
                
                HStack {
                    Text("Liked Videos")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: true) { // liked videos
                    LazyHStack {
                        ForEach(likedVideoIds, id: \.self) { id in
                            VStack {
                                if videoData[id] != nil {
                                    let video = videoData[id]!
                                    NarrowVideo(title: video.title, author: video.author, id: id, url: video.videoThumbnails[0].url)
                                        .task {
                                            await metadata.cacheVideoData(id)
                                        }
                                } else {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .frame(width: WKInterfaceDevice.current().screenBounds.width - 25)
                                }
                            }
                            .task {
                                if videoData[id] == nil && videoData[id] == nil {
                                    let data = await inv.video(id: id)
                                    if data != nil {
                                        videoData[id] = data
                                    }
                                }
                                await metadata.cacheVideoData(id)
                            }
                        }
                    }
                }
                .cornerRadius(10)
                
                HStack {
                    Text("Subscriptions")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: true) { // channels
                    LazyHStack {
                        ForEach(subbedChannelUdids, id: \.self) { udid in
                            VStack {
                                if channelData[udid] != nil {
                                    // add channel view here
                                    let channel = channelData[udid]!
                                    NarrowChannel(udid: udid, author: channel.author, url: channel.authorThumbnails.last!.url)
                                        .task {
                                            await metadata.cacheChannelData(udid)
                                        }
                                } else {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .frame(width: WKInterfaceDevice.current().screenBounds.width / 3)
                                }
                            }
                            .task {
                                if channelData[udid] == nil {
                                    let data = await inv.channel(udid: udid)
                                    if data != nil && channelData[udid] == nil {
                                        channelData[udid] = data
                                    }
                                }
                                await metadata.cacheChannelData(udid)
                            }
                        }
                    }
                }
                .cornerRadius(10)
            }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}

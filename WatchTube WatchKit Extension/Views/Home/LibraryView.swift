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
    
    @State private var likedVideoIds = [String]()
    @State private var videoData: [String:InvVideo] = [:]
    
    @State private var subbedChannelUdids = [String]()
    @State private var channelData: [String:InvChannel] = [:]
    
    var body: some View {
        NavigationView {
                ScrollView {
                HStack {
                    Text("Liked Videos")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .navigationTitle("Library")

                ScrollView(.horizontal, showsIndicators: true) { // liked videos
                    LazyHStack {
                        ForEach(likedVideoIds, id: \.self) { id in
                            VStack {
                                if videoData[id] != nil {
                                    let video = videoData[id]!
                                    NarrowVideo(title: video.title, author: video.author, id: id, url: video.videoThumbnails[0].url)
                                } else {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .frame(width: WKInterfaceDevice.current().screenBounds.width - 25)
                                }
                            }
                            .task {
                                if videoData[id] == nil {
                                    let data = await inv.video(id: id)
                                    if data != nil {
                                        videoData[id] = data
                                    }
                                }
                            }
                        }
                    }
                }
                .cornerRadius(10)
                .onAppear {
                    likedVideoIds = liked.getLikes()
                }
                
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
                                } else {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .frame(width: WKInterfaceDevice.current().screenBounds.width / 3)
                                }
                            }
                            .task {
                                if channelData[udid] == nil {
                                    let data = await inv.channel(udid: udid)
                                    if data != nil {
                                        channelData[udid] = data
                                    }
                                }
                            }
                        }
                    }
                }
                .cornerRadius(10)
                .onAppear {
                    subbedChannelUdids = subscriptions.getSubscriptions()
                }
            }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}

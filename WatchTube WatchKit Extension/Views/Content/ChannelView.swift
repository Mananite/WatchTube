//
//  ChannelView.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 25/04/2022.
//

import SwiftUI
import Invidious_Swift
import SDWebImageSwiftUI

struct ChannelView: View {
    
    var udid: String
    
    @State var isDoneLoading = false
    @State var channel: InvChannel! = nil
    
    @State private var isSubscribed: Bool = false
    
    @State private var viewingBanner: Bool = false
    @State private var viewingPfp: Bool = false

    var body: some View {
        if isDoneLoading == true {
            if channel != nil {
                ScrollView {
                    VStack { // banner and pfp
                        ZStack {
                            NavigationLink { // banner
                                ImageView(url: URL(string: channel.authorBanners[0].url))
                            } label: {
                                VStack {
                                    WebImage(url: URL(string: channel.authorBanners[0].url))
                                        .placeholder {
                                            ProgressView()
                                                .progressViewStyle(.circular)
                                        }
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(3)
                                    Spacer()
                                }
                            }
                            .buttonStyle(.plain)
                            HStack {
                                NavigationLink { // pfp
                                    ImageView(url: URL(string: channel.authorThumbnails.last!.url))
                                } label: {
                                    VStack {
                                        WebImage(url: URL(string: channel.authorThumbnails.last!.url))
                                            .placeholder {
                                                ProgressView()
                                                    .progressViewStyle(.circular)
                                            }
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40)
                                            .clipShape(Circle())
                                            .padding(1)
                                            .background(
                                                Circle()
                                                    .foregroundColor(.black)
                                            )
                                    }
                                    .padding([.leading, .top], 5)
                                    Spacer()
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    HStack {
                        Text(channel.author)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        Spacer()
                        Button {
                            isSubscribed.toggle()
                            
                            switch isSubscribed {
                            case true:
                                subscriptions.subscribe(udid: udid)
                            case false:
                                subscriptions.unsubscribe(udid: udid)
                            }
                        } label: {
                            Text(isSubscribed ? "Subscribed" : "Subscribe")
                                .animation(.easeInOut(duration: 0.2))
                                .font(.footnote)
                                .padding(3)
                                .background {
                                    RoundedRectangle(cornerRadius: 7)
                                        .foregroundColor(isSubscribed ? .gray : .red)
                                        .brightness(isSubscribed ? -0.5 : 0)
                                        .animation(.easeInOut(duration: 0.2))
                                }
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            isSubscribed = subscriptions.getSubscriptions().contains(udid)
                        }
                    }
                    
                    HStack {
                        Text("Videos")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(0..<(channel.latestVideos.count >= 15 ? 15 : channel.latestVideos.count), id: \.self) { i in
                                let video = channel.latestVideos[i]
                                let title = video.title
                                let author = video.author
                                let id = video.videoID
                                let url = video.videoThumbnails[0].url
                                
                                NarrowVideo(title: title, author: author, id: id, url: url)
                            }
                            NavigationLink {
                                MoreVideos(udid: channel.authorID)
                            } label: {
                                Image(systemName: "plus.circle")
                            }

                        }
                        .frame(height: 160)
                    }
                    .cornerRadius(10)
                }
                .transition(.slide)
                .navigationTitle("Channel")
            } else {
                // error message and reload button
                VStack(spacing: 10) {
                    Text("An error has occurred.")
                    Button {
                        Task {
                            isDoneLoading = false
                            let data = await inv.channel(udid: udid)
                            if data != nil {
                                channel = data
                            }
                            isDoneLoading = true
                        }
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                }
            }
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .task {
                    let data = await inv.channel(udid: udid)
                    if data != nil {
                        channel = data
                    }
                    isDoneLoading = true
                    await metadata.cacheChannelData(udid)
                }
        }
    }
}

fileprivate struct MoreVideos: View {
    
    var udid: String
    @State private var videos = InvChannelVideos()
    @State private var page = 1
    @State private var lastCount = 0
    var body: some View {
        if videos.isEmpty {
            ProgressView()
                .progressViewStyle(.circular)
                .task {
                    let data = await inv.channelVideos(udid: udid, page: 1)
                    if data != nil {
                        videos = data!
                        lastCount = videos.count
                    }
                }
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(0..<videos.count, id: \.self) { i in
                        let vid = videos[i]
                        Video(title: vid.title, author: vid.author, id: vid.videoID, url: vid.videoThumbnails[0].url)
                    }
                    ProgressView()
                        .progressViewStyle(.circular)
                        .task {
                            page += 1
                            let data = await inv.channelVideos(udid: udid, page: page)
                            if data != nil {
                                let ids: [String] = {
                                    var list: [String] = []
                                    for item in videos {
                                        list.append(item.videoID)
                                    }
                                    return list
                                }()
                                for item in data! {
                                    if !ids.contains(item.videoID) { // this is just a failsafe
                                        videos.append(item)
                                    }
                                }
                                lastCount = videos.count
                            }
                        }
                }
            }
        }
    }
}

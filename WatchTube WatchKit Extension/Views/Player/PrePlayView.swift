//
//  PrePlayView.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 19/04/2022.
//

import SwiftUI
import Invidious_Swift
import YouTubeKit
import SDWebImageSwiftUI

struct PrePlayView: View {
    
    @State private var isDoneLoading: Bool = false
    @State private var showingOptionsSheet = false
    
    @Environment(\.presentationMode) var presentation
    
    var id: String
    
    @State private var video: InvVideo! = nil
    @State private var streams: [YouTubeKit.Stream]! = nil
    @State private var isLikedVideo: Bool = false
    
    @State var playerIsShowing: Bool = false
    
    var body: some View {
        if video == nil {
            if isDoneLoading == false {
                ProgressView()
                    .progressViewStyle(.circular)
                    .task {
                        // start loading video data
                        let data = await inv.video(id: id)
                        if data == nil {
                            isDoneLoading = true
                        } else {
                            video = data
                        }
                    }
            } else {
                VStack(spacing: 10) {
                    Text("An error has occurred.")
                    Button {
                        Task {
                            isDoneLoading = false
                            // start loading video data
                            let data = await inv.video(id: id)
                            if data == nil {
                                isDoneLoading = true
                            } else {
                                video = data
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                }
                    .navigationTitle("Error")
            }
        } else {
            // player view
            VStack {
                HStack {
                    Text(video.title)
                        .font(.footnote)
                        .lineLimit(2)
                    Spacer()
                }
                WebImage(url: URL(string: video.videoThumbnails[0].url)!)
                    .resizable()
                    .placeholder {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .brightness(-0.1)
                    .overlay(content: {
                        if streams == nil {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .shadow(color: .black, radius: 5, x: 0, y: 0)
                        } else {
                            NavigationLink(isActive: $playerIsShowing, destination: {
                                PlayerView(playerIsShowing: $playerIsShowing, video: video, streams: streams)
                            }, label: {
                                Image(systemName: "play.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40)
                                    .shadow(color: .black, radius: 5, x: 0, y: 0)
                            })
                            .buttonStyle(.plain)
                        }
                    })
                    .task {
                        let ytvid = YouTube(videoID: id)
                        let vidstreams = try? await ytvid.streams
                        if vidstreams == nil {
                            isDoneLoading = true
                            return
                        } else {
                            streams = vidstreams
                            let final = streams.filter { $0.isProgressive && $0.subtype == "mp4" }.highestResolutionStream()
                            UserDefaults.standard.set(final?.url, forKey: "hls.streamUrl")
                        }
                    }
                HStack {
                    NavigationLink {
                        ChannelView(udid: video.authorID)
                    } label: {
                        Text(video.author)
                            .font(.footnote)
                            .lineLimit(1)
                    }
                    .buttonStyle(.plain)

                    Spacer()
                    
                    Button {
                        isLikedVideo.toggle()
                        
                        switch isLikedVideo {
                        case true:
                            liked.like(id: video.videoID)
                        case false:
                            liked.unlike(id: video.videoID)
                        }
                    } label: {
                        Image(systemName: isLikedVideo ? "hand.thumbsup.circle.fill" : "hand.thumbsup.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        isLikedVideo = liked.getLikes().contains(video.videoID)
                    }
                    
                    Button(action: {
                        if video != nil {
                            showingOptionsSheet.toggle()
                        }
                    }) {
                        Image(systemName: "gear.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                    }.sheet(isPresented: $showingOptionsSheet) {
                        OptionsView(video: video)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Player")
        }
    }
}

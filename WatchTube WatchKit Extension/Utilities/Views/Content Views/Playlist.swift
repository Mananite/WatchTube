//
//  Playlist.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 09/05/2022.
//

import SwiftUI
import Invidious_Swift
import SDWebImageSwiftUI

struct Playlist: View {
    var title: String
    var author: String
    var plid: String
    
    @State private var playlistVideos = [InvPlaylistVideo]()
    @State private var opacity: Double = 0
    @State private var object: Int = 0
    var body: some View {
        ZStack {
            WebImage(url: URL(string: playlistVideos[object].videoThumbnails.first!.url))
                .opacity(opacity)
                .task {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        opacity = 1
                    }
                    object += 1
                    if object >= 5 {object = 0}
                }
        }
        .fixedSize()
        .task {
            let data = await inv.playlist(plid: plid)
            if data != nil {
                playlistVideos = data!.videos
            }
        }
    }
}

struct Playlist_Previews: PreviewProvider {
    static var previews: some View {
        Playlist(title: "Egg", author: "Nog", plid: "")
    }
}

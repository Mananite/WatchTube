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
    var thumb: String
    
    var body: some View {
        NavigationLink {
            Text(plid)
        } label: {
            HStack {
                WebImage(url: URL(string: thumb))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .cornerRadius(5)
                VStack {
                    HStack {
                        Text(title)
                        Spacer()
                    }
                    HStack {
                        Text(author)
                        Spacer()
                    }
                }
            }
        }

    }
}

struct Playlist_Previews: PreviewProvider {
    static var previews: some View {
        Playlist(title: "Egg", author: "Nog", plid: "", thumb: "")
    }
}

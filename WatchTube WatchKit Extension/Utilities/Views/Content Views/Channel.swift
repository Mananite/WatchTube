//
//  Channel.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 27/04/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct Channel: View {
    
    var author: String
    var url: URL
    var subs: Double
    var udid: String
    
    var body: some View {
        NavigationLink {
            ChannelView(udid: udid)
        } label: {
            VStack {
                HStack {
                    WebImage(url: url)
                        .placeholder {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: WKInterfaceDevice.current().screenBounds.width / 4)
                    VStack {
                        Text(author)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        Text("\(subs.abbreviated) Subscribers")
                            .lineLimit(1)
                            .font(.caption)
                            .minimumScaleFactor(0.1)
                    }
                }
            }
        }
        .task {
            if metadata.getChannelData(udid, key: .author) == nil {
                await metadata.cacheChannelData(udid)
            }
        }
    }
}

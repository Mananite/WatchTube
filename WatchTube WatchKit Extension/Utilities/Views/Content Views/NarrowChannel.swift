//
//  NarrowChannel.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 27/04/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct NarrowChannel: View {
    
    var udid: String
    var author: String
    var url: String
    
    var body: some View {
        NavigationLink {
            ChannelView(udid: udid)
        } label: {
            VStack {
                WebImage(url: URL(string: url))
                    .resizable()
                    .placeholder {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                    .clipShape(Circle())
                Text(author)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
            }
            .frame(width: 100)
        }

    }
}

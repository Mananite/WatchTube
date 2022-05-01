//
//  Video.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 27/04/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct Video: View {
    
    var title: String
    var author: String
    var id: String
    var url: String

    var body: some View {
        NavigationLink {
            PrePlayView(id: id)
        } label: {
            VStack {
                HStack {
                    Text(author)
                        .font(.system(size: 11))
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .frame(width: WKInterfaceDevice.current().screenBounds.width - 25)
                WebImage(url: URL(string: url))
                    .placeholder {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(height: 97)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .frame(height: 97)

                HStack {
                    Text(title)
                        .font(.system(size: 11))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .frame(width: WKInterfaceDevice.current().screenBounds.width - 25)
            }
            .frame(width: WKInterfaceDevice.current().screenBounds.width - 25)
            .buttonStyle(.plain)
//            .background{
//                WebImage(url: URL(string: url))
//                    .resizable()
//                    .scaledToFill()
//                    .brightness(-0.3)
//                    .blur(radius: 20)
//            }
        }
    }
}

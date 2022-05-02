//
//  InfomationView.swift
//  WatchTube WatchKit Extension
//
//  Created by Hugo Mason on 24/04/2022.
//

import SwiftUI
import Invidious_Swift

struct InformationView: View {
    
    var video: InvVideo
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(video.title)
                    .padding(.vertical)
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(Image(systemName: "eye.circle.fill"))
                            .foregroundColor(Color.accentColor)
                        Text("\(Double(video.viewCount).abbreviated) Views")
                            .font(.footnote)
                    }
                    HStack {
                        Text(Image(systemName: "hand.thumbsup.circle.fill"))
                            .foregroundColor(Color.accentColor)
                        Text("\(Double(video.likeCount).abbreviated) Likes")
                            .font(.footnote)
                    }
                    HStack {
                        Text(Image(systemName: "person.circle.fill"))
                            .foregroundColor(Color.accentColor)
                        Text("\(video.author)")
                            .font(.footnote)
                    }
                    HStack {
                        Text(Image(systemName: "arrow.up.circle.fill"))
                            .foregroundColor(Color.accentColor)
                        Text("Uploaded \(String(describing: (video.publishedText)))")
                            .font(.footnote)
                    }
                }
                Text(video.videoDescription)
                    .padding(.top)
                    .lineLimit(.none)
                    .font(.caption2)
            }
        }
        .navigationTitle("Information")
    }
}

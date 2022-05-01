//
//  SubCommentsView.swift
//  WatchTube WatchKit Extension
//
//  Created by Hugo Mason on 28/04/2022.
//

import SwiftUI
import Invidious_Swift

struct SubCommentsView: View {
    
    var video: InvVideo // you need the video id for api calls
    @State private var videoComments: InvComments! = nil // we make it optional and make it nil so we know it didnt load
    
    var body: some View {
        if videoComments != nil { // data exists, show it
            ScrollView {
                // List(0..<videoComments.commentCount, id: \.self) { i in
                // i removed this line because this count shows you all the comments in the entire video, this is not programmatically usable
                
                // here is what you should do instead
                LazyVStack {
                    ForEach(0..<videoComments.comments.count, id: \.self) { i in  // only count data you have
                        let comment = videoComments.comments[i] // save yourself from excessive typing bro
                        NavigationLink {
                            // we need to be able to see subreplies
                            // TODO: Add subreplies
                            
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(comment.author)
                                        .fontWeight(.thin)
                                    Text(comment.publishedText)
                                        .fontWeight(.thin)
                                }
                                .frame(width: 200, height: 10)
                                .padding()
                                Text(comment.content)
                                
                                HStack {
                                    Text("\(comment.likeCount)")
                                    Text(String(describing: comment.replies?.replyCount))
                                }
                            }
                        }
                    }
                }
            }
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .task {
                    // we'll load the data from here
                    if videoComments != nil {
                        let data = await inv.comments(id: video.videoID, continuation: videoComments.continuation)
                        if data != nil {
                            videoComments = data!
                            print(data as Any)
                        }
                    }
                    else {
                       print("real")
                    }
                }
        }
    }
}

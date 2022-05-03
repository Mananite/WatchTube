//
//  CommentsView.swift
//  WatchTube WatchKit Extension
//
//  Created by Hugo Mason on 24/04/2022.
//

import SwiftUI
import Invidious_Swift

struct CommentsView: View {

    var video: InvVideo // you need the video id for api calls
    var sourceComment: InvComment! = nil
    @State private var CommentsArray: [InvComment]! = []
    @State private var videoComments: InvComments! = nil // we make it optional and make it nil so we know it didnt load
    @State private var stopRequests = false
    var body: some View {
        if videoComments != nil || stopRequests { // data exists, show it
            ScrollView {
                // List(0..<videoComments.commentCount, id: \.self) { i in
                // i removed this line because this count shows you all the comments in the entire video, this is not programmatically usable
                
                // here is what you should do instead
                LazyVStack {
                    if sourceComment != nil {
                        Button {
                            // Nothing needed...
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("\(sourceComment.author) | \(sourceComment.publishedText)")
                                        .font(.footnote)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.1)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                HStack {
                                    Text(sourceComment.content)
                                        .multilineTextAlignment(.leading)
                                        .font(.caption2)
                                    Spacer()
                                }
                                HStack {
                                    Text(Image(systemName: "hand.thumbsup"))
                                        .font(.footnote)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .foregroundColor(.secondary)
                                    Text("\(Int(sourceComment.likeCount)) | ")
                                        .font(.footnote)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .foregroundColor(.secondary)
                                    Text(Image(systemName: "arrowshape.turn.up.left"))
                                        .font(.footnote)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .foregroundColor(.secondary)
                                    Text(String(Int(sourceComment.replies?.replyCount ?? 0)))
                                        .font(.footnote)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                            }
                        }
                        Divider()
                    }
                        ForEach(0..<CommentsArray.count, id: \.self) { i in  // only count data you have
                            let comment = CommentsArray[i] // save yourself from excessive typing bro
                            if (comment.replies?.replyCount ?? 0) == 0 {
                            // is a reply branch or has no replies
                            Button {
                                // Nothing needed...
                            } label: {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("\(comment.author) | \(comment.publishedText)")
                                            .font(.footnote)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.1)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                    HStack {
                                        Text(comment.content)
                                            .multilineTextAlignment(.leading)
                                            .font(.caption2)
                                        Spacer()
                                    }
                                    HStack {
                                        Text(Image(systemName: "hand.thumbsup"))
                                            .font(.footnote)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                            .foregroundColor(.secondary)
                                        Text("\(Int(comment.likeCount)) | ")
                                            .font(.footnote)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                            .foregroundColor(.secondary)
                                        Text(Image(systemName: "arrowshape.turn.up.left"))
                                            .font(.footnote)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                            .foregroundColor(.secondary)
                                        Text(String(Int(comment.replies?.replyCount ?? 0)))
                                            .font(.footnote)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                }
                            }

                        } else {
                            // not a reply branch
                            NavigationLink {
                                // we need to be able to see subreplies
                                // TODO: Add subreplies
                                CommentsView(video: video, sourceComment: comment)
                            } label: {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("\(comment.author) | \(comment.publishedText)")
                                            .font(.footnote)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.1)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                    HStack {
                                        Text(comment.content)
                                            .multilineTextAlignment(.leading)
                                            .font(.caption2)
                                        Spacer()
                                    }
                                    HStack {
                                        Text(Image(systemName: "hand.thumbsup"))
                                            .font(.footnote)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                            .foregroundColor(.secondary)
                                        Text("\(Int(comment.likeCount)) | ")
                                            .font(.footnote)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                            .foregroundColor(.secondary)
                                        Text(Image(systemName: "arrowshape.turn.up.left"))
                                            .font(.footnote)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                            .foregroundColor(.secondary)
                                        Text(String(Int(comment.replies?.replyCount ?? 0)))
                                            .font(.footnote)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    if !stopRequests {
                        ProgressView()
                            .task {
                                if videoComments.continuation == nil {
                                    stopRequests = true
                                } else {
                                    let data = await inv.comments(id: video.videoID, continuation: videoComments.continuation)
                                    if data != nil {
                                        videoComments = data
                                        CommentsArray.append(contentsOf: videoComments.comments)
                                    } else {
                                        stopRequests = true
                                    }
                                }
                            }
                    } else {
                        Text("You're all wrapped up!")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Comment\(sourceComment == nil ? "s" : "")")
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .task {
                    // we'll load the data from here
                    if sourceComment != nil {
                        let data = await inv.comments(id: video.videoID, continuation: sourceComment.replies?.continuation)
                        if data != nil {
                            videoComments = data!
                        }
                    } else {
                        let data = await inv.comments(id: video.videoID)
                        if data != nil {
                            videoComments = data!
                        }
                    }
                    CommentsArray = videoComments.comments
                }
        }
    }
}

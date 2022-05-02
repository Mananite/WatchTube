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
    @State private var videoComments: InvComments! = nil // we make it optional and make it nil so we know it didnt load
    
    var body: some View {
        if videoComments != nil { // data exists, show it
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
                    ForEach(0..<videoComments.comments.count, id: \.self) { i in  // only count data you have
                        let comment = videoComments.comments[i] // save yourself from excessive typing bro
                        if sourceComment != nil {
                            // is a reply branch
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
                                            .lineLimit(5)
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
                                            .lineLimit(5)
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
                }
        }
    }
}

//
//  VideoListView.swift
//  WatchTube WatchKit Extension
//
//  Created by Hugo Mason on 24/04/2022.
//

import SwiftUI
import Invidious_Swift

struct SearchResultsView: View {
    
    var searchTerm: String
    
    @State private var isDoneLoading = false
    @State private var results = [InvSearchResult]()
       
       var body: some View {
           if results.isEmpty {
               VStack {
                   Spacer()
                   ProgressView()
                       .progressViewStyle(.circular)
                   Spacer()
                       .task {
                           let content = await inv.search(q: searchTerm, type: .all)
                           if content != nil {
                               results = content!
                           }
                           isDoneLoading = true
                       }
               }
           } else {
               ScrollView {
                   ForEach(0..<results.count, id: \.self) { i in
                       let item = results[i]
                       if item.type == "video" {
                           Video(title: item.title!, author: item.author, id: item.videoID!, url: item.videoThumbnails![0].url)
                       } else if item.type == "channel" {
                           Channel(author: item.author, url: URL(string: "https:\(item.authorThumbnails!.last!.url)")!, subs: item.subCount!, udid: item.authorID)
                       } else if item.type == "playlist" {
                           // TODO: Add playlist view
                       }
                   }
               }
               .navigationTitle("Results")
           }
       }
}

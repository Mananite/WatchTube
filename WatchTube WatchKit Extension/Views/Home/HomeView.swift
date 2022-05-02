//
//  HomeView.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 19/04/2022.
//

import SwiftUI
import Invidious_Swift
import SDWebImageSwiftUI

struct HomeView: View {
    
    @State private var finishedLoading = false
    @State private var trendingData = [InvTrendingVideo]()
        
    var body: some View {
        NavigationView {
            if finishedLoading == false {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                if trendingData.isEmpty {
                    VStack(spacing: 10) {
                        Text("An error has occurred.")
                        Button {
                            Task {
                                finishedLoading = false
                                let data = await inv.trending(cc: Locale.current.regionCode)
                                if data != nil {
                                    trendingData = data!
                                }
                                finishedLoading = true
                            }
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    }
                        .navigationTitle("Error")
                } else {
                    ScrollView{
                        LazyVStack {
                            ForEach(0..<trendingData.count, id: \.self) { i in
                                let video = trendingData[i]
                                Video(title: video.title, author: video.author, id: video.videoID, url: video.videoThumbnails[0].url)
                            }
                        }
                        .cornerRadius(10)
                        .navigationTitle("WatchTube")
                    }
                }
            }
        }
        .task {
            let data = await inv.trending(cc: Locale.current.regionCode)
            if data != nil {
                trendingData = data!
            }
            finishedLoading = true
        }
    }
}

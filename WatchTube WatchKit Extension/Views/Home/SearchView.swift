//
//  SearchView.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 19/04/2022.
//

import SwiftUI
import Invidious_Swift

struct SearchView: View {
    
    @State private var searchTerm: String = ""
    @State private var suggestions = [String]()
    @State private var recents: [String] = (UserDefaults.standard.stringArray(forKey: "SearchHistory") ?? [])
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchTerm)
                    .onAppear {
                        recents = UserDefaults.standard.stringArray(forKey: "SearchHistory") ?? []
                    }
                    .onSubmit {
                        Task {
                            let data = await inv.searchSuggestions(q: searchTerm)
                            if data != nil {
                                suggestions = data!.suggestions
                            }
                        }
                    }
                    .background(.black)
                    .cornerRadius(25)
                    .overlay(
                            ZStack {
                                HStack {
                                    if searchTerm == "" {
                                        Text("Search...")
                                            .foregroundColor(Color.gray)
                                            .opacity(0.5)
                                    } else {
                                        Text(searchTerm)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                }
                                .padding(.leading, 10)
                                .padding(.trailing, 5)
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(.sRGB, white: 0.08, opacity: 1), lineWidth: 2)
                                    .padding(1)
                            }
                                .background(.black)
                                .allowsHitTesting(false)
                        )
                ScrollView {
                    VStack {
                        if searchTerm != "" {
                            HStack {
                                Text("Suggestions")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            NavigationLink {
                                SearchResultsView(searchTerm: searchTerm)
                            } label: {
                                HStack {
                                    Text("\"\(searchTerm)\"")
                                        .multilineTextAlignment(.leading)
                                        .font(.caption)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.1)
                                    Spacer()
                                }
                            }
                            
                            if suggestions.count == 0 {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            } else {
                                ForEach(suggestions, id: \.self) { txt in
                                    NavigationLink {
                                        SearchResultsView(searchTerm: txt)
                                    } label: {
                                        HStack {
                                            Text(txt)
                                                .multilineTextAlignment(.leading)
                                                .font(.caption)
                                                .lineLimit(2)
                                                .minimumScaleFactor(0.1)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        } else {
                            HStack {
                                Text("Recents")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            
                            if recents.isEmpty {
                                Text("A tumbleweed tumbles...")
                                    .italic()
                                    .foregroundColor(.secondary)
                                    .font(.footnote)
                                    .padding(.top, 15)
                                    .brightness(-0.5)
                            }
                            ForEach(recents.reversed(), id: \.self) { txt in
                                NavigationLink {
                                    SearchResultsView(searchTerm: txt)
                                } label: {
                                    HStack {
                                        Text(txt)
                                            .multilineTextAlignment(.leading)
                                            .font(.caption)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.1)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

fileprivate struct SearchResultsView: View {
    
    var searchTerm: String
    
    @State private var isDoneLoading = false
    @State private var results = [InvSearchResult]()
       
       var body: some View {
           if !isDoneLoading {
               VStack {
                   Spacer()
                   ProgressView()
                       .progressViewStyle(.circular)
                   Spacer()
                       .task {
                           var kwh: [String] = UserDefaults.standard.stringArray(forKey: "SearchHistory") ?? []
                           if let index = kwh.firstIndex(of: searchTerm) {
                               kwh.remove(at: index)
                           }
                           kwh.append(searchTerm)
                           UserDefaults.standard.set(kwh, forKey: "SearchHistory")
                           let content = await inv.search(q: searchTerm, type: .all)
                           withAnimation {
                               if content != nil {
                                   results = content!
                               }
                               isDoneLoading = true
                           }
                       }
               }
           } else {
               if results.isEmpty {
                   VStack(spacing: 10) {
                       Text("An error has occurred.")
                       Button {
                           Task {
                               withAnimation {
                                   isDoneLoading = false
                               }
                               let content = await inv.search(q: searchTerm, type: .all)
                               withAnimation {
                                   if content != nil {
                                       results = content!
                                   }
                                   isDoneLoading = true
                               }
                           }
                       } label: {
                           Image(systemName: "arrow.triangle.2.circlepath")
                       }
                       .frame(width: 50, height: 50)
                       .clipShape(Circle())
                   }
                       .navigationTitle("Error")
               } else {
                   ScrollView {
                       ForEach(0..<results.count, id: \.self) { i in
                           let item = results[i]
                           if item.type == "video" {
                               Video(title: item.title!, author: item.author, id: item.videoID!, url: item.videoThumbnails![0].url)
                                   .task {
                                       await metadata.cacheVideoData(item.videoID!)
                                   }
                           } else if item.type == "channel" {
                               Channel(author: item.author, url: URL(string: "https:\(item.authorThumbnails!.last!.url)")!, subs: item.subCount!, udid: item.authorID)
                                   .task {
                                       await metadata.cacheChannelData(item.authorID)
                                   }
                           } else if item.type == "playlist" {
                               Playlist(title: item.title!, author: item.author, plid: item.playlistID!, thumb: item.playlistThumbnail!)
                           }
                       }
                   }
                   .transition(.fade)
                   .navigationTitle("Results")
            }
        }
    }
}

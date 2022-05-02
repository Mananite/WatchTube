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
                            ForEach(recents, id: \.self) { txt in
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

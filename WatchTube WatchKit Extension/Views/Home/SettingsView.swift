//
//  SettingsView.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 25/04/2022.
//

import SwiftUI
import Invidious_Swift

struct SettingsView: View {
    
    @State private var debugIsShown: Bool = false
    
    @State private var currentInstance: String = URL(string: UserDefaults.standard.string(forKey: "InvidiousInstanceURL") ?? "https://invidious.osi.kr")!.host!
    @State private var currentType: String = UserDefaults.standard.string(forKey: settingsKeys.trendingType) ?? "default"
    @AppStorage(settingsKeys.captionsFontSize) var captionsFontSize: Double = UserDefaults.standard.double(forKey: settingsKeys.captionsFontSize) >= 8 && UserDefaults.standard.double(forKey: settingsKeys.captionsFontSize) <= 18 ? UserDefaults.standard.double(forKey: settingsKeys.captionsFontSize) : 15
    @AppStorage("InvidiousInternalCaching") var cachingToggle = UserDefaults.standard.bool(forKey: "InvidiousInternalCaching")
    var body: some View {
        NavigationView {
            ScrollView {
                Group {
                    HStack {
                        Text("Instance")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    NavigationLink(destination: {
                        InstancesView()
                    }, label: {
                        HStack {
                            Text(currentInstance)
                            Spacer()
                            Text(Image(systemName: "chevron.right"))
                                .foregroundColor(.secondary)
                        }
                    })
                    .onAppear {
                        currentInstance = (URL(string: UserDefaults.standard.string(forKey: "InvidiousInstanceURL") ?? "https://invidious.osi.kr")?.host)!
                    }
                } // Instance Settings
                Group {
                    HStack {
                        Text("Home Page Content")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    NavigationLink(destination: {
                        HomePageType()
                    }, label: {
                        HStack {
                            Text(currentType.capitalizingFirstLetter())
                            Spacer()
                            Text(Image(systemName: "chevron.right"))
                                .foregroundColor(.secondary)
                        }
                    })
                    .onAppear {
                        currentType = UserDefaults.standard.string(forKey: settingsKeys.trendingType) ?? "default"
                    }
                } // Captions Font Size
                Group {
                    HStack {
                        Text("Caption Size")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    Slider(value: $captionsFontSize, in: 8...18) {}
                    Text("This is a sample caption!")
                        .font(.system(size: CGFloat(captionsFontSize)))
                        .animation(.easeInOut)
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                        .background(Color(.displayP3, red: 0, green: 0, blue: 0, opacity: 0.5))
                        .cornerRadius(5)
                        .allowsHitTesting(false)
                } // Home Page Content
                
                Group {
                    HStack {
                        Text("Debugging Tools")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.top, 10)
                    NavigationLink {
                        RebuildCache()
                    } label: {
                        HStack {
                            Text("Rebuild cache")
                            Spacer()
                            Text(Image(systemName: "chevron.right"))
                                .foregroundColor(.secondary)
                        }
                    }
                    Button {} label: {
                        Toggle(isOn: $cachingToggle) {
                            Text("InvWrapper Caching")
                                .minimumScaleFactor(0.1)
                                .lineLimit(1)
                        }
                    }

                } // debug settings
            }
            .navigationTitle("Settings")
        }
    }
}

fileprivate struct InstancesView: View {
    
    @State var instances = [String]()
    @State var isFinished: Bool = false
    @State var selected: String = (URL(string: UserDefaults.standard.string(forKey: "InvidiousInstanceURL") ?? "https://invidious.osi.kr")?.host)!
    
    var body: some View {
        if isFinished == true {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(0..<instances.count, id: \.self) { i in
                        let instance = instances[i]
                        Button {
                            Task {
                                selected = instance
                                let _ = await inv.setInstance(url: URL(string: "https://\(instance)")!, skipCheck: true)
                            }
                        } label: {
                            HStack {
                                Text(instance)
                                    .font(.footnote)
                                Spacer()
                                Text(Image(systemName: "checkmark"))
                                    .foregroundColor(Color.green)
                                    .font(.title3)
                                    .opacity(instance == selected ? 1 : 0)
                            }
                        }
                        .buttonStyle(.plain)
                        if instance != instances.last {
                            Divider()
                                .foregroundColor(Color(.sRGB, white: 0.1, opacity: 1))
                        }
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color(.sRGB, white: 0.15, opacity: 1))
                }
            }
            .navigationTitle("\(instances.count) instances")
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .task {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.invidious.io/instances.json")!)
                        isFinished = true
                        if let instancesList = try JSONSerialization.jsonObject(with: data) as? [[Any]] {
                            for instance in instancesList {
                                let name = instance[0] as! String
                                let info = instance[1] as! [String:Any]
                                if info["api"] as? Int == 1 && info["type"] as? String == "https" {
                                    instances.append(name)
                                }
                            }
                        } else {
                            isFinished = true
                        }
                    } catch {
                        isFinished = true
                    }
                }
        }
    }
} // Instances subview

fileprivate struct HomePageType: View {
    
    @AppStorage(settingsKeys.trendingType) private var selected: String = UserDefaults.standard.string(forKey: settingsKeys.trendingType) ?? "default"
    private var allTypes = ["default", "music", "gaming", "news", "movies", "curated"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(0..<allTypes.count, id: \.self) { i in
                    let type = allTypes[i]
                    Button {
                        Task {
                            selected = type
                        }
                    } label: {
                        HStack {
                            Text(type.capitalizingFirstLetter())
                                .font(.footnote)
                            Spacer()
                            Text(Image(systemName: "checkmark"))
                                .foregroundColor(Color.green)
                                .font(.title3)
                                .opacity(type == selected ? 1 : 0)
                        }
                    }
                    .buttonStyle(.plain)
                    if type != allTypes.last {
                        Divider()
                            .foregroundColor(Color(.sRGB, white: 0.1, opacity: 1))
                    }
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color(.sRGB, white: 0.15, opacity: 1))
            }
        }
            .navigationTitle("Types")
        }
} // Home page config subview

fileprivate struct RebuildCache: View {
    @State private var consentGiven: Bool = false
    @State private var title = ""
    @State private var progressBarCurrent: Double = 0
    @State private var progressBarMax: Double = 1
    @State private var isFinished: Bool = false
    
    var body: some View {
        if isFinished {
            VStack {
                Text("All finished!")
            }
        } else {
            if !consentGiven {
                if history.getHistory().count + liked.getLikes().count + subscriptions.getSubscriptions().count == 0 {
                    Text("There is no userdata to rebuild from.")
                } else {
                    VStack {
                        Text("Rebuilding cache will take some time")
                        Button {
                            consentGiven.toggle()
                        } label: {
                            Text("Okay")
                        }
                    }
                }
            } else {
                VStack {
                    Spacer()
                        .navigationTitle(title)
                    Text("Rebuilding...")
                    Text("\(Int(progressBarCurrent)) of \(Int(progressBarMax))")
                    ProgressView(value: progressBarCurrent, total: progressBarMax)
                        .tint(.accentColor)
                        .task {
                            progressBarMax = Double(history.getHistory().count + liked.getLikes().count + subscriptions.getSubscriptions().count)
                            try? FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Documents/videoCache/")
                            try? FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Documents/channelCache/")
                            
                            title="History"
                            for vid in history.getHistory() {
                                await metadata.cacheVideoData(vid, ignoreExisting: true)
                                progressBarCurrent += 1
                            }
                            title="Liked"
                            for vid in liked.getLikes() {
                                await metadata.cacheVideoData(vid, ignoreExisting: true)
                                progressBarCurrent += 1
                            }
                            title="Channels"
                            for channel in subscriptions.getSubscriptions() {
                                await metadata.cacheChannelData(channel, ignoreExisting: true)
                                progressBarCurrent += 1
                            }
                            for channel in subscriptions.getSubscriptions() {
                                let videos = metadata.getChannelData(channel, key: .videos) as? [String] ?? []
                                progressBarMax += Double(videos.count)
                                title=metadata.getChannelData(channel, key: .author) as! String
                                for video in videos {
                                    await metadata.cacheVideoData(video, doNotCacheRelated: true, ignoreExisting: true)
                                    progressBarCurrent += 1
                                }
                            }
                            progressBarCurrent = progressBarMax
                            isFinished.toggle()
                        }
                    ProgressView()
                }
            }
        }
    }
}

struct SettingsViewPreview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

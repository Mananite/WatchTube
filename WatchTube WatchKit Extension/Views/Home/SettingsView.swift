//
//  SettingsView.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 25/04/2022.
//

import SwiftUI
import Invidious_Swift

struct SettingsView: View {
    
    @State private var currentInstance: String = URL(string: UserDefaults.standard.string(forKey: "InvidiousInstanceURL") ?? "https://invidious.osi.kr")!.host!
    @State private var captionsFontSize: Double = UserDefaults.standard.double(forKey: settingsKeys.captionsFontSize)
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
                        Text("Captions Font Size")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    Slider(value: $captionsFontSize, in: 9...18) {
                        Text("idk how this looks")
                    }
                    Text("This is a sample caption!")
                        .font(.system(size: CGFloat(captionsFontSize)))
                        .animation(.easeInOut)
                        .lineLimit(5)
                        .multilineTextAlignment(.center)
                        .background(Color(.displayP3, red: 0, green: 0, blue: 0, opacity: 0.5))
                        .cornerRadius(5)
                        .allowsHitTesting(false)
                } // Captions Font Size
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
                                await inv.setInstance(url: URL(string: "https://\(instance)")!, skipCheck: true)
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

struct SettingsViewPreview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

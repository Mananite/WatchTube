//
//  CaptionsView.swift
//  WatchTube WatchKit Extension
//
//  Created by Hugo Mason on 24/04/2022.
//

import SwiftUI
import Invidious_Swift

struct CaptionsView: View {
    
    var video: InvVideo
    
    @State private var isFinished = false
    @State private var captionsData: InvCaptions! = nil
    @State private var selected = UserDefaults.standard.string(forKey: settingsKeys.preferredCaptionsLanguage) ?? ""
    
    var body: some View {
        if isFinished == true {
            if captionsData != nil {
                ScrollView {
                    VStack(spacing: 10) {
                        Button {
                            Task {
                                selected = ""
                                UserDefaults.standard.set(selected, forKey: settingsKeys.preferredCaptionsLanguage)
                            }
                        } label: {
                            HStack {
                                Text("None")
                                    .font(.footnote)
                                Spacer()
                                Text(Image(systemName: "checkmark"))
                                    .foregroundColor(Color.green)
                                    .font(.title3)
                                    .opacity("" == selected ? 1 : 0)
                            }
                        }
                        .buttonStyle(.plain)
                        Divider()
                            .foregroundColor(Color(.sRGB, white: 0.1, opacity: 1))
                        ForEach(0..<captionsData.captions.count, id: \.self) { i in
                            let caption = captionsData.captions[i]
                            
                            let real = caption.label
                            let label = caption.label.removingPercentEncoding!
                            Button {
                                Task {
                                    selected = real
                                    UserDefaults.standard.set(selected, forKey: settingsKeys.preferredCaptionsLanguage)
                                }
                            } label: {
                                HStack {
                                    Text(label)
                                        .font(.footnote)
                                    Spacer()
                                    Text(Image(systemName: "checkmark"))
                                        .foregroundColor(Color.green)
                                        .font(.title3)
                                        .opacity(real == selected ? 1 : 0)
                                }
                            }
                            .buttonStyle(.plain)
                            if real != captionsData.captions.last!.label {
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
                .navigationTitle("\(captionsData.captions.count) caption\(captionsData.captions.count == 1 ? "" : "s")")
            } else {
                VStack(spacing: 10) {
                    Text("An error has occurred.")
                    Button {
                        Task {
                            isFinished = false
                            let data = await inv.captions(id: video.videoID)
                            if data != nil {
                                captionsData = data!
                            }
                            isFinished = true
                        }
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                }
                    .navigationTitle("Error")
            }
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .task {
                    let data = await inv.captions(id: video.videoID)
                    if data != nil {
                        captionsData = data
                    }
                    isFinished = true
                }
        }
    }
}

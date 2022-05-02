//
//  OptionsView.swift
//  WatchTube WatchKit Extension
//
//  Created by Hugo Mason on 24/04/2022.
//

import SwiftUI
import Invidious_Swift

struct OptionsView: View {
    
    var video: InvVideo
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    NavigationLink {
                        InformationView(video: video)
                    } label: {
                        HStack {
                            Text(Image(systemName: "info.circle"))
                                .foregroundColor(Color.accentColor)
                                .font(.title3)
                            Text("Information")
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    Divider()
                        .foregroundColor(Color(.sRGB, white: 0.1, opacity: 1))

                    NavigationLink {
                        CaptionsView(video: video)
                    } label: {
                        HStack {
                            Text(Image(systemName: "captions.bubble"))
                                .foregroundColor(Color.accentColor)
                                .font(.title3)
                            Text("Captions")
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    Divider()
                        .foregroundColor(Color(.sRGB, white: 0.1, opacity: 1))

                    NavigationLink {
                        CommentsView(video: video)
                    } label: {
                        HStack {
                            Text(Image(systemName: "text.bubble"))
                                .foregroundColor(Color.accentColor)
                                .font(.title3)
                            Text("Comments")
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    Divider()
                        .foregroundColor(Color(.sRGB, white: 0.1, opacity: 1))
                    
                    NavigationLink {
                        QrCodeView(video: video)
                    } label: {
                        HStack {
                            Text(Image(systemName: "qrcode"))
                                .foregroundColor(Color.accentColor)
                                .font(.title3)
                            Text("Share QR")
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color(.sRGB, white: 0.15, opacity: 1))
                }
            }
        }
    }
}


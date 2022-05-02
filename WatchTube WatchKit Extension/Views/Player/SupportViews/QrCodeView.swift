//
//  QrCodeView.swift
//  WatchTube WatchKit Extension
//
//  Created by Hugo Mason on 24/04/2022.
//

import SwiftUI
import Invidious_Swift
import EFQRCode

struct QrCodeView: View {
    
    var video: InvVideo
    @State private var img: CGImage! = nil
    
    var body: some View {
        ScrollView {
            if img != nil {
                Image(uiImage: UIImage(cgImage: img!))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            Text("\(video.videoID)")
                .font(.footnote)
                .foregroundColor(Color(.sRGB, white: 0.1, opacity: 1))
                .onAppear {
                    if let image = EFQRCode.generate(
                        for: "https://youtu.be/\(video.videoID)",
                        backgroundColor: .black()!,
                        foregroundColor: CGColor(red: 0.906, green: 0.349, blue: 0.314, alpha: 1)
                    ) {
                        img = image
                    }
                }
        }
        .navigationTitle("QR Code")
    }
}

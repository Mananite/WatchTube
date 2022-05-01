//
//  ImageView.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 25/04/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageView: View {
    var image: UIImage! = nil
    var url: URL! = nil
    @Namespace private var namespace
    @State private var zoom: Double = WKInterfaceDevice.current().screenBounds.width
    @State private var min: Double = WKInterfaceDevice.current().screenBounds.width / 1.5
    @State private var max: Double = WKInterfaceDevice.current().screenBounds.width * 10
    @State private var step: Double = 30

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollView(.horizontal, showsIndicators: false) {
                if image != nil {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: zoom, alignment: .center)
                        .focusable(true)
                        .prefersDefaultFocus(true, in: namespace)
                        .digitalCrownRotation($zoom, from: min, through: max, by: step, sensitivity: .high, isContinuous: false, isHapticFeedbackEnabled: true)
                } else if url != nil {
                    WebImage(url: url)
                        .placeholder {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: zoom, alignment: .center)
                        .focusable(true)
                        .prefersDefaultFocus(true, in: namespace)
                        .digitalCrownRotation($zoom, from: min, through: max, by: step, sensitivity: .high, isContinuous: false, isHapticFeedbackEnabled: true)
                }
            }
                .focusable(false)
        }
            .focusable(false)
            .navigationTitle("Image")
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(image: UIImage(named: "WatchTubeDark")!)
    }
}

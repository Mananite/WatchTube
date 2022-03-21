//
//  hlsPlayer.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 10/02/2022.
//

import SwiftUI
import AVFoundation

class hlsPlayer: WKHostingController<playerView> {
    override var body: playerView {
        return playerView()
    }
    
    override func awake(withContext context: Any?) {
        history.addToHistory(id: UserDefaults.standard.string(forKey: hls.videoId)!)
    }
    
    override func willDisappear() {
        pop()
    }
}

//
//  PlayerView.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 24/04/2022.
//

import SwiftUI
import Invidious_Swift
import YouTubeKit
import AVKit
import AVFoundation

class av: ObservableObject {
    var subtitlesEnabled = false
    var subs: CaptionSet!
    var player = AVPlayer(url: UserDefaults.standard.url(forKey: "hls.streamUrl")!)
    var timeObserverToken: Any?
    var subtitleText = Caption(text: "", beginning: 0, end: 1)
    var isPaused = true
    var timeText = "-0:00"
    
    func main(video: InvVideo, subs: CaptionSet! = nil) {
        if subs != nil {self.subs = subs!}
        if UserDefaults.standard.string(forKey: settingsKeys.preferredCaptionsLanguage) ?? "" == "" {subtitlesEnabled = false} else {subtitlesEnabled = true}
        objectWillChange.send()
        if subtitlesEnabled == true && subs != nil {
            subtitleText = Caption(text: "\(subs.label)", beginning: 0, end: 5)
        }
        // the thing that periodically checks what subtitle should be displayed and changes subtitletext as needed
        let interval = CMTime(seconds: 0.2, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [self] time in
            let seconds: Double = CMTimeGetSeconds(time)
            let totalTime: Double = CMTimeGetSeconds((player.currentItem?.asset.duration)!)
            let currentRemaining = totalTime - seconds
            
            objectWillChange.send()
            if ((player.rate != 0) && (player.error == nil)) {
                isPaused = false
            } else {
                isPaused = true
            }
            if currentRemaining <= 0.6 {
                isPaused = true
            }
            if player.currentItem?.asset.duration != nil {
                let minutes = Int((currentRemaining.truncatingRemainder(dividingBy: 3600)) / 60)
                let seconds = Int(currentRemaining.truncatingRemainder(dividingBy: 60))
                timeText = "-\(minutes):\(seconds <= 9 && seconds >= 0 ? "0\(seconds)" : "\(seconds)")"
            }
            objectWillChange.send()
            if subtitlesEnabled == true {
                if self.subs != nil {
                    for subtitle in subs.captions {
                        if (seconds >= subtitle.beginning) && (seconds <= subtitle.end) {
                            subtitleText = subtitle
                            break
                        } else {continue}
                    }
                }
            }
        }
    }
}

struct PlayerView: View {
    
    @StateObject private var vm = av()
    
    @Binding var playerIsShowing: Bool
    
    var video: InvVideo
    var streams: [YouTubeKit.Stream]
    
    var body: some View {
        ZStack {
            VideoPlayer(player: vm.player, videoOverlay: {
                VStack {
                    Spacer()
                    if (vm.subtitlesEnabled == true) {
                        if (vm.subtitleText.end <= vm.player.currentTime().seconds) {
                            // the text wont display, the subtitle isnt declared to be seen here. do whatever
                        } else {
                            Text(vm.subtitleText.text)
                                .font(.system(size: 14))
                                .lineLimit(5)
                                .multilineTextAlignment(.center)
                                .background(Color(.displayP3, red: 0, green: 0, blue: 0, opacity: 0.5))
                                .cornerRadius(5)
                                .allowsHitTesting(false)
                        }
                    }
                }
            })
                .navigationBarHidden(!vm.isPaused)
                .navigationTitle(vm.timeText)
                .ignoresSafeArea()
                .onDisappear {
                    vm.player = AVPlayer()
                }
                .task {
                    if UserDefaults.standard.string(forKey: settingsKeys.preferredCaptionsLanguage) ?? "" != "" {
                        let subs = await video.captions.filter {$0.label == UserDefaults.standard.string(forKey: settingsKeys.preferredCaptionsLanguage) ?? ""}.first?.createCaptions()
                        if subs != nil {
                            vm.main(video: video, subs: subs!)
                        } else {
                            vm.main(video: video)
                        }
                    } else {
                        vm.main(video: video)
                    }
                }
//                .overlay(content: {
//                    VStack {
//                        HStack {
//                            if vm.isPaused == true {
//                                Button {
//                                    playerIsShowing = false
//                                } label: {
//                                    Text("Close")
//                                        .foregroundColor(.white)
//                                        .background(
//                                            RoundedRectangle(cornerRadius: 4)
//                                                .foregroundColor(.gray)
//                                                .brightness(-0.5)
//                                        )
//                                }
//                                .padding(.top, 8)
//                                .padding(.leading, 10)
//                                .buttonStyle(.plain)
//                            }
//                            Spacer()
//                        }
//                        Spacer()
//                    }
//                    .ignoresSafeArea()
//                })
//                .overlay(content: {
//                    VStack {
//                        HStack {
//                            Spacer()
//                            if vm.isPaused == true {
//                                Button {
//                                } label: {
//                                    Text(vm.timeText)
//                                        .foregroundColor(.white)
//                                        .background(
//                                            RoundedRectangle(cornerRadius: 4)
//                                                .foregroundColor(.gray)
//                                                .brightness(-0.5)
//                                        )
//                                }
//                                .padding(.top, 8)
//                                .padding(.trailing, 2)
//                                .buttonStyle(.plain)
//                            }
//                        }
//                        Spacer()
//                    }
//                })
        }
    }
}

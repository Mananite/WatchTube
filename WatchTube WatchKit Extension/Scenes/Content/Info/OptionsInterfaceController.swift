//
//  OptionsInterfaceController.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 22/03/2022.
//

import WatchKit
import Foundation
import Alamofire

class OptionsInterfaceController: WKInterfaceController {
    @IBOutlet weak var captionsLabel: WKInterfaceLabel!
    @IBOutlet weak var commentsSpinner: WKInterfaceImage!
    @IBOutlet weak var commentsLabel: WKInterfaceLabel!
    @IBOutlet weak var commentsButton: WKInterfaceButton!
    
    var data: [String:String] = [:]
    var videoId = ""
    var json: [String:Any] = [:]
    
    @IBAction func info() {
        pushController(withName: "InfoInterfaceController", context: data)
    }
    @IBAction func captions() {
        pushController(withName: "CaptionsInterfaceController", context: videoId)
    }
    @IBAction func comments() {
        pushController(withName: "CommentsInterfaceController", context: json)
    }
    @IBAction func qrcode() {
        pushController(withName: "QrCodeInterfaceController", context: videoId)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("Back")
        commentsLabel.setAlpha(0)
        
        data = context as! Dictionary<String, String>
        videoId = data["id"]!
        // Configure interface objects here.
        
        let commentspath = "https://\(UserDefaults.standard.string(forKey: settingsKeys.instanceUrl) ?? Constants.defaultInstance)/api/v1/comments/\(videoId)"
        AF.request(commentspath) { $0.timeoutInterval = 5 }.validate().responseJSON { res in
            switch res.result {
            case .success(let data):
                self.json = data as? [String:Any] ?? [:]
//                self.json["videoId"] = self.videoId
                /// turns out the api already has the video id in it lol
                if self.json["commentCount"] != nil {
                    let commentCount = self.json["commentCount"] as! Int
                    self.commentsButton.setEnabled(true)
                    self.commentsLabel.setText("\(commentCount.abbreviated) Comments")

                    self.animate(withDuration: 0.4) {
                        self.commentsSpinner.setAlpha(0)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                        self.commentsSpinner.setHidden(true)
                        self.commentsSpinner.stopAnimating()
                        self.animate(withDuration: 0.2) {
                            self.commentsLabel.setAlpha(1)
                        }
                    })
                } else {
                    self.commentsLabel.setText("Error")

                    self.animate(withDuration: 0.4) {
                        self.commentsSpinner.setAlpha(0)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                        self.commentsSpinner.setHidden(true)
                        self.commentsSpinner.stopAnimating()
                        self.animate(withDuration: 0.2) {
                            self.commentsLabel.setAlpha(1)
                        }
                    })
                }
            case .failure(_):
                self.commentsLabel.setText("Error")

                self.animate(withDuration: 0.4) {
                    self.commentsSpinner.setAlpha(0)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                    self.commentsSpinner.setHidden(true)
                    self.commentsSpinner.stopAnimating()
                    self.animate(withDuration: 0.2) {
                        self.commentsLabel.setAlpha(1)
                    }
                })
            }
        }
    }
    
    override func willActivate() {
        captionsLabel.setText(UserDefaults.standard.string(forKey: hls.captionsLangCode)?.capitalizingFirstLetter())
    }
}

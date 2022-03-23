//
//  InfoInterfaceController.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 12/12/2021.
//

import WatchKit
import Foundation
import Alamofire

class InfoInterfaceController: WKInterfaceController {
    
    var isLiked: Bool = false
    
    @IBOutlet weak var viewsIcon: WKInterfaceImage!
    @IBOutlet weak var likesIcon: WKInterfaceImage!
    @IBOutlet weak var authorIcon: WKInterfaceImage!
    @IBOutlet weak var uploadIcon: WKInterfaceImage!
    
    @IBOutlet weak var subsLabel: WKInterfaceLabel!
    @IBOutlet weak var subtitlePicker: WKInterfacePicker!
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var viewsLabel: WKInterfaceLabel!
    @IBOutlet weak var likesLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var authorLabel: WKInterfaceLabel!
    @IBOutlet weak var descriptionLabel: WKInterfaceLabel!

    var videoId: String = ""
    var udid: String = ""
    var quality: String = ""
    var language: [String] = []

    var videoDetails: Dictionary<String, Any> = [:]
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let data = context as! Dictionary<String, String>
        videoId = data["id"]!
        quality = data["quality"]!
        udid = meta.getVideoInfo(id: videoId, key: "channelId") as! String

        if liked.getLikes().contains(videoId) {
            isLiked = true
        } else {
            isLiked = false
        }

        self.titleLabel.setText(meta.getVideoInfo(id: videoId, key: "title") as? String ?? "")
        let likes = (meta.getVideoInfo(id: videoId, key: "likes") as! Double + (isLiked ? 1 : 0)).abbreviated
        let views = (meta.getVideoInfo(id: videoId, key: "views") as! Double).abbreviated
        self.likesLabel.setText("\(likes) Likes")
        self.viewsLabel.setText("\(views) Views")
        self.dateLabel.setText("Uploaded \(String(describing: meta.getVideoInfo(id: videoId, key: "publishedDate")))")
        self.authorLabel.setText("\(String(describing: meta.getVideoInfo(id: videoId, key: "channelName")))")
        self.descriptionLabel.setText("\(meta.getVideoInfo(id: videoId, key: "description"))")
        
        // Configure interface objects here.
    }
    
    @IBAction func openChannel(_ sender: Any) {
        if (meta.getChannelInfo(udid: udid, key: "name") as! String) == "???" {
            let download = WKAlertAction(title: "Load Now", style: .default) { [self] in meta.cacheChannelInfo(udid: udid)}
            let cancel = WKAlertAction(title: "Cancel", style: .cancel) {}
            presentAlert(withTitle: "Grab now?", message: "The data you requested is not on your device, get it now?", preferredStyle: .alert, actions: [download, cancel])
        } else {
            pushController(withName: "ChannelViewInterfaceController", context: meta.getVideoInfo(id: videoId, key: "channelId"))
        }
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

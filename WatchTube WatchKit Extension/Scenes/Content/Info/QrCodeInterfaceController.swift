//
//  QrCodeInterfaceController.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 22/03/2022.
//

import WatchKit
import Foundation
import EFQRCode

class QrCodeInterfaceController: WKInterfaceController {
    @IBOutlet weak var label: WKInterfaceLabel!
    @IBOutlet weak var img: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("Close")
        let videoId = context as? String ?? ""
        var final = ""
        if videoId != "" {
            final = "https://youtu.be/\(videoId)"
        } else {
            final = "An error occurred."
        }
        
        if let image = EFQRCode.generate(
            for: final
        ) {
            self.img.setImage(UIImage(cgImage: image))
            self.label.setText(videoId)
            animate(withDuration: 0.2) {
                self.img.setAlpha(1)
            }
        }
        
        // Configure interface objects here.
    }
}

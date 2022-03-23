//
//  CaptionsInterfaceController.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 22/03/2022.
//

import WatchKit
import Foundation
import Alamofire

class CaptionsInterfaceController: WKInterfaceController {
    @IBOutlet weak var img: WKInterfaceImage!
    @IBOutlet weak var subsTable: WKInterfaceTable!
    @IBOutlet weak var subsLabel: WKInterfaceLabel!
    
    var subtitles: [String] = []
    var selected = ""
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        selected = UserDefaults.standard.string(forKey: hls.captionsLangCode) ?? "off"
                
        let capspath = "https://\(UserDefaults.standard.string(forKey: settingsKeys.instanceUrl) ?? Constants.defaultInstance)/api/v1/videos/\(video.id)?fields=captions"
        AF.request(capspath) { $0.timeoutInterval = 5 }.responseJSON { res in
            self.animate(withDuration: 0.4) {
                self.img.setAlpha(0)
            }
            switch res.result {
                case .success(let data):
                let captions = (data as? Dictionary<String, Array<Any>>)!["captions"] ?? []
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.subsLabel.setText("Captions (\(captions.count))")
                }

                for item in captions {
                    let captionset = item as! Dictionary<String, String>
                    let labeltext = captionset["label"]!
                    self.subtitles.append(labeltext)
                }
                self.subtitles.insert("off", at: 0)
                
                if self.subtitles.firstIndex(of: self.selected) == nil {
                    self.selected = "off"
                }
                
                self.setupTable()
                
                case .failure(_):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.subsLabel.setText("Captions (error)")
                }
                self.subtitles.insert("off", at: 0)
                self.selected = "off"
                
                self.setupTable()
            }
        }
    }

    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        for i in 0..<subtitles.count {
            guard let row = subsTable.rowController(at: i) as? SubtitleRow else {
                return
            }
            row.tick.setHidden(true)
        }
        guard let selectedRow = subsTable.rowController(at: rowIndex) as? SubtitleRow else {
            return
        }
        selectedRow.tick.setHidden(false)
        selected = selectedRow.str
        
        UserDefaults.standard.set(selected, forKey: hls.captionsLangCode)
    }
    
    func setupTable() {
        subsTable.setNumberOfRows(subtitles.count, withRowType: "SubtitleRow")
        for i in 0..<subtitles.count {
            guard let row = subsTable.rowController(at: i) as? SubtitleRow else {
                return
            }
            row.label.setText(subtitles[i].capitalizingFirstLetter())
            row.str = subtitles[i]
            if subtitles[i] == selected {
                row.tick.setHidden(false)
            } else {
                row.tick.setHidden(true)
            }
            if i == subtitles.count - 1 {
                row.sep.setHidden(true)
            }
        }
    }
}

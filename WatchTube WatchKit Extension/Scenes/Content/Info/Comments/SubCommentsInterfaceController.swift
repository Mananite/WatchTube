//
//  SubCommentsInterfaceController.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 23/03/2022.
//

import WatchKit
import Foundation
import Alamofire

class SubCommentsInterfaceController: WKInterfaceController {
    @IBOutlet weak var img: WKInterfaceImage!
    @IBOutlet weak var subCommentsTable: WKInterfaceTable!
    
    var isBusy = false
    
    var comments: [comment] = []
    var videoId = ""
    var continuation = "fresh"
    var source: comment = comment(authorName: "", authorId: "", authorImg: "", replyCount: 0, likesCount: 0, replyContinuation: "", content: "", publishedCode: 0, publishedText: "", commentId: "", videoId: "")
    
    @IBOutlet weak var originalAuth: WKInterfaceLabel!
    @IBOutlet weak var originalBody: WKInterfaceLabel!
    @IBOutlet weak var originalLikes: WKInterfaceLabel!
    @IBOutlet weak var originalReplies: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        source = context as! comment
        videoId = source.videoId
        
        originalAuth.setText("\(source.authorName) | \(source.publishedText)")
        originalBody.setText(source.content)
        originalLikes.setText(String(source.likesCount))
        originalReplies.setText(String(source.replyCount))
        
        if continuation == "fresh" {
            continuation = source.replyContinuation
        }
        
        isBusy = true
        self.img.setHidden(false)
        
        if continuation == "" {
            self.isBusy = false
            self.img.setHidden(true)
            return
        }

        let commentspath = "https://\(UserDefaults.standard.string(forKey: settingsKeys.instanceUrl) ?? Constants.defaultInstance)/api/v1/comments/\(videoId)?continuation=\(continuation)"
        AF.request(commentspath) {$0.timeoutInterval = 5}.validate().responseJSON { res in
            switch res.result {
            case .success(let data):
                let json = data as! [String:Any]
                let cmnts = json["comments"] as! [[String:Any]]
                self.continuation = json["continuation"] as? String ?? ""
                for cmnt in cmnts {
                    let auth = cmnt["author"] as! String
                    let authId = cmnt["authorId"] as! String
                    let authImg = (cmnt["authorThumbnails"] as! [[String:Any]]).last?["url"] as! String
                    let content = cmnt["content"] as! String
                    let pubCode = cmnt["published"] as! Double
                    let pubText = cmnt["publishedText"] as! String
                    let commentId = cmnt["commentId"] as! String
                    var replies = 0
                    var continuation = ""
                    if cmnt["replies"] != nil {
                        replies = (cmnt["replies"] as! [String:Any])["replyCount"] as! Int
                        continuation = (cmnt["replies"] as! [String:Any])["continuation"] as! String
                    }
                    let likes = cmnt["likeCount"] as! Int
                    let final = comment(authorName: auth, authorId: authId, authorImg: authImg, replyCount: replies, likesCount: likes, replyContinuation: continuation, content: content, publishedCode: pubCode, publishedText: pubText, commentId: commentId, videoId: self.source.videoId)
                    self.comments.append(final)
                }
                
                self.subCommentsTable.setNumberOfRows(self.comments.count, withRowType: "SubCommentsRow")
                self.setupTable()
                self.isBusy = false
                self.img.setHidden(true)
            case .failure(let error):
                self.isBusy = false
                self.img.setHidden(true)
                print(error)
            }
        }

        // Configure interface objects here.
    }

    func setupTable() {
        self.subCommentsTable.setNumberOfRows(self.comments.count, withRowType: "SubCommentsRow")
        for i in 0..<self.comments.count {
            guard let row = self.subCommentsTable.rowController(at: i) as? SubCommentsRow else {
                return
            }
            let comment = self.comments[i]
            row.authLabel.setText("\(comment.authorName) | \(comment.publishedText)")
            row.subBody.setText(comment.content)
            row.likesCount.setText(String(comment.likesCount))
            row.replyCount.setText(String(comment.replyCount))
            row.contextData = comment
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        guard let selected = subCommentsTable.rowController(at: rowIndex) as? SubCommentsRow else {
            return
        }
        pushController(withName: "SubCommentsInterfaceController", context: selected.contextData)
    }
    
    override func interfaceOffsetDidScrollToBottom() {
        if isBusy == true {return}
        self.awake(withContext: source)
    }
}

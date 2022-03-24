//
//  CommentsInterfaceController.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 23/03/2022.
//

import WatchKit
import Foundation
import Alamofire

struct comment {
    let authorName: String
    let authorId: String
    let authorImg: String
    let replyCount: Int
    let likesCount: Int
    let replyContinuation: String
    let content: String
    let publishedCode: Double
    let publishedText: String
    let commentId: String
    let videoId: String
}

class CommentsInterfaceController: WKInterfaceController {
    @IBOutlet weak var img: WKInterfaceImage!
    @IBOutlet weak var commentsTable: WKInterfaceTable!
    
    var json: [String:Any] = [:]
    var videoId = ""
    var continuation = "fresh"
    var source: comment = comment(authorName: "", authorId: "", authorImg: "", replyCount: 0, likesCount: 0, replyContinuation: "", content: "", publishedCode: 0, publishedText: "", commentId: "", videoId: "")
    var isBusy = false
    
    var comments: [comment] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        json = context as! [String:Any]
        videoId = json["videoId"] as! String
        let cmnts = json["comments"] as! [[String:Any]]
        
        continuation = json["continuation"] as! String
        
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
            let final = comment(authorName: auth, authorId: authId, authorImg: authImg, replyCount: replies, likesCount: likes, replyContinuation: continuation, content: content, publishedCode: pubCode, publishedText: pubText, commentId: commentId, videoId: videoId)
            comments.append(final)
        }
        
        setupTable()
        // Configure interface objects here.
    }

    func setupTable() {
        commentsTable.setNumberOfRows(comments.count, withRowType: "CommentsRow")
        for i in 0..<comments.count {
            guard let row = commentsTable.rowController(at: i) as? CommentsRow else {
                return
            }
            let comment = comments[i]
            row.authorLabel.setText("\(comment.authorName) | \(comment.publishedText)")
            row.contentBody.setText(comment.content)
            row.likesCountLabel.setText(String(comment.likesCount))
            row.replyCountLabel.setText(String(comment.replyCount))
            row.contextData = comments[i]
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        guard let selected = commentsTable.rowController(at: rowIndex) as? CommentsRow else {
            return
        }
        pushController(withName: "SubCommentsInterfaceController", context: selected.contextData)
    }
    
    override func interfaceOffsetDidScrollToBottom() {
        egg(context: source)
    }
    
    
    
    func egg(context: Any?) {
        source = context as! comment

        if continuation == "fresh" {
            continuation = source.replyContinuation
        }
        
        isBusy = true
        self.img.setHidden(false)

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
                
                self.commentsTable.setNumberOfRows(self.comments.count, withRowType: "commentsTable")
                self.setupTable()
                self.isBusy = false
                self.img.setHidden(true)

            case .failure(let error):
                self.isBusy = false
                self.img.setHidden(true)

                print(error)
            }
        }
    }
}

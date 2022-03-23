//
//  CommentsInterfaceController.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 23/03/2022.
//

import WatchKit
import Foundation

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
    @IBOutlet weak var commentsTable: WKInterfaceTable!
    
    var json: [String:Any] = [:]
    var videoId = ""
    
    var comments: [comment] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        json = context as! [String:Any]
        videoId = json["videoId"] as! String
        let cmnts = json["comments"] as! [[String:Any]]
        
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
        let data = selected.contextData
        if data?.replyContinuation == "" {
            return
        }
        pushController(withName: "SubCommentsInterfaceController", context: selected.contextData)
    }
}

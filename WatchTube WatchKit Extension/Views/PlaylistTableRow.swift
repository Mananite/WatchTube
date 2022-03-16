//
//  PlaylistTableRow.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 30/01/2022.
//

import WatchKit

class PlaylistTableRow: NSObject {
    // used for videos in the playlist videos screen
    @IBOutlet weak var playlistItemTitle: WKInterfaceLabel!
    @IBOutlet weak var playlistItemChannel: WKInterfaceLabel!
    @IBOutlet weak var playlistItemThumbnail: WKInterfaceImage!
    var videoId: String!
}

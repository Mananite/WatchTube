//
//  Caching.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 05/05/2022.
//

import Foundation
import Invidious_Swift

class metadata {
    class func cacheVideoData(_ id: String, doNotCacheRelated: Bool = false) async {
        
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/videoCache/\(id)") {return}
        
        let videoInfo = await inv.video(id: id)
        
        if videoInfo == nil {return}
        var data: [String: Any] = [:]
        
        data["title"] = videoInfo!.title as String
        data["author"] = videoInfo!.author as String
        data["authorId"] = videoInfo!.authorID as String
        data["thumbnail"] = videoInfo!.videoThumbnails[0].url as String
        let ids: [String] = {
            var ids = [String]()
            for video in videoInfo!.recommendedVideos {
                ids.append(video.videoID)
            }
            return ids
        }()
        data["related"] = ids
        
        do {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent("videoCache/"+id)
                try FileManager.default.createDirectory(at: dir.appendingPathComponent("videoCache"), withIntermediateDirectories: true)
                //writing
                NSDictionary(dictionary: data).write(to: fileURL, atomically: true)
            }
        } catch {debugPrint(error)}
        
        if !doNotCacheRelated {
            for relatedIds in ids {
                let videoInfo = await inv.video(id: relatedIds)
                
                if videoInfo == nil {return}
                var data: [String: Any] = [:]
                
                data["title"] = videoInfo!.title as String
                data["author"] = videoInfo!.author as String
                data["thumbnail"] = videoInfo!.videoThumbnails[0].url as String
                data["id"] = videoInfo!.videoID as String
                let ids: [String] = {
                    var ids = [String]()
                    for video in videoInfo!.recommendedVideos {
                        ids.append(video.videoID)
                    }
                    return ids
                }()
                data["related"] = ids
                
                do {
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = dir.appendingPathComponent("videoCache/"+id)
                        try FileManager.default.createDirectory(at: dir.appendingPathComponent("videoCache"), withIntermediateDirectories: true)
                        //writing
                        NSDictionary(dictionary: data).write(to: fileURL, atomically: true)
                    }
                } catch {debugPrint(error)}
            }
        }
    }
    
    class func cacheChannelData(_ udid: String) async {
        
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/channelCache/\(udid)") {return}
        
        let channelInfo = await inv.channel(udid: udid)
        
        if channelInfo == nil {return}
        var data: [String: Any] = [:]
        
        data["author"] = channelInfo!.author as String
        data["thumbnail"] = channelInfo!.authorThumbnails.last!.url as String
        data["subscribers"] = channelInfo!.subCount as Double
        let videos: [String] = {
            var ids = [String]()
            for vid in channelInfo!.latestVideos {
                ids.append(vid.videoID)
            }
            return ids
        }()
        data["videos"] = videos
        do {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent("channelCache/"+udid)
                try FileManager.default.createDirectory(at: dir.appendingPathComponent("channelCache"), withIntermediateDirectories: true)
                //writing
                NSDictionary(dictionary: data).write(to: fileURL, atomically: true)
            }
        } catch {debugPrint(error)}
        for id in videos {
            await self.cacheVideoData(id, doNotCacheRelated: true)
        }
    }
    
    class func getVideoData(_ id: String, key: videoDataKeys) -> Any! {
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/videoCache/\(id)") == false {
            return nil
        }
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // attach the rest of the path
            let fileURL = dir.appendingPathComponent("videoCache/"+id)
            if let data = NSDictionary(contentsOf: fileURL) {
                return data[key.rawValue]
            }
        }
        return nil
    }
    
    class func getChannelData(_ udid: String, key: channelDataKeys) -> Any! {
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/channelCache/\(udid)") == false {
            return nil
        }
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // attach the rest of the path
            let fileURL = dir.appendingPathComponent("channelCache/"+udid)
            if let data = NSDictionary(contentsOf: fileURL) {
                return data[key.rawValue]
            }
        }
        return nil
    }
}

enum videoDataKeys: String {
    case title = "title"
    case author = "author"
    case authorId = "authorId"
    case thumbnail = "thumbnail"
    case related = "related"
}

enum channelDataKeys: String {
    case author = "author"
    case thumbnail = "thumbnail"
    case subscribers = "subscribers"
    case videos = "videos"
}

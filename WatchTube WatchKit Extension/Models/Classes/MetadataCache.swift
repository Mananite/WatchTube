//
//  cool code stuffs wholesome.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 27/12/2021.
//

import Foundation
import Alamofire

class meta {
    class func cacheVideoInfo(id: String) {
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/videoCache/\(id)") {return}
        
        let path = "https://\(UserDefaults.standard.string(forKey: settingsKeys.instanceUrl) ?? Constants.defaultInstance)/api/v1/videos/\(id)"
        AF.request(path).responseJSON { response in
            switch response.result {
            case .success(let json):
                let videoDetails = json as! Dictionary<String, Any>
                var data = [String: Any]()
                
                if (videoDetails["error"] != nil) {return}
                
                data["title"] = videoDetails["title"] as? String
                data["channelId"] = videoDetails["authorId"] as? String
                data["channelName"] = videoDetails["author"] as? String
                data["thumbnail"] = (videoDetails["videoThumbnails"] as! Array<Dictionary<String, Any>>)[0]["url"] as! String
                data["likes"] = videoDetails["likeCount"] as? Double
                data["description"] = videoDetails["description"] as? String
                data["views"] = videoDetails["viewCount"] as? Double
                data["category"] = videoDetails["genre"] as? String
                data["lengthSeconds"] = videoDetails["lengthSeconds"] as? String
                data["related_videos"] = videoDetails["recommendedVideos"] ?? []
//                data["related_videos"] = videoDetails["recommendedVideos"] this causes meta to not save, causes nilErrors
                let date = Date(timeIntervalSince1970: (videoDetails["published"] as? Double)!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
                dateFormatter.timeZone = .current
                data["publishedDate"] = dateFormatter.string(from: date)
                
                do {
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = dir.appendingPathComponent("videoCache/"+id)
                        try FileManager.default.createDirectory(at: dir.appendingPathComponent("videoCache"), withIntermediateDirectories: true)
                        //writing
                        NSDictionary(dictionary: data).write(to: fileURL, atomically: true)
                    }
                } catch {debugPrint(error)}
                
                let array = videoDetails["recommendedVideos"] as? [Any] ?? []
                for vid in array {
                    let videoData = vid as! Dictionary<String,Any>
                    let vidId = videoData["videoId"] as! String
                    let relatedpath = "https://\(UserDefaults.standard.string(forKey: settingsKeys.instanceUrl) ?? Constants.defaultInstance)/api/v1/videos/\(vidId)"
                    AF.request(relatedpath).responseJSON { response in
                        switch response.result {
                        case .success(let json):
                            let videoDetails = json as! Dictionary<String, Any>
                            var data = [String: Any]()
                            
                            if (videoDetails["error"] != nil) {return}
                            
                            data["title"] = videoDetails["title"] as? String
                            data["channelId"] = videoDetails["authorId"] as? String
                            data["channelName"] = videoDetails["author"] as? String
                            data["thumbnail"] = (videoDetails["videoThumbnails"] as! Array<Dictionary<String, Any>>)[0]["url"] as! String
                            data["likes"] = videoDetails["likeCount"] as? Double
                            data["description"] = videoDetails["description"] as? String
                            data["views"] = videoDetails["viewCount"] as? Double
                            data["category"] = videoDetails["genre"] as? String
                            data["lengthSeconds"] = videoDetails["lengthSeconds"] as? String
                            data["related_videos"] = videoDetails["recommendedVideos"] ?? []
            //                data["related_videos"] = videoDetails["recommendedVideos"] this causes meta to not save, causes nilErrors
                            let date = Date(timeIntervalSince1970: (videoDetails["published"] as? Double)!)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
                            dateFormatter.timeZone = .current
                            data["publishedDate"] = dateFormatter.string(from: date)
                            
                            do {
                                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                                    let relatedFileURL = dir.appendingPathComponent("videoCache/"+vidId)
                                    try FileManager.default.createDirectory(at: dir.appendingPathComponent("videoCache"), withIntermediateDirectories: true)
                                    //writing
                                    NSDictionary(dictionary: data).write(to: relatedFileURL, atomically: true)
                                }
                            } catch {debugPrint(error)}
                        case .failure(let error):
                            debugPrint(error)
                        }
                    }
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    class func cacheSingleVideo(id: String) {
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/videoCache/\(id)") {return}
        
        let path = "https://\(UserDefaults.standard.string(forKey: settingsKeys.instanceUrl) ?? Constants.defaultInstance)/api/v1/videos/\(id)"
        AF.request(path).responseJSON { response in
            switch response.result {
            case .success(let json):
                let videoDetails = json as! Dictionary<String, Any>
                var data = [String: Any]()
                
                if (videoDetails["error"] != nil) {return}
                
                data["title"] = videoDetails["title"] as? String
                data["channelId"] = videoDetails["authorId"] as? String
                data["channelName"] = videoDetails["author"] as? String
                data["thumbnail"] = (videoDetails["videoThumbnails"] as! Array<Dictionary<String, Any>>)[0]["url"] as! String
                data["likes"] = videoDetails["likeCount"] as? Double
                data["description"] = videoDetails["description"] as? String
                data["views"] = videoDetails["viewCount"] as? Double
                data["category"] = videoDetails["genre"] as? String
                data["lengthSeconds"] = videoDetails["lengthSeconds"] as? String
                data["related_videos"] = videoDetails["recommendedVideos"] ?? []
//                data["related_videos"] = videoDetails["recommendedVideos"] this causes meta to not save, causes nilErrors
                let date = Date(timeIntervalSince1970: (videoDetails["published"] as? Double)!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
                dateFormatter.timeZone = .current
                data["publishedDate"] = dateFormatter.string(from: date)
                data["publishedTimestamp"] = videoDetails["published"] as? Double
                
                do {
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = dir.appendingPathComponent("videoCache/"+id)
                        try FileManager.default.createDirectory(at: dir.appendingPathComponent("videoCache"), withIntermediateDirectories: true)
                        //writing
                        NSDictionary(dictionary: data).write(to: fileURL, atomically: true)
                    }
                } catch {debugPrint(error)}
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // if you cant read this line, its a function in a class (made for superbro)
    class func getVideoInfo(id: String, key: String? = nil) -> Any {
        // id is the id of the video, is ofc required
        //     and key is optional, gets key from meta file for you if you want
        
        // check if meta file exists
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/videoCache/\(id)") == false {
            // file doesnt exist, quickly get the data now
            self.cacheVideoInfo(id: id)
        }
        
        // file exists, get file path url for doc dir
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // attach the rest of the path
            let fileURL = dir.appendingPathComponent("videoCache/"+id)

            // load file as nsdictionary
            if let data = NSDictionary(contentsOf: fileURL) {
                // if key was provided...
                if (key != nil) {
                    // ...check if the key exists in the dictionary. if it exists...
                    if data[key!] != nil {
                        // ...return the key's value
                        return data[key!]!
                    } else {
                        // ...return the entire data structure
                        return data as Any
                    }
                } else {
                    // key was not provided. return the entire data structure
                    return data as Any
                }
            } else {
                return "???"
            }
        }
        // wtf happened
        return "???"
    }
    
    
    
    
    
    
    class func cacheChannelInfo(udid: String) {
        let path = "https://\(UserDefaults.standard.string(forKey: settingsKeys.instanceUrl) ?? Constants.defaultInstance)/api/v1/channels/\(udid)"
        AF.request(path).responseJSON { response in
            switch response.result {
            case .success(let json):
                let channelDetails = json as! Dictionary<String, Any>
                
                if channelDetails["error"] != nil {
                    break
                }
                var data = [String: Any]()
                data["name"] = channelDetails["author"] as? String
                data["udid"] = channelDetails["authorId"] as? String
                if (channelDetails["authorBanners"] as! Array<Any>).isEmpty {
                    data["banner"] = "https://yt3.ggpht.com/Ibexi5OCdDM15HGOs2FbuHLA_wL_Nh37qQM9uKdCeU5jf1lI-kJ_LeeUaJerGC9iCv5xXn15EQ=w2560-fcrop64=1,00005a57ffffa5a8-k-c0xffffffff-no-nd-rj"
                } else {
                    data["banner"] = (channelDetails["authorBanners"] as! Array<Dictionary<String, Any>>)[(channelDetails["authorBanners"] as! Array<Dictionary<String, Any>>).count - 1]["url"] as! String
                }
                data["thumbnail"] = (channelDetails["authorThumbnails"] as! Array<Dictionary<String, Any>>)[(channelDetails["authorThumbnails"] as! Array<Dictionary<String, Any>>).count - 1]["url"] as! String
                data["subscribers"] = channelDetails["subCount"] as! Double
                data["views"] = channelDetails["totalViews"] as! Double
                data["description"] = channelDetails["description"] as! String
                data["videos"] = channelDetails["latestVideos"] as! Array<Dictionary<String, Any>>
                
                var array: Array<Dictionary<String,String>> = []
                for channel in channelDetails["relatedChannels"] as! Array<Dictionary<String, Any>> {
                    var dict: [String:String]
                    dict = [
                        "name": channel["author"] as! String,
                        "udid": channel["authorId"] as! String,
                        "thumbnail": (channelDetails["authorThumbnails"] as! Array<Dictionary<String, Any>>)[(channelDetails["authorThumbnails"] as! Array<Dictionary<String, Any>>).count - 1]["url"] as! String
                    ]
                    array.append(dict)
                }
                data["relatedChannels"]=array
                
                let date = Date(timeIntervalSince1970: (channelDetails["joined"] as? Double)!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
                dateFormatter.timeZone = .current
                data["joined"] = dateFormatter.string(from: date)
                
                do {
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = dir.appendingPathComponent("channelCache/"+udid)
                        try FileManager.default.createDirectory(at: dir.appendingPathComponent("channelCache"), withIntermediateDirectories: true)
                        //writing
                        NSDictionary(dictionary: data).write(to: fileURL, atomically: true)
                    }
                } catch {debugPrint(error)}
                
                //for channel in channelDetails["relatedChannels"] as! Array<Dictionary<String, Any>> {
                //    meta.cacheChannelInfo(udid: channel["authorId"] as! String)
                //}
                // this could go on forever lmao why did i do this
                
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // if you cant read this line, its a function in a class (made for superbro)
    class func getChannelInfo(udid: String, key: String? = nil) -> Any {
        // id is the id of the video, is ofc required
        //     and key is optional, gets key from meta file for you if you want
        
        // check if meta file exists
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/channelCache/\(udid)") == false {
            // file doesnt exist, quickly get the data now
            self.cacheChannelInfo(udid: udid)
        }
        
        // file exists, get file path url for doc dir
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // attach the rest of the path
            let fileURL = dir.appendingPathComponent("channelCache/"+udid)

            // load file as nsdictionary
            if let data = NSDictionary(contentsOf: fileURL) {
                // if key was provided...
                if (key != nil) {
                    // ...check if the key exists in the dictionary. if it exists...
                    if data[key!] != nil {
                        // ...return the key's value
                        return data[key!]!
                    } else {
                        // ...return the entire data structure
                        return data as Any
                    }
                } else {
                    // key was not provided. return the entire data structure
                    return data as Any
                }
            } else {
                return "???"
            }
        }
        // wtf happened
        return "???"
    }
}

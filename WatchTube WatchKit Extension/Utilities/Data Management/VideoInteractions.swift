//
//  VideoInteractions.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 24/04/2022.
//

import Foundation

class subscriptions {
    class func getSubscriptions() -> Array<String> {
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/subscriptions.json") {
            if let array = NSArray(contentsOf: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/subscriptions.json")) {
                return array as? Array<String> ?? []
            } else {
                NSArray(array: []).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/subscriptions.json"), atomically: true)
                return []
            }
        } else {
            NSArray(array: []).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/subscriptions.json"), atomically: true)
            return []
        }
    }
    
    class func unsubscribe(udid: String) {
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/subscriptions.json") == false {return}
        if let array = NSArray(contentsOf: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/subscriptions.json")) {
            var mutable = array as! Array<String>
            while mutable.contains(udid) {
                let index = mutable.firstIndex(of: udid)
                mutable.remove(at: index!)
            }
            NSArray(array: mutable).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/subscriptions.json"), atomically: true)
        }
    }
    
    class func subscribe(udid: String) {
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/subscriptions.json") == false {
            NSArray(array: []).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/subscriptions.json"), atomically: true)
        }
        if let array = NSArray(contentsOf: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/subscriptions.json")) {
            var mutable = array as! Array<String>
            if mutable.contains(udid) {return} else {
                mutable.append(udid)
            }
            NSArray(array: mutable).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/subscriptions.json"), atomically: true)
        }
    }
    
//    class func sortInternal() {
//        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/subscriptions.json") == false {
//            NSArray(array: []).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/subscriptions.json"), atomically: true)
//        }
//        if let array = NSArray(contentsOf: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/subscriptions.json")) {
//            var mutable = array as! Array<String>
//            var withnames: Array<Dictionary<String, String>> = []
//            
//            for udid in mutable {
//                var data: Dictionary<String, String> = [:]
//                data["name"] = meta.getChannelInfo(udid: udid, key: "name") as? String
//                data["udid"] = udid
//                
//                withnames.append(data)
//            }
//            
//            withnames.sort(by: {$0["name"]!.lowercased() < $1["name"]!.lowercased()})
//            
//            mutable.removeAll()
//            for item in withnames {
//                mutable.append(item["udid"]!)
//            }
//            
//            NSArray(array: mutable).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/subscriptions.json"), atomically: true)
//        }
//    }
}

class liked {
    class func getLikes() -> Array<String> {
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/likes.json") {
            if let array = NSArray(contentsOf: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/likes.json")) {
                return array as? Array<String> ?? []
            } else {
                NSArray(array: []).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/likes.json"), atomically: true)
                return []
            }
        } else {
            NSArray(array: []).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/likes.json"), atomically: true)
            return []
        }
    }
    
    class func unlike(id: String) {
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/likes.json") == false {return}
        if let array = NSArray(contentsOf: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/likes.json")) {
            var mutable = array as! Array<String>
            while mutable.contains(id) {
                let index = mutable.firstIndex(of: id)
                mutable.remove(at: index!)
            }
            NSArray(array: mutable).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/likes.json"), atomically: true)
        }
    }
    
    class func like(id: String) {
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/likes.json") == false {
            NSArray(array: []).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/likes.json"), atomically: true)
        }
        if let array = NSArray(contentsOf: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/likes.json")) {
            var mutable = array as! Array<String>
            if mutable.contains(id) {return} else {
                mutable.reverse()
                mutable.append(id)
                mutable.reverse()
            }
            NSArray(array: mutable).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/likes.json"), atomically: true)
        }
    }
}

class history {
    class func getHistory() -> Array<String> {
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/history.json") {
            if let array = NSArray(contentsOf: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/history.json")) {
                return (array as? Array<String> ?? []).reversed()
            } else {
                NSArray(array: []).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/history.json"), atomically: true)
                return []
            }
        } else {
            NSArray(array: []).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/history.json"), atomically: true)
            return []
        }
    }

    class func removeVideoAtIndex(index: Int) {
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/history.json") == false {return}
        if let array = NSArray(contentsOf: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/history.json")) {
            var mutable = array as! Array<String>
            mutable = mutable.reversed()
            mutable.remove(at: index)
            mutable = mutable.reversed()
            NSArray(array: mutable).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/history.json"), atomically: true)
        }
    }
    
    class func removeLastVideo(id: String) {
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/history.json") == false {return}
        if let array = NSArray(contentsOf: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/history.json")) {
            var mutable = array as! Array<String>
            let index = mutable.firstIndex(of: id)
            if index != nil {
                mutable.remove(at: index!)
            }
            NSArray(array: mutable).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/history.json"), atomically: true)
        }
    }
    
    class func addToHistory(id: String) {
        if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/history.json") == false {
            NSArray(array: []).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/history.json"), atomically: true)
        }
        if let array = NSArray(contentsOf: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/history.json")) {
            var mutable = array as! Array<String>
            if mutable.count != 0 {if mutable.last!.contains(id) {return}}
            mutable.append(id)
            NSArray(array: mutable).write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/history.json"), atomically: true)
        }
    }
}

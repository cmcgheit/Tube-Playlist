//
//  YouTubeModel.swift
//  Tube-Playlist
//
//  Created by C McGhee on 2/23/17.
//  Copyright © 2017 C McGhee. All rights reserved.
//

import UIKit
import SwiftyJSON

class YouTubeModel: NSObject {

    var playlistID: String?
    var videoID: String?
    var title: String?
    var descr: String?
    var thumbnail: String?
    
    override init () {
        playlistID = ""
        videoID = ""
        title = ""
        descr = ""
        thumbnail = ""
    }
    
    required init(dataJSON: JSON, videoType: videoType) {
        super.init()
        
        switch videoType {
        case .videoOnChannel:
            if dataJSON["id"]["videoId"].string != nil {
                videoID = (dataJSON["id"]["videoId"].string)!
            }
            break
            
        case .videoOnPlaylist:
            if dataJSON["snippet"]["resourceId"]["videoId"].string != nil {
                videoID = (dataJSON["snippet"]["resourceId"]["videoId"].string)!
            }
            playlistID = (dataJSON["snippet"]["playlistId"].string)!
            break
            
        case .playlistOnChannel:
            if dataJSON["id"].string != nil {
                playlistID = (dataJSON["id"].string)!
            }
            break
            
        case .none:
            break
        }
        
        title = (dataJSON["snippet"]["title"].string)!
        descr = (dataJSON["snippet"]["description"].string)!
        guard let thumb = dataJSON["snippet"]["thumbnails"]["high"]["url"].string else {
            print("---> sem thumbnail")
            return
        }
        thumbnail = thumb
    }
}

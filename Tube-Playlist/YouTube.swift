//
//  YouTube.swift
//  Tube-Playlist
//
//  Created by C McGhee on 2/19/17.
//  Copyright © 2017 C McGhee. All rights reserved.
//

import UIKit
import SwiftyJSON

class YouTube: NSObject {
    
    var kind : String?
    var eta : String?
    var previousPageToken : String?
    var nextPageToken : String?
    var totalResults : String?
    var resultsPerPage : String?
    var items : [YouTubeModel]?
    
    override init() {
        kind = ""
        eta = ""
        previousPageToken = ""
        nextPageToken = ""
        totalResults = ""
        resultsPerPage = ""
        items = [YouTubeModel]()
    }
    
    required init(dataJSON: JSON) {
        super.init()
        if dataJSON["kind"].string != nil {
            kind = (dataJSON["kind"].string)!
        }
        if dataJSON["eta"].string != nil {
            eta = (dataJSON["eta"].string)!
        }
        if dataJSON["previousPageToken"].string != nil {
            previousPageToken = (dataJSON["previousPageToken"].string)!
        }
        if dataJSON["nextPageToken"].string != nil {
            nextPageToken = (dataJSON["nextPageToken"].string)!
        }
        else {
            nextPageToken = ""
        }
        if dataJSON["totalResults"].string != nil {
            totalResults = (dataJSON["totalResults"].string)!
        }
        if dataJSON["resultsPerPage"].string != nil {
            resultsPerPage = (dataJSON["resultsPerPage"].string)!
        }
        
        items = [YouTubeModel]()
        if dataJSON["items"].array != nil {
            
            let videosArray = dataJSON["items"].arrayValue
            var type : videoType = .none
            
            if kind == videoKind.allVideos.rawValue {
                type = .videoOnChannel
            }
            else if kind == videoKind.allPlaylists.rawValue {
                type = .playlistOnChannel
            }
            else if kind == videoKind.allVideosOnPlaylist.rawValue {
                type = .videoOnPlaylist
            }
            
            for video in videosArray {
                let model = YouTubeModel(dataJSON: video, videoType: type)
                items?.append(model)
                
            }
        }
        
    }
}


//
//  YouTubeManager.swift
//  Tube-Playlist
//
//  Created by C McGhee on 2/23/17.
//  Copyright © 2017 C McGhee. All rights reserved.
//

import UIKit
import SwiftyJSON

class YouTubeManager: NSObject {
    //MARK: - YouTube API Keys
    let API_KEY = ""
    let CHANNEL_ID = "" // Apple Channel ID
    let MAX_RESULTS = "5"
    
    //MARK: - Variables
    let manager = APIManager()
    
    
    //MARK: - Custom Methods
    func fetchYouTubeData (urlAPI: API, videoType: videoType, parameters: parameter, pageToken: String, playlist: String, completion: @escaping(Any?) -> Void) {
        let params = transformToParameterFormat(param: parameters, playlistID: playlist, pageToken: pageToken)
        //self.models.removeAll()
        manager.getFrom(urlAPI.rawValue, parameters: params) { (result) in
            if let error = result as? Error {
                print("Error: \(error.localizedDescription)")
                completion(error)
            }
            else if (result as? Data) != nil {
                let json = JSON(data: result as! Data)
                let ytModel = YouTube(dataJSON: json)
                completion(ytModel)
            }
            else {
                print("Something else was returned: \(result.debugDescription)")
                completion(result)
            }
        }
    }
    
    private func transformToParameterFormat(param: parameter, playlistID : String, pageToken: String) -> Dictionary <String, Any> {
        var defaultParameters = ["key": API_KEY, "part": "snippet", "maxResults": MAX_RESULTS]
        if pageToken.characters.count > 0 {
            defaultParameters.updateValue(pageToken, forKey: "pageToken")
        }
        switch param {
        case .allVideos:
            defaultParameters.updateValue(CHANNEL_ID, forKey: "channelId")
            defaultParameters.updateValue("date", forKey: "order")
            return defaultParameters
            
        case .allPlaylists:
            defaultParameters.updateValue(CHANNEL_ID, forKey: "channelId")
            return defaultParameters
            
        case .allVideosOnPlaylist:
            if playlistID.characters.count > 0 {
                defaultParameters.updateValue(playlistID, forKey: "playlistId")
            }
            return defaultParameters
        }
    }
}

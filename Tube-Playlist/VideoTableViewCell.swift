//
//  VideoTableViewCell.swift
//  Tube-Playlist
//
//  Created by C McGhee on 2/23/17.
//  Copyright © 2017 C McGhee. All rights reserved.
//

import UIKit
// import Kingfisher
import youtube_ios_player_helper

class VideoTableViewCell: UITableViewCell {

    var video = YouTubeModel()
    
    @IBOutlet weak var thumbnailImgView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var ytIndicatorView: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureVideoInfo(_ video : YouTubeModel) {
        self.video = video
        
        playerView.delegate = self
        
        if let videoTitle = self.video.title {
            titleLabel.text = videoTitle
        }
        
        if let videoDescription = self.video.descr {
            descriptionLabel.text = videoDescription
        }
        
        if let videoThumbnail = self.video.thumbnail {
            // thumbnailImgView.kf.setImage(with: URL(string : videoThumbnail))
        }
    }
    
}

//MARK: - YTPlayerView Delegate Methods
extension VideoTableViewCell : YTPlayerViewDelegate {
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
            
        case .buffering:
            print("buffering")
            self.ytIndicatorView.startAnimating()
            break
            
        case .ended:
            print("ended")
            break
            
        case .paused:
            print("paused")
            self.ytIndicatorView.stopAnimating()
            break
            
        case .playing:
            print("playing")
            self.ytIndicatorView.stopAnimating()
            break
            
        case .queued:
            print("queued")
            break
            
        case .unknown:
            print("unkown")
            break
            
        case .unstarted:
            print("unstarted")
            break
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.ytIndicatorView.stopAnimating()
        self.playerView.playVideo()
    }
}

